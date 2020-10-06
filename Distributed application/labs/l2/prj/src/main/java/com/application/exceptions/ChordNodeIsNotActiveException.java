package com.application.exceptions;

public class ChordNodeIsNotActiveException extends Exception {



	public ChordNodeIsNotActiveException(int id) {
		super("ChordNode=" + id + " is not active");
	}

	public ChordNodeIsNotActiveException(String message) {
		super(message);
	}

	public ChordNodeIsNotActiveException(String message, Throwable cause) {
		super(message, cause);
	}

	public ChordNodeIsNotActiveException(Throwable cause) {
		super(cause);
	}

	public ChordNodeIsNotActiveException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}
}
