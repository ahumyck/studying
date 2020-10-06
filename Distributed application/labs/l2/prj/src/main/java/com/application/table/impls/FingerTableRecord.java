package com.application.table.impls;

import com.application.chord.ChordNode;

public class FingerTableRecord {
	private ChordNode start;
	private ChordNode end;


	/* either startId or successor(startId)
	*  nodeId == startId only and only if startId is active node
	* */
	//	private ChordNode node;
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
	public String toString() {
		StringBuilder builder = new StringBuilder("\n\t\tFingerTableRecord{");
		builder.append(", start=").append(start.getId());
		builder.append(", end=").append(end.getId());
		builder.append(", node=");
		if(node != null){
			builder.append(node.getId());
		}
		else{
			builder.append("null");
		}
		builder.append('}');
		return builder.toString();
	}
}
