package com.company.entities.table;

import com.company.entities.chord.ChordNode;

import java.util.Objects;

public class FingerTableRecord {
	private ChordNode start;
	private ChordNode end;
	private ChordNode node;

	public FingerTableRecord(ChordNode start, ChordNode end, ChordNode node) {
		this.start = start;
		this.end = end;
		this.node = node;
	}

	public ChordNode getNode() {
		return node;
	}

	public void setNode(ChordNode node) {
		this.node = node;
	}

	public ChordNode getStart() {
		return start;
	}

	public void setStart(ChordNode start) {
		this.start = start;
	}

	public ChordNode getEnd() {
		return end;
	}

	public void setEnd(ChordNode end) {
		this.end = end;
	}

	@Override
	public int hashCode() {
		return Objects.hash(start, end, node);
	}

	@Override
	public String toString() {
		return "\n\t\tFingerTableRecord{" + ", start=" + start.getId() + ", end=" + end.getId() + ", node=" + node.getId() + '}';
	}
}
