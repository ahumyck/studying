package com.company.entities.comparators;


import com.company.entities.comparators.impl.Less;
import com.company.entities.comparators.impl.LessOrEqual;
import com.company.entities.comparators.impl.More;
import com.company.entities.comparators.impl.MoreOrEqual;

public interface Operator {
	Operator LESS_OR_EQUAL_THEN = new LessOrEqual();
	Operator LESS_THEN = new Less();
	Operator MORE_THEN = new More();
	Operator MORE_OR_EQUAL_THEN = new MoreOrEqual();

	boolean performComparison(int a, int b);
}
