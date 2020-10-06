package com.application.comparators;

import com.application.comparators.impl.Less;
import com.application.comparators.impl.LessOrEqual;
import com.application.comparators.impl.More;
import com.application.comparators.impl.MoreOrEqual;

public interface Operator {
	Operator LESS_OR_EQUAL = new LessOrEqual();
	Operator LESS = new Less();
	Operator MORE = new More();
	Operator MORE_OR_EQUAL = new MoreOrEqual();

	boolean performAction(int a, int b);
}
