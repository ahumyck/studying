package com.application;

public class Interval {
	public static boolean rightIn(int left, int right, int value) {
		if (left < right) {
			return left < value && value <= right;
		} else if (left == right) {
			return true;
		} else {
			return left < value || value <= right;
		}
	}

	public static boolean leftIn(int left, int right, int value) {
		if (left < right) {
			return left <= value && value < right;
		} else if (left == right) {
			return true;
		} else {
			return left <= value || value < right;
		}
	}

	public static boolean in(int left, int right, int value) {
		if (left < right) {
			return left < value && value < right;
		} else if (left == right) {
			return false;
		} else {
			return left < value || value < right;
		}
	}

	public static boolean bothIn(int left, int right, int value) {
		if (left < right) {
			return left <= value && value <= right;
		} else if (left == right) {
			return true;
		} else {
			return left <= value || value <= right;
		}
	}
}
