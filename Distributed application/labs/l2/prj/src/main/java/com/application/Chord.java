package com.application;

import java.util.ArrayList;
import java.util.List;

public class Chord {
	private int m;
	private List<ChordNode> nodes = null;
	
	public Chord(int m, List<Integer> activeNodes) {
		this.m = m;
		initialize(activeNodes);
	}
	
	private void initialize(List<Integer> activeNodes) {
		nodes = new ArrayList<>();
		for (int i = 0; i < Math.pow(2, m); i++){
			nodes.add(new ChordNode(i, m));
		}
		
		for(int i = 0; i < activeNodes.size(); i++){
			int predecessorIndex = (i - 1) % m;
			int successorIndex = (i + 1) % m;
			
			int predecessorId = activeNodes.get(predecessorIndex);
			int successorId = activeNodes.get(successorIndex);
			int chordNodeId = activeNodes.get(i);
			
			ChordNode node = nodes.get(chordNodeId);
			ChordNode successor = nodes.get(successorId);
			ChordNode predecessor = nodes.get(predecessorId);
			
			node.setSuccessorAndPredecessor(successor, predecessor);
		}
		nodes.forEach(ChordNode::generateFingerTable);
	}
	
	@Override
	public String toString() {
		return "Chord{" + "m=" + m + ", nodes=" + nodes + '}';
	}
}
