package company.torrentAPI.http;

import java.io.*;
import java.net.HttpURLConnection;
import java.nio.charset.Charset;
import java.util.Iterator;
import java.util.List;

public class FullResponseBuilder {

	private final HttpURLConnection connection;

	public FullResponseBuilder(HttpURLConnection connection) {
		this.connection = connection;
	}

	public String getFullResponse() throws IOException {
		StringBuilder fullResponseBuilder = new StringBuilder();

		fullResponseBuilder.append(connection.getResponseCode()).append(" ").append(connection.getResponseMessage()).append("\n");

		connection.getHeaderFields().entrySet().stream().filter(entry -> entry.getKey() != null).forEach(entry -> {

			fullResponseBuilder.append(entry.getKey()).append(": ");

			List<String> headerValues = entry.getValue();
			Iterator<String> it = headerValues.iterator();
			if (it.hasNext()) {
				fullResponseBuilder.append(it.next());

				while (it.hasNext()) {
					fullResponseBuilder.append(", ").append(it.next());
				}
			}

			fullResponseBuilder.append("\n");
		});
		return fullResponseBuilder.append(getResponse()).toString();
	}

	public StringBuilder getResponse() throws IOException {
		Reader streamReader = null;

		Charset charset = Charset.forName("cp1251");
		if (connection.getResponseCode() > 299) {
			streamReader = new InputStreamReader(connection.getErrorStream(), charset);
		} else {
			streamReader = new InputStreamReader(connection.getInputStream(), charset);
		}

		BufferedReader in = new BufferedReader(streamReader);
		String inputLine;
		StringBuilder content = new StringBuilder();
		while ((inputLine = in.readLine()) != null) {
			content.append(inputLine);
		}

		in.close();
		return content;
	}

	public BufferedInputStream getResponseAsBytes() throws IOException {
		return new BufferedInputStream(connection.getInputStream());
	}
}
