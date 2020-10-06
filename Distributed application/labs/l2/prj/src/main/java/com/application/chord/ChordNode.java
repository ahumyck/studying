package com.application.chord;

import com.application.Interval;
import com.application.table.impls.FingerTable;
import com.application.table.impls.FingerTableRecord;
import sun.reflect.annotation.ExceptionProxy;

import java.util.List;


public class ChordNode {
	private final int id;
	private boolean isActive = false;
	private ChordNode predecessor = null;
	private ChordNode successor = null;
	private FingerTable fingerTable = null;
	private final int m;

	public ChordNode(int id, int m) {
		this.id = id;
		this.m = m;
	}

	public ChordNode findSuccessor(int id) throws Exception {
		return findPredecessor(id).getSuccessor();
		//		if (isActive) {
		//			for (int i = m - 1; i >= 0; i--) {
		//				FingerTableRecord finger = fingerTable.getFinger(i);
		//				ChordNode start = finger.getStart();
		//				ChordNode node = finger.getNode();
		//				if (Interval.bothIn(start.id, node.id, id)) {
		//					return node;
		//				}
		//			}
		//			return this;
		//		} else {
		//			throw new Exception("ChordNode=" + this.id + " is not active");
		//		}
	}

	public ChordNode findPredecessor(int id) throws Exception {
		ChordNode node = this;
		while (!Interval.rightIn(node.getId(), node.getSuccessor().getId(), id)) {
			node = getClosestPrecedingFinger(id);
		}
		return node;
		//		return this;
	}

	private ChordNode getClosestPrecedingFinger(int id) throws Exception {
		if (isActive) {
			for (int i = m - 1; i >= 0; i--) {
				ChordNode node = fingerTable.getFinger(i).getNode();
				if (Interval.in(this.id, id, node.getId())) {
					return node;
				}
			}
			return this;
		} else {
			throw new Exception("ChordNode=" + this.id + " is not active");
		}
	}


	public int getId() {
		return id;
	}

	public FingerTable getFingerTable() throws Exception {
		if (isActive) {
			return fingerTable;
		}
		throw new Exception("ChordNode=" + this.id + " is not active");
	}

	public ChordNode updateFingerTable(FingerTable fingerTable) throws Exception {
		if (isActive) {
			this.fingerTable = fingerTable;
			return this;
		}
		throw new Exception("ChordNode=" + this.id + " is not active");
	}

	public ChordNode updateFingerTable(List<FingerTableRecord> records) throws Exception {
		if (isActive) {
			this.fingerTable = new FingerTable(records);
			return this;
		}
		throw new Exception("ChordNode=" + this.id + " is not active");
	}

	public ChordNode updatePredecessor(ChordNode predecessor) throws Exception {
		if (isActive) {
			this.predecessor = predecessor;
			return this;
		}
		throw new Exception("ChordNode=" + this.id + " is not active");
	}

	public ChordNode updateSuccessor(ChordNode successor) throws Exception {
		if (isActive) {
			this.successor = successor;
			return this;
		}
		throw new Exception("ChordNode=" + this.id + " is not active");
	}

	public ChordNode getPredecessor() throws Exception {
		if (isActive) {
			return predecessor;
		}
		throw new Exception("ChordNode=" + this.id + " is not active");
	}

	public ChordNode getSuccessor() throws Exception {
		if (isActive) {
			return successor;
		}
		throw new Exception("ChordNode=" + this.id + " is not active");
	}

	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean active) {
		isActive = active;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder("ChordNode{id = ");
		builder.append(this.id);
		builder.append(", isActive = ").append(isActive);
		if (isActive) {
			builder.append(", successor = ").append(successor.id);
			builder.append(", predecessor = ").append(predecessor.id);
			builder.append(", finger table = ").append(fingerTable.toString());
		}
		builder.append('}').append('\n');
		return builder.toString();
	}
}
