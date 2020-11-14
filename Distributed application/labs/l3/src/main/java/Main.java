import company.Torrent;
import company.torrentAPI.bencode.BDecoder;
import company.torrentAPI.http.HttpGetRequest;
import company.torrentAPI.http.peers.LightPeer;
import company.torrentAPI.http.peers.LightPeerParser;
import company.torrentAPI.http.url.URLBuilder;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class Main {

	private static final String torrentFile = "src/main/resources/xubuntu-20.10-desktop-amd64.iso.torrent";
	private static final int port = 6969;

	public static void main(String[] args) throws IOException {


		Torrent torrent = Torrent.readTorrentFile(torrentFile);
		System.out.println("ANNOUNCE: " + torrent.getAnnounce());
		System.out.println("FILE NAME: " + torrent.getOutputFile());
		System.out.println("FILE SIZE: " + torrent.getOutputFileSize());
		System.out.println("INFO HASH: " + torrent.getInfoHashHex());


		URLBuilder url = new URLBuilder(torrent, port);
		HttpGetRequest request = new HttpGetRequest(url.getUrl());
		BufferedInputStream bufferedInputStream = request.sendRequestAndGetResponseAsBytes();

		Map decode = BDecoder.decode(bufferedInputStream);

		System.out.println(decode);
		LightPeerParser parser = new LightPeerParser((byte[]) decode.get("peers"));
		List<LightPeer> addresses = parser.getLightPeers();
		System.out.println(addresses);
		System.out.println(decode.get("interval").getClass());


	}


}
