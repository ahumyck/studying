package company.torrentAPI.http;

import company.torrentAPI.http.url.URLBuilder;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;

public class HttpGetRequest {

	private final String URL;

	public HttpGetRequest(String URL) {
		this.URL = URL;
	}

	public HttpGetRequest(URLBuilder urlBuilder) {
		this.URL = urlBuilder.getUrl();
	}

	public BufferedInputStream sendRequestAndGetResponseAsBytes() throws IOException {
		URL url = new URL(this.URL);
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
		connection.setRequestMethod("GET");
		connection.setDoOutput(true);
		return new BufferedInputStream(connection.getInputStream());
	}
}
