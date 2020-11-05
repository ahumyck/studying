package company.http.parameters;

import company.http.url.PeerIdBuilder;
import company.http.url.URLHash;

import java.math.BigInteger;
import java.util.LinkedHashMap;
import java.util.Map;

public class ParameterBuilder {

	private final Map<String, String> map = new LinkedHashMap<>();
	private final URLHash urlHashBuilder;
	private final PeerIdBuilder idBuilder;
	private final BigInteger uploaded;
	private final BigInteger downloaded;
	private final BigInteger left;
	private int port = 6969;
	private int compact = 1;

	public ParameterBuilder(URLHash urlHashBuilder, PeerIdBuilder idBuilder, BigInteger uploaded, BigInteger downloaded, BigInteger left, int port, int compact) {
		this.urlHashBuilder = urlHashBuilder;
		this.idBuilder = idBuilder;
		this.uploaded = uploaded;
		this.downloaded = downloaded;
		this.left = left;
		this.port = port;
		this.compact = compact;
	}

	public ParameterBuilder(URLHash urlHashBuilder, PeerIdBuilder idBuilder) {
		this.urlHashBuilder = urlHashBuilder;
		this.idBuilder = idBuilder;
		this.uploaded = BigInteger.ZERO;
		this.downloaded = BigInteger.ZERO;
		this.left = BigInteger.ZERO;
	}

	public Map<String, String> build() {
		map.put("info_hash", urlHashBuilder.getURLParameter());
		map.put("peer_id", idBuilder.getPeerId());
		map.put("uploaded", uploaded.toString());
//		map.put("numwant", String.valueOf(10));
		map.put("downloaded", downloaded.toString());
		map.put("left", left.toString());
		map.put("port", String.valueOf(port));
		map.put("compact", String.valueOf(compact));
		return map;
	}

	private ParameterBuilder put(String key, String value) {
		map.putIfAbsent(key, value);
		return this;
	}

}
