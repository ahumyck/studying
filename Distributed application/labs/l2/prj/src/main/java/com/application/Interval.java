package com.application;

import java.math.BigInteger;

public class Interval {
	private int start;
	private int end;
	
	public Interval(int start, int end) {
		this.start = start;
		this.end = end;
	}
	
	public int getStart() {
		return start;
	}
	
	public int getEnd() {
		return end;
	}
	/**
	 * method returns true if value in [start; end)
	 * false otherwise
	 * */
	public boolean in(int value) {

		return start <= value && value < end;
	}
	
}
