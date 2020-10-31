package com.company.bencode.coders;


import com.company.bencode.objects.BInteger;
import com.company.bencode.objects.BList;
import com.company.bencode.objects.BMap;
import com.company.bencode.objects.BString;

import java.math.BigInteger;

public class BDecoder {

    private final String content;
    private int currentIndex = -1;

    public BDecoder(String content) {
        this.content = content;
    }

    public BList decode() {
        BList elements = new BList();

        Integer length = null;
        for (int i = 0; i < content.length(); i++) {
            char symbol = content.charAt(i);
            if (symbol == 'd') {
                elements.add(parseMap(i));
            } else if (symbol == 'l') {
                elements.add(parseList(i));

            } else if (symbol == 'i') {
                elements.add(parseInteger(i + 1));
            }
            i = this.currentIndex;
        }

        return elements;
    }

    private BMap parseMap(int startIndex) {
        BMap map = new BMap();
        BigInteger length = null;
        startIndex += 1; // skip 'd' symbol
        while (true) {
            char symbol = content.charAt(startIndex);
            if (symbol == 'e') {
                break;
            } else if (Character.isDigit(symbol)) {
                length = getNumber(startIndex);
                startIndex = this.currentIndex;
            } else if (symbol == ':') {
                map.put(parseString(startIndex + 1, startIndex + length.intValue() + 1));
                startIndex += (length.intValue() + 1);
            } else if (symbol == 'd') {
                map.put(parseMap(startIndex));
                startIndex = this.currentIndex;
            } else if (symbol == 'l') {
                map.put(parseList(startIndex));
                startIndex = this.currentIndex;
            } else if (symbol == 'i') {
                map.put(parseInteger(++startIndex));
                startIndex = this.currentIndex + 1; //skip 'e' symbol for current integer
                if (startIndex == this.content.length()) {
                    return map;
                }
            }
        }
        this.currentIndex = startIndex + 1; // skip 'e' symbol
        return map;
    }

    private BList parseList(int startIndex) {
        BList list = new BList();
        BigInteger length = null;
        startIndex += 1; // skip 'l' symbol

        while (true) {
            char symbol = content.charAt(startIndex);
            if (symbol == 'e') {
                break;
            } else if (Character.isDigit(symbol)) {
                length = getNumber(startIndex);
                startIndex = this.currentIndex;
            } else if (symbol == ':') {
                list.add(parseString(startIndex + 1, startIndex + length.intValue() + 1));
                startIndex += (length.intValue() + 1);
            } else if (symbol == 'l') {
                //oh my god this stuff is good
                list.add(parseList(startIndex));
                startIndex = this.currentIndex;
            } else if (symbol == 'd') {
                list.add(parseMap(startIndex));
                startIndex = this.currentIndex;
            } else if (symbol == 'i') {
                list.add(parseInteger(++startIndex));
                startIndex = this.currentIndex + 1; //skip 'e' symbol for current integer
                if (startIndex == this.content.length()) {
                    return list;
                }
            }

        }
        this.currentIndex = startIndex + 1; //skip 'e' symbol
        return list;
    }

    private BInteger parseInteger(int startIndex) {
        return new BInteger(getNumber(startIndex));
    }

    private BString parseString(int startIndex, int endIndex) {
        return new BString(this.content.substring(startIndex, endIndex));
    }

    private BigInteger getNumber(int startIndex) {
        StringBuilder builder = new StringBuilder();
        while (true) {
            char digit = this.content.charAt(startIndex);
            if (Character.isDigit(digit) || digit == '-') {
                builder.append(digit);
                startIndex++;
            } else {
                break;
            }
        }
        this.currentIndex = startIndex;
        if (builder.toString().equals("")) {
            return new BigInteger("-1");
        } else {
            return new BigInteger(builder.toString());
        }
    }
}