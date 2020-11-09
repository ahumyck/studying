package company.torrentAPI.http.parameters;

import company.Torrent;
import company.torrentAPI.http.url.URLHashBuilder;

import java.math.BigInteger;
import java.util.LinkedHashMap;
import java.util.Map;

public class ParameterBuilder {

	private final Map<String, String> map = new LinkedHashMap<>();
	private final String hash;
	private final String peerId;
	private final BigInteger uploaded;
	private final BigInteger downloaded;
	private final BigInteger left;
	private final int port;
	private int compact = 1;

	public ParameterBuilder(Torrent torrent, BigInteger uploaded, BigInteger downloaded, BigInteger left, int port, int compact) {
		this.hash = torrent.getInfoHashHex();
		this.peerId = torrent.getPeerId();
		this.uploaded = uploaded;
		this.downloaded = downloaded;
		this.left = left;
		this.port = port;
		this.compact = compact;
	}

	public ParameterBuilder(Torrent torrent, int port) {
		this.hash = torrent.getInfoHashHex();
		this.peerId = torrent.getPeerId();
		this.uploaded = BigInteger.ZERO;
		this.downloaded = BigInteger.ZERO;
		this.left = BigInteger.ZERO;
		this.port = port;
		this.compact = 1;
	}

	public Map<String, String> build() {
		map.put("info_hash", new URLHashBuilder(this.hash).getURLParameter());
		map.put("peer_id", this.peerId);
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
