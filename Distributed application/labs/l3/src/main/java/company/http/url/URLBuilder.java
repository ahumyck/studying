package company.http.url;

import company.Torrent;
import company.http.parameters.ParameterBuilder;
import company.http.parameters.ParameterStringBuilder;

import java.io.UnsupportedEncodingException;
import java.util.Map;

public class URLBuilder {

	private final String url;
	private final Map<String, String> params;

	public URLBuilder(Torrent torrent, int port) {
		this.url = torrent.getAnnounce();
		this.params = new ParameterBuilder(torrent, port).build();
	}

	public URLBuilder(String url, Map<String, String> params) {
		this.url = url;
		this.params = params;
	}

	public String getUrl() {
		return url + '?' + new ParameterStringBuilder(params).getParamsString();
	}

	@Override
	public String toString() {
		return url + '?' + new ParameterStringBuilder(params).getParamsString();
	}
}
