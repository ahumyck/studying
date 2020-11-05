package company.bencode.python;


import company.Constants;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class ScriptPython {

	public static String runScript() throws IOException {
		ProcessBuilder processBuilder = new ProcessBuilder("python", Constants.BASE_PATH + "hash.py");
		processBuilder.redirectErrorStream(true);

		Process process = processBuilder.start();

		String line;
		BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
		line = reader.readLine();
		reader.close();
		return line;
	}
}
