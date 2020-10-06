package com.application.comparators;

public class Interval {
	public static boolean rightIn(int left, int right, int value) {
		return action(left, right, value, Operator.LESS, Operator.LESS_OR_EQUAL, true);
	}

	public static boolean leftIn(int left, int right, int value) {
		return action(left, right, value, Operator.LESS_OR_EQUAL, Operator.LESS, true);
	}

	public static boolean in(int left, int right, int value) {
		return action(left, right, value, Operator.LESS, Operator.LESS, false);
	}

	public static boolean bothIn(int left, int right, int value) {
		return action(left, right, value, Operator.LESS_OR_EQUAL, Operator.LESS_OR_EQUAL, true);
	}

	private static boolean action(int left, int right, int value, Operator op1, Operator op2, boolean defaultValue){
		if (left < right) {
			return op1.performAction(left, value) && op2.performAction(value, right);
		} else if (left == right) {
			return defaultValue;
		} else {
			return op1.performAction(left, value) || op2.performAction(value, right);
		}
	}
}
