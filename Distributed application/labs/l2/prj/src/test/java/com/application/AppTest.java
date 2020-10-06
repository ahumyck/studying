package com.application;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

/**
 * Unit test for simple App.
 */
public class AppTest {
	@Test
	public void rightIn() {
		int a = 1;
		int b = 5;
		int value = 3;
		assertTrue(Interval.rightIn(a, b, value));
		assertFalse(Interval.rightIn(b, a, value));

		value = 6;
		assertTrue(Interval.rightIn(b, a, value));
		value = 7;
		assertTrue(Interval.rightIn(b, a, value));
		value = 0;
		assertTrue(Interval.rightIn(b, a, value));
		value = 1;
		assertTrue(Interval.rightIn(b, a, value));

		value = 2;
		assertFalse(Interval.rightIn(b, a, value));
		value = 3;
		assertFalse(Interval.rightIn(b, a, value));
		value = 4;
		assertFalse(Interval.rightIn(b, a, value));
		value = 5;
		assertFalse(Interval.rightIn(b, a, value));

	}
}
