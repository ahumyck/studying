package company.torrentAPI.http.url;

import company.Torrent;
import company.torrentAPI.http.parameters.ParameterBuilder;
import company.torrentAPI.http.parameters.ParameterStringBuilder;

import java.math.BigInteger;
import java.util.Map;

public class URLBuilder {

	private final String url;
	private final Map<String, String> params;

	public URLBuilder(Torrent torrent, int port) {
		this.url = torrent.getAnnounce();
		this.params = new ParameterBuilder(torrent, port).build();
	}

	public URLBuilder(Torrent torrent, BigInteger uploaded, BigInteger downloaded, BigInteger left, int port, int compact) {
		this.url = torrent.getAnnounce();
		this.params = new ParameterBuilder(torrent, uploaded, downloaded, left, port, compact).build();
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
