package com.application;

public class Calculator {

	private static final Calculator calculator = new Calculator();

	public static Calculator getCalculator() {
		return calculator;
	}

	/**
	 *
	 * @param n - node index
	 * @param i - record index in node
	 * @param m - number of total records
	 * @return calculates formula (2^i + n) mod m
	 */
	public int calculateSuccessorIndex(int n, int i, int m) {
		return (int) ((n + Math.pow(2, i)) % m);
	}

	public int calculatePredecessorIndex(int n, int i, int m) {
		return (int) ((n - Math.pow(2, i) + m) % m);
	}
}
