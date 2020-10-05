package com.application;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

public class Main {
	public static void main(String[] args) {
		List<Integer> indices = Arrays.stream(new int[]{0, 1, 3}).boxed().collect(Collectors.toList());
		Chord chord = new Chord(3, indices);
		System.out.println(chord);
	}
}
