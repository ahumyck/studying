package com.application.exceptions;

public class ChordHasNoActiveNodesException extends Exception {
	public ChordHasNoActiveNodesException() {
	}

	public ChordHasNoActiveNodesException(String message) {
		super(message);
	}

	public ChordHasNoActiveNodesException(String message, Throwable cause) {
		super(message, cause);
	}

	public ChordHasNoActiveNodesException(Throwable cause) {
		super(cause);
	}

	public ChordHasNoActiveNodesException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}
}
