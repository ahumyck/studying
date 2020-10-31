package com.company;

import com.company.bencode.coders.BDecoder;
import com.company.bencode.objects.BMap;
import com.company.bencode.objects.BString;

import java.io.IOException;

public class Main {

    public static void main(String[] args) throws IOException {
//        List<String> executionResult = ScriptPython.runScript();
        String content = new ContentReader("D:/labs/javacode/bTorrent/src/com/company/bencode/python/ubuntu-mate-18.04.5-desktop-amd64.iso.torrent").getContent();
        BDecoder decoder = new BDecoder(content);
        BMap map = (BMap) decoder.decode().get(0);
        BMap info = (BMap) map.get(new BString("info"));
        info.hide(new BString("pieces"));
        System.out.println(map);
    }
}
