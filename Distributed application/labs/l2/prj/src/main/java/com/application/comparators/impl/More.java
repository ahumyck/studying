package com.application.comparators.impl;

import com.application.comparators.Operator;

public class More implements Operator {
	@Override
	public boolean performAction(int a, int b) {
		return a > b;
	}
}
