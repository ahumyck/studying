package com.application.chord;

import com.application.comparators.Interval;
import com.application.exceptions.ChordNodeIsNotActiveException;
import com.application.table.FingerTable;
import com.application.table.FingerTableRecord;

import java.util.List;
import java.util.Objects;


public class ChordNode {
	private final int id;
	private boolean isActive = false;

	private ChordNode predecessor = null;
	private ChordNode successor = null;
	private FingerTable fingerTable = null;

	public ChordNode(int id) {
		this.id = id;
	}

	public ChordNode findSuccessor(int id) throws ChordNodeIsNotActiveException {
		if (this.id == id) {
			return this;
		}
		return findPredecessor(id).getSuccessor();

	}

	public ChordNode findPredecessor(int id) throws ChordNodeIsNotActiveException {
		ChordNode node = this;
		while (!Interval.rightIn(node.getId(), node.getSuccessor().getId(), id)) {
			node = node.getClosestPrecedingFinger(id);
		}
		return node;
	}

	private ChordNode getClosestPrecedingFinger(int id) throws ChordNodeIsNotActiveException {
		if (isActive) {
			for (int i = fingerTable.size() - 1; i >= 0; i--) {
				ChordNode node = fingerTable.getFinger(i).getNode();
				if (Interval.in(this.id, id, node.getId())) {
					return node;
				}
			}
			return this;
		} else {
			throw new ChordNodeIsNotActiveException(this.id);
		}
	}


	public int getId() {
		return id;
	}

	public FingerTable getFingerTable() throws ChordNodeIsNotActiveException {
		if (isActive) {
			return fingerTable;
		}
		throw new ChordNodeIsNotActiveException(this.id);
	}

	public void updateFingerTable(FingerTable fingerTable) throws ChordNodeIsNotActiveException {
		if (isActive) {
			this.fingerTable = fingerTable;
		}
		throw new ChordNodeIsNotActiveException(this.id);
	}

	public void updateFingerTable(List<FingerTableRecord> records) throws ChordNodeIsNotActiveException {
		if (isActive) {
			this.fingerTable = new FingerTable(records);
			return;
		}
		throw new ChordNodeIsNotActiveException(this.id);
	}

	public ChordNode updatePredecessor(ChordNode predecessor) throws ChordNodeIsNotActiveException {
		if (isActive) {
			this.predecessor = predecessor;
			return this;
		}
		throw new ChordNodeIsNotActiveException(this.id);
	}

	public ChordNode updateSuccessor(ChordNode successor) throws ChordNodeIsNotActiveException {
		if (isActive) {
			this.successor = successor;
			return this;
		}
		throw new ChordNodeIsNotActiveException(this.id);
	}

	public ChordNode getPredecessor() throws ChordNodeIsNotActiveException {
		if (isActive) {
			return predecessor;
		}
		throw new ChordNodeIsNotActiveException(this.id);
	}

	public ChordNode getSuccessor() throws ChordNodeIsNotActiveException {
		if (isActive) {
			return successor;
		}
		throw new ChordNodeIsNotActiveException(this.id);
	}

	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean active) {
		isActive = active;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) {
			return true;
		}
		if (o == null || getClass() != o.getClass()) {
			return false;
		}
		ChordNode chordNode = (ChordNode) o;
		return id == chordNode.id;
	}

	@Override
	public int hashCode() {
		return Objects.hash(id);
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
