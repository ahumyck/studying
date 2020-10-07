package com.application.chord;

import com.application.comparators.Interval;
import com.application.exceptions.ChordHasNoActiveNodesException;
import com.application.exceptions.ChordIndexOutOfBoundException;
import com.application.exceptions.ChordNodeIsNotActiveException;
import com.application.table.FingerPositionCalculator;
import com.application.table.impls.FingerTable;
import com.application.table.impls.FingerTableRecord;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Chord {
	private final int m;
	private final int n;
	private boolean isEmpty = true;
	private final List<ChordNode> nodes;
	private final List<ChordNode> activeNodes;
	private final static FingerPositionCalculator calculator = FingerPositionCalculator.getCalculator();


	public Chord(int n) {
		this.n = n;
		this.m = (int) (Math.log(n) / Math.log(2));
		this.activeNodes = new ArrayList<>();

		this.nodes = new ArrayList<>();
		for (int i = 0; i < n; i++) {
			this.nodes.add(new ChordNode(i));
		}

	}

	public ChordNode findSuccessor(int id) throws ChordHasNoActiveNodesException, ChordNodeIsNotActiveException {
		if (!this.isEmpty) {
			return findSuccessorForId(this.activeNodes.get(0).getId(), id);
		}
		throw new ChordHasNoActiveNodesException("No active nodes");
	}

	public ChordNode findPredecessor(int id) throws ChordHasNoActiveNodesException, ChordNodeIsNotActiveException {
		if (!this.isEmpty) {
			return findPredecessorForId(this.activeNodes.get(0).getId(), id);
		}
		throw new ChordHasNoActiveNodesException("no active nodes");
	}

	private ChordNode findSuccessorForId(int startChordNodeId, int id) throws ChordNodeIsNotActiveException {
		return this.nodes.get(startChordNodeId).findSuccessor(id);
	}

	private ChordNode findPredecessorForId(int startChordNodeId, int id) throws ChordNodeIsNotActiveException {
		return this.nodes.get(startChordNodeId).findPredecessor(id);
	}

	public void add(int index) {
		ChordNode node = this.nodes.get(index);
		if (this.isEmpty) {
			initializeFirstChordNode(node);
			this.isEmpty = false;
		} else {
			initializeAnyChordNode(node);
			updateActiveChordNodesFingerTable(node);
		}
		this.activeNodes.add(node);
		this.activeNodes.sort(Comparator.comparingInt(ChordNode::getId));
	}

	public void remove(int index) {
		try {
			long contained = this.nodes.stream().map(ChordNode::getId).filter(id -> id == index).count();
			if (contained > 0) {
				ChordNode nodeToRemove = this.nodes.get(index);
				ChordNode successor = nodeToRemove.getSuccessor();
				ChordNode predecessor = nodeToRemove.getPredecessor();

				for (int i = 0; i < this.m; i++) {
					updateActiveChordNodesFingerTable(nodeToRemove, predecessor, i);
				}

				predecessor.updateSuccessor(successor);
				successor.updatePredecessor(predecessor);

				this.nodes.set(index, new ChordNode(index));
				this.activeNodes.remove(nodeToRemove);
				this.isEmpty = activeNodes.isEmpty();
				if(!this.isEmpty){
					this.activeNodes.sort(Comparator.comparingInt(ChordNode::getId));
				}
			} else {
				throw new ChordIndexOutOfBoundException();
			}
		}
		catch (ChordNodeIsNotActiveException e) {
			e.printStackTrace();
		}

	}

	private void updateActiveChordNodesFingerTable(ChordNode deleted, ChordNode predecessor, int recordIndex) {
		if (deleted.equals(predecessor)) {
			return;
		}
		try {
			FingerTable table = predecessor.getFingerTable();
			FingerTableRecord record = table.getFinger(recordIndex);
			ChordNode node = record.getNode();
			if (node.equals(deleted)) {
				ChordNode successor = deleted.getSuccessor();
				record.setNode(successor);
				table.setRecord(record, recordIndex);
			}
			updateActiveChordNodesFingerTable(deleted, predecessor.getPredecessor(), recordIndex);
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void updateActiveChordNodesFingerTable(ChordNode node) {
		try {
			for (int i = 0; i < m; i++) {
				int id = calculator.calculatePredecessorIndex(node.getId(), i, n);
				ChordNode predecessor;
				if (this.nodes.get(id).isActive()) {
					predecessor = this.nodes.get(id);
				} else {
					predecessor = findPredecessor(id);
				}
				updateFingers(node, predecessor, i);
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void updateFingers(ChordNode node, ChordNode predecessor, int fingerIndex) {
		if (node.getId() == predecessor.getId()) {
			return;
		}
		try {
			FingerTableRecord record = predecessor.getFingerTable().getFinger(fingerIndex);
			if (Interval.leftIn(record.getStart().getId(), record.getNode().getId(), node.getId())) {
				record.setNode(node);
				updateFingers(node, predecessor.getPredecessor(), fingerIndex);
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void initializeAnyChordNode(ChordNode anyNode) {
		try {
			anyNode.setActive(true);
			int anyNodeId = anyNode.getId();
			List<FingerTableRecord> records = new ArrayList<>();

			int startId = calculator.calculateSuccessorIndex(anyNodeId, 0, n);
			int endId = calculator.calculateSuccessorIndex(anyNodeId, 1, n);
			ChordNode nodeSuccessor = findSuccessor(startId);
			records.add(new FingerTableRecord(this.nodes.get(startId), this.nodes.get(endId), nodeSuccessor));

			ChordNode successor = findSuccessor(anyNodeId);
			ChordNode predecessor = successor.getPredecessor();

			anyNode.updateSuccessor(successor).updatePredecessor(predecessor);
			successor.updatePredecessor(anyNode);
			predecessor.updateSuccessor(anyNode);


			for (int i = 1; i < this.m; i++) {
				startId = calculator.calculateSuccessorIndex(anyNodeId, i, this.n);
				endId = calculator.calculateSuccessorIndex(anyNodeId, i + 1, this.n);
				if (!Interval.leftIn(anyNodeId, nodeSuccessor.getId(), startId)) {
					nodeSuccessor = findSuccessor(startId);
				}
				records.add(new FingerTableRecord(nodes.get(startId), nodes.get(endId), nodeSuccessor));
			}
			anyNode.updateFingerTable(records);
		}
		catch (Exception e) {
			e.getStackTrace();
		}
	}

	private void initializeFirstChordNode(ChordNode firstNode) {
		try {
			int firstNodeId = firstNode.getId();
			List<FingerTableRecord> records = new ArrayList<>();
			for (int i = 0; i < this.m; i++) {
				int startId = calculator.calculateSuccessorIndex(firstNodeId, i, this.n);
				int endId = calculator.calculateSuccessorIndex(firstNodeId, i + 1, this.n);
				records.add(new FingerTableRecord(this.nodes.get(startId), this.nodes.get(endId), firstNode));
			}
			firstNode.setActive(true);
			firstNode.updateSuccessor(firstNode).updatePredecessor(firstNode).updateFingerTable(records);

		}
		catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException();
		}
	}

	@Override
	public String toString() {
		return "Chord{" + "n=" + this.n + ", m=" + this.m + ", nodes=" + this.nodes + '}';
	}
}
