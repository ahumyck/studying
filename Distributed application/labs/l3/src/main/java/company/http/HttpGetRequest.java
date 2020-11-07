package company.http;

import company.http.url.URLBuilder;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;

public class HttpGetRequest {

	private final String URL;
	private HttpURLConnection connection;
	private String response;
	//	private final Map<String, String> params;

	//	public HttpGetRequest(String URL, Map<String, String> params) {
	//		this.URL = URL;
	//		this.params = params;
	//	}

	public HttpGetRequest(String URL) {
		this.URL = URL;
	}

	public HttpGetRequest(URLBuilder builder) throws UnsupportedEncodingException {
		this.URL = builder.getUrl();
	}

	public void sendRequest() throws IOException {
		URL url = new URL(this.URL);
		connection = (HttpURLConnection) url.openConnection();
		connection.setRequestMethod("GET");
		connection.addRequestProperty("Accept-Charset", "cp1251");
		connection.setDoOutput(true);
	}

	public String getFullResponse() throws IOException {
		return new FullResponseBuilder(connection).getFullResponse();
	}

	public String getResponseMessage() throws IOException {
		return new FullResponseBuilder(connection).getResponse().toString();
	}

	public int getStatus() throws IOException {
		return connection.getResponseCode();
	}
}
