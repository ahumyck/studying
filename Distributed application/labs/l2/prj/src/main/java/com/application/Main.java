package com.application;

import com.application.chord.Chord;

public class Main {
	public static void main(String[] args) throws Exception {
		//https://www.kth.se/social/upload/51647996f276545db53654c0/3-chord.pdf
		int m = 3;
		Chord chord = new Chord(m);
		chord.add(0);
		System.out.println("0 added");
		System.out.println(chord);
		System.out.println("_______________");
		chord.add(5);
		System.out.println("5 added");
		System.out.println(chord);
		System.out.println("_______________");

		try {
			System.out.println("found!!!\n");
//			System.out.println(chord.findSuccessor(1).getId());
//			System.out.println(chord.findSuccessor(2).getId());
//			System.out.println(chord.findSuccessor(3).getId());
//			System.out.println(chord.findSuccessor(4).getId());
//			System.out.println(chord.findSuccessor(5).getId());
//			System.out.println(chord.findSuccessor(6).getId());
//			System.out.println(chord.findSuccessor(7).getId());

		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
}
