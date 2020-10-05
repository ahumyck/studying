package com.application.table.impls;

import com.application.Interval;
import com.application.StartCalculator;

import java.math.BigInteger;

public class FingerTableRecord {
	private int start;
	private Interval interval;
	private int successor;
	
	public FingerTableRecord(int start, int idx, int m) {
		this.start = start;
		this.interval = new Interval(this.start, StartCalculator.calculateNextStart(start, idx, m));
		//TODO:
		this.successor = -1;
	}
}
