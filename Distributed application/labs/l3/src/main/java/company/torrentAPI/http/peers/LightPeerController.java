package company.torrentAPI.http.peers;

import company.Torrent;
import company.torrentAPI.bencode.BDecoder;
import company.torrentAPI.http.HttpGetRequest;
import company.torrentAPI.http.url.URLBuilder;
import lombok.SneakyThrows;

import java.math.BigInteger;
import java.util.List;
import java.util.Map;

public class LightPeerController {

	private final Torrent torrent;
	private final int port;

	private List<LightPeer> lightPeers;
	private BigInteger uploaded;
	private BigInteger downloaded;
	private BigInteger left;

	private long interval = 1800; //default value


	public LightPeerController(Torrent torrent, int port) {
		this.torrent = torrent;
		this.port = port;

		this.uploaded = uploaded = BigInteger.ZERO;
		this.downloaded = BigInteger.ZERO;
		this.left = BigInteger.valueOf(torrent.getOutputFileSize());
	}

	@SneakyThrows
	private void updateLightPeers() {
		Map decode = BDecoder.decode(new HttpGetRequest(new URLBuilder(torrent, uploaded, downloaded, left, port, 1)));
		this.lightPeers = new LightPeerParser((byte[]) decode.get("peers")).getLightPeers();
		this.interval = (Long) decode.get("interval");
	}
}
