package com.application.chord;

import com.application.comparators.Interval;
import com.application.exceptions.ChordHasNoActiveNodesException;
import com.application.exceptions.ChordNodeIsNotActiveException;
import com.application.table.FingerPositionCalculator;
import com.application.table.impls.FingerTableRecord;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Chord {
	private final int m;
	private boolean isEmpty = true;
	private final List<ChordNode> nodes;
	private final List<ChordNode> activeNodes;
	private final static FingerPositionCalculator calculator = FingerPositionCalculator.getCalculator();


	public Chord(int m) {
		this.m = m;
		this.activeNodes = new ArrayList<>();

		this.nodes = new ArrayList<>();
		int n = (int) Math.pow(2, m);
		for (int i = 0; i < n; i++) {
			this.nodes.add(new ChordNode(i));
		}

	}

	public ChordNode findSuccessor(int id) throws ChordHasNoActiveNodesException, ChordNodeIsNotActiveException {
		if (!isEmpty) {
//			if (nodes.get(id).isActive()) {
//				return nodes.get(id).getSuccessor();
//			}
			return findSuccessorForId(activeNodes.get(0).getId(), id);
		}
		throw new ChordHasNoActiveNodesException("No active nodes");
	}

	public ChordNode findPredecessor(int id) throws ChordHasNoActiveNodesException, ChordNodeIsNotActiveException {
		if (!isEmpty) {
			return findPredecessorForId(activeNodes.get(0).getId(), id);
		}
		throw new ChordHasNoActiveNodesException("no active nodes");
	}

	private ChordNode findSuccessorForId(int startChordNodeId, int id) throws ChordNodeIsNotActiveException {
		return nodes.get(startChordNodeId).findSuccessor(id);
	}

	private ChordNode findPredecessorForId(int startChordNodeId, int id) throws ChordNodeIsNotActiveException {
		return nodes.get(startChordNodeId).findPredecessor(id);
	}

	public void add(int index) {
		ChordNode node = nodes.get(index);
		if (isEmpty) {
			initializeFirstChordNode(node);
			isEmpty = false;
		} else {
			initializeAnyChordNode(node);
			updateActiveChordNodesFingerTable(node);
		}
		activeNodes.add(node);
		activeNodes.sort(Comparator.comparingInt(ChordNode::getId));
	}

	private void updateActiveChordNodesFingerTable(ChordNode node) {
		try {
			for (int i = 0; i < m; i++) {
				int id = calculator.calculatePredecessorIndex(node.getId(), i, m);
				ChordNode predecessor;
				if (nodes.get(id).isActive()) {
					predecessor = nodes.get(id);
				} else {
					predecessor = findPredecessor(id);
				}
				updateFingers(node, predecessor, i);
			}
		}
		catch (Exception ignored) {
		}
	}

	private void updateFingers(ChordNode joinNode, ChordNode predecessorNode, int fingerIndex) {
		if (joinNode.getId() == predecessorNode.getId()) {
			return;
		}
		try {
			FingerTableRecord record = predecessorNode.getFingerTable().getFinger(fingerIndex);
			if (Interval.leftIn(record.getStart().getId(), record.getNode().getId(), joinNode.getId())) {
				record.setNode(joinNode);
				updateFingers(joinNode, predecessorNode.getPredecessor(), fingerIndex);
			}
		}
		catch (Exception ignored) {

		}
	}

	private void initializeAnyChordNode(ChordNode anyNode) {
		try {
			anyNode.setActive(true);
			int anyNodeId = anyNode.getId();
			List<FingerTableRecord> records = new ArrayList<>();

			int startId = calculator.calculateSuccessorIndex(anyNodeId, 0, m);
			int endId = calculator.calculateSuccessorIndex(anyNodeId, 1, m);
			ChordNode nodeSuccessor = findSuccessor(startId);
			records.add(new FingerTableRecord(nodes.get(startId), nodes.get(endId), nodeSuccessor));

			ChordNode successor = findSuccessor(anyNodeId);
			ChordNode predecessor = successor.getPredecessor();

			anyNode.updateSuccessor(successor).updatePredecessor(predecessor);
			successor.updatePredecessor(anyNode);
			predecessor.updateSuccessor(anyNode);


			for (int i = 1; i < m; i++) {
				startId = calculator.calculateSuccessorIndex(anyNodeId, i, m);
				endId = calculator.calculateSuccessorIndex(anyNodeId, i + 1, m);
				if (!Interval.leftIn(anyNodeId, nodeSuccessor.getId(), startId)) {
					nodeSuccessor = findSuccessor(startId);
				}
				records.add(new FingerTableRecord(nodes.get(startId), nodes.get(endId), nodeSuccessor));
			}
			anyNode.updateFingerTable(records);
		}
		catch (Exception ignored) {
		}
	}

	private void initializeFirstChordNode(ChordNode firstNode) {
		try {
			firstNode.setActive(true);
			int firstNodeId = firstNode.getId();
			List<FingerTableRecord> records = new ArrayList<>();
			for (int i = 0; i < m; i++) {
				int startId = calculator.calculateSuccessorIndex(firstNodeId, i, m);
				int endId = calculator.calculateSuccessorIndex(firstNodeId, i + 1, m);
				records.add(new FingerTableRecord(nodes.get(startId), nodes.get(endId), firstNode));
			}
			firstNode.updateSuccessor(firstNode).updatePredecessor(firstNode).updateFingerTable(records);

		}
		catch (Exception ignored) {
		}
	}

	@Override
	public String toString() {
		return "Chord{" + "m = " + m + ", nodes = \n" + nodes + '}';
	}
}
