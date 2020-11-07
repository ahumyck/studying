package company.files;

import company.Constants;

import java.io.FileOutputStream;
import java.io.IOException;

public class BufferWriter {

	public void write(String information) throws IOException {
		String filename = Constants.BASE_PATH + "buffer.txt";
		FileOutputStream outputStream = new FileOutputStream(filename);
		byte[] strToBytes = information.getBytes();
		outputStream.write(strToBytes);
		outputStream.close();
	}
}
