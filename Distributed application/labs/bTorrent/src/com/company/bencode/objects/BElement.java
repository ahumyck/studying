package com.company.bencode.objects;

abstract public class BElement implements Comparable {
    abstract public Object getValue();

    public abstract boolean equals(Object o);

    abstract public int hashCode();

}
