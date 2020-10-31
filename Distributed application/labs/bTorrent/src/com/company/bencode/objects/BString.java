package com.company.bencode.objects;

import java.util.Objects;

public class BString extends BElement {
    private final String value;

    public BString(String value) {
        this.value = value;
    }

    @Override
    public Object getValue() {
        return value;
    }

    @Override
    public String toString() {
        return value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BString bString = (BString) o;
        return value.equals(bString.value);
    }

    @Override
    public int hashCode() {
        return Objects.hash(value);
    }

    @Override
    public int compareTo(Object o) {
        if (this == o) return 0;
        if (o == null || getClass() != o.getClass()) return -1;
        BString otherString = (BString) o;
        return value.compareTo(otherString.value);
    }
}
