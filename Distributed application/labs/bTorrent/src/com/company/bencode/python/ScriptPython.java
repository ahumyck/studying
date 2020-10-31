package com.company.bencode.python;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class ScriptPython {

    public static List<String> runScript() throws IOException {

        ProcessBuilder processBuilder = new ProcessBuilder("python", "D:/labs/javacode/bTorrent/src/com/company/bencode/python/hash2.py");
        processBuilder.redirectErrorStream(true);

        Process process = processBuilder.start();

        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line;
        List<String> strings = new ArrayList<>();

        while ((line = reader.readLine()) != null) {
            strings.add(line);
        }

        return strings;
    }
}
