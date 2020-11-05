package company.hash;

import company.bencode.python.ScriptPython;
import lombok.SneakyThrows;

public class PythonHash implements Hash {
	public PythonHash() {
	}

	@Override
	@SneakyThrows
	public String getHash() {
		return ScriptPython.runScript();
	}
}
