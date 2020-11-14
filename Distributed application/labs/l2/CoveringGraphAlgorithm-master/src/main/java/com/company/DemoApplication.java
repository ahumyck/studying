package com.company;

import com.company.entities.chord.Chord;
import com.company.entities.exceptions.ChordHasNoActiveNodesException;
import com.company.entities.exceptions.ChordNodeIsNotActiveException;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;


public class DemoApplication {


	public static void main(String[] args) throws ChordNodeIsNotActiveException, ChordHasNoActiveNodesException {
		Chord chord = Chord.createChord(8);
		chord.add(0);
		chord.add(1);
		chord.add(3);
		System.out.println(chord);

	}
}
