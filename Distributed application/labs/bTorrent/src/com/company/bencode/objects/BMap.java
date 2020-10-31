package com.company.bencode.objects;

import java.util.*;

public class BMap extends BElement {
    private final Map<BElement, BElement> map = new TreeMap<>();
    private final List<BElement> elementToHide = new ArrayList<>();
    private BElement cacheKey = null;
    private BElement cacheValue = null;

    public BMap() {
    }

    public void put(BElement element) {
        if (cacheKey == null && cacheValue == null) {
            cacheKey = element;
        } else if (cacheKey != null && cacheValue == null) {
            cacheValue = element;
            map.put(cacheKey, cacheValue);
            cacheKey = null;
            cacheValue = null;
        }
    }

    public void put(BElement key, BElement value) {
        map.putIfAbsent(key, value);
    }

    public BElement get(BElement key) {
        return map.get(key);
    }

    public Set<BElement> keySet() {
        return map.keySet();
    }

    public void hide(BElement key) {
        if (map.get(key) == null) {
            throw new RuntimeException("BMap doesn't contain such key");
        } else {
            elementToHide.add(key);
        }
    }

    @Override
    public Map<BElement, BElement> getValue() {
        return map;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BMap otherMap = (BMap) o;
        return Objects.equals(map, otherMap.map);
    }

    @Override
    public int hashCode() {
        return Objects.hash(map);
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder("{\n");
        for (BElement key : map.keySet()) {
            if (!elementToHide.contains(key)) {
                BElement value = map.get(key);
                builder.append('\t').append(key.toString()).append(": ").append(value.toString()).append('\n');
            }
        }
        builder.append("\n}");
        return builder.toString();
    }

    @Override
    public int compareTo(Object o) {
        boolean equals = equals(o);
        if (equals)
            return 0;
        else return -1;
    }
}
