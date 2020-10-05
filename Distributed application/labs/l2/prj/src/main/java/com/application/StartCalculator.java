package com.application;

public class StartCalculator {
	/**
	 *
	 * @param n - node index
	 * @param i - record index in node
	 * @param m - number of total records
	 * @return calculates formula (2^(i - 1) + n) mod m
	 */
	public static int calculateNextStart(int n, int i, int m) {
		return (int) ((n + Math.pow(2, i - 1)) % m);
	}
}
