package company.torrentAPI.http.peers;

import company.jBittorrentAPI.Utils;

import java.util.ArrayList;
import java.util.List;

public class LightPeerParser {
	private final byte[] peers;

	public LightPeerParser(byte[] peers) {
		this.peers = peers;
	}


	public List<LightPeer> getLightPeers() {
		List<LightPeer> addresses = new ArrayList<>();

		for (int i = 0; i < peers.length; i += 6) {
			String ip = Utils.byteToUnsignedInt(peers[i]) + "." + Utils.byteToUnsignedInt(peers[i + 1]) + "." + Utils.byteToUnsignedInt(peers[i + 2]) + "." + Utils.byteToUnsignedInt(peers[i + 3]);
			int port = Utils.byteArrayToInt(Utils.subArray(peers, i + 4, 2));
			addresses.add(new LightPeer(ip, port));
		}

		return addresses;
	}
}
