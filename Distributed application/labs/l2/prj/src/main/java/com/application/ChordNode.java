package com.application;

import com.application.table.impls.FingerTable;
import com.application.table.impls.FingerTableRecord;

import java.util.ArrayList;


public class ChordNode {
	private int id;
	private ChordNode predecessor;
	private ChordNode successor;
	private FingerTable fingerTable;
	private int m;
	private boolean isActive = false;
	
	public ChordNode(int id, int m){
		this.id = id;
		this.m = m;
	}
	
	public ChordNode(int id, int m, ChordNode successor, ChordNode predecessor) {
		this.id = id;
		this.m = m;
		initialize(successor, predecessor);
	}
	
	public ChordNode setSuccessorAndPredecessor(ChordNode successor, ChordNode predecessor){
		initialize(successor, predecessor);
		return this;
	}
	
	private void initialize(ChordNode successor, ChordNode predecessor){
		this.successor = successor;
		this.predecessor = predecessor;
		this.isActive = true;
	}
	
	public ChordNode generateFingerTable(){
		this.fingerTable = new FingerTable();
		return this;
	}
	
	public int getId() {
		return id;
	}
	
	public boolean isActive() {
		return isActive;
	}
	
	@Override
	public String toString() {
		return "ChordNode{" + "id=" + id + ", predecessor=" + predecessor.getId() + ", successor=" + successor.getId() + ", isActive=" + isActive + "}\n";
	}
}
