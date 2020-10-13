package com.company.entities.comparators;

public class Interval {
	public static boolean rightIn(int left, int right, int value) {
		return action(left, right, value, Operator.LESS_THEN, Operator.LESS_OR_EQUAL_THEN, true);
	}

	public static boolean leftIn(int left, int right, int value) {
		return action(left, right, value, Operator.LESS_OR_EQUAL_THEN, Operator.LESS_THEN, false);
	}

	public static boolean in(int left, int right, int value) {
		return action(left, right, value, Operator.LESS_THEN, Operator.LESS_THEN, false);
	}

//	public static boolean bothIn(int left, int right, int value) {
//		return action(left, right, value, Operator.LESS_OR_EQUAL_THEN, Operator.LESS_OR_EQUAL_THEN, true);
//	}

	private static boolean action(int left, int right, int value, Operator op1, Operator op2, boolean defaultValue){
		if (left < right) {
			return op1.performComparison(left, value) && op2.performComparison(value, right);
		} else if (left == right) {
			return defaultValue;
		} else {
			return op1.performComparison(left, value) || op2.performComparison(value, right);
		}
	}
}
