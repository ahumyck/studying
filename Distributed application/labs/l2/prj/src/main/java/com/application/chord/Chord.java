package com.application.chord;

import com.application.comparators.Interval;
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
	private final FingerPositionCalculator calculator = FingerPositionCalculator.getCalculator();


	public Chord(int m) {
		this.m = m;
		activeNodes = new ArrayList<>();

		nodes = new ArrayList<>();
		int n = (int) Math.pow(2, m);
		for (int i = 0; i < n; i++) {
			nodes.add(new ChordNode(i, m));
		}

	}

	public ChordNode findSuccessor(int id) throws Exception {
		if (activeNodes.size() != 0) {
			return findSuccessorForId(activeNodes.get(0).getId(), id);
		}
		throw new Exception("No active nodes");
	}

	public ChordNode findSuccessorForId(int startChordNodeId, int id) throws Exception {
		return nodes.get(startChordNodeId).findSuccessor(id);
	}

	public Chord add(int index) {
		ChordNode node = nodes.get(index);
		if (isEmpty) {
			initializeFirstChordNode(node);
			isEmpty = false;
		} else {
			initializeAnyChordNode(node);
		}
		activeNodes.add(node);
		activeNodes.sort(Comparator.comparingInt(ChordNode::getId));
		return this;
	}

	private void initializeAnyChordNode(ChordNode anyNode) {
		try {
			anyNode.setActive(true);
			int anyNodeId = anyNode.getId();
			List<FingerTableRecord> records = new ArrayList<>();
			ChordNode activeNode = activeNodes.get(0);

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