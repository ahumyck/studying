package com.application.chord.builder;

import com.application.chord.Chord;

import java.util.List;

public class ChordFactory {

	private static ChordFactory instance = new ChordFactory();

	public static ChordFactory getInstance(){
		return instance;
	}

	public Chord buildChordWithActiveNodes(int m, List<Integer> activeNodes){
		return new Chord(-1);
	}

}
