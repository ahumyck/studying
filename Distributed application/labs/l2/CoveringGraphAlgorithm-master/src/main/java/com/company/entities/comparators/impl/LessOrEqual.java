package com.company.entities.comparators.impl;


import com.company.entities.comparators.Operator;

public class LessOrEqual implements Operator {
	@Override
	public boolean performComparison(int a, int b) {
		return a <= b;
	}
}
