package com.company.bencode.objects;

import java.math.BigInteger;
import java.util.Objects;

public class BInteger extends BElement {

    private final BigInteger value;

    public BInteger(BigInteger value) {
        this.value = value;
    }

    @Override
    public BigInteger getValue() {
        return value;
    }

    @Override
    public String toString() {
        return value.toString();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BInteger bInteger = (BInteger) o;
        return value.equals(bInteger.value);
    }

    @Override
    public int hashCode() {
        return Objects.hash(value);
    }

    @Override
    public int compareTo(Object o) {
        if (this == o) return 0;
        if (o == null || getClass() != o.getClass()) return -1;
        BInteger otherInteger = (BInteger) o;
        return value.compareTo(otherInteger.value);
    }
}
