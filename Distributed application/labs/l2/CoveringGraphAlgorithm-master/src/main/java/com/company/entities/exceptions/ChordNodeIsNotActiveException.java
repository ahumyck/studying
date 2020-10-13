package com.company.entities.exceptions;

public class ChordNodeIsNotActiveException extends Exception {

    public ChordNodeIsNotActiveException(int id) {
        super("ChordNode=" + id + " is not active");
    }

}
