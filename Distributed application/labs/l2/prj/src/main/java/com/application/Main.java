package com.application;

import com.application.chord.Chord;

public class Main {
	public static void main(String[] args) throws Exception {
		//https://www.kth.se/social/upload/51647996f276545db53654c0/3-chord.pdf
		//http://www.cs.uoi.gr/~pitoura/courses/p2p/chord.pdf
		//http://www.inf.ed.ac.uk/teaching/courses/ip/chord-desc.html
		int n = 8;
		Chord chord = Chord.createChord(n);
		chord.add(0);
		chord.add(1);
		chord.add(3);
		System.out.println(chord);
		System.out.println("\n\n\n");
		chord.add(6);
		System.out.println(chord);
		System.out.println("\n\n\n");
		chord.remove(1);
		chord.remove(3);
		System.out.println(chord);
		System.out.println();
		int id = 3;

		System.out.println("successor(" + id + ")=" + chord.findSuccessor(id).getId());
	}
}
