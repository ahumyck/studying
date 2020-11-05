import company.Constants;
import company.Torrent;
import company.bencode.coders.BDecoder;
import company.bencode.objects.BMap;
import company.bencode.objects.BString;
import company.files.BufferWriter;
import company.files.ContentReader;
import company.hash.PythonHash;
import company.http.HttpGetRequest;
import company.http.parameters.ParameterBuilder;
import company.http.peers.Address;
import company.http.peers.PeerParser;
import company.http.protocol.HandshakeMessageBuilder;
import company.http.protocol.PeerConnection;
import company.http.url.PeerIdBuilder;
import company.http.url.URLBuilder;
import company.http.url.impl.URLHashBuilder;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

public class Main {

	private static final String torrentFile = Constants.BASE_PATH + Constants.UBUNTU_TORRENT_FILE;

	public static void main(String[] args) throws IOException {
		Torrent torrent = Torrent.readTorrentFile(torrentFile);
		System.out.println(torrent.getAnnounce());
		System.out.println(torrent.getOutputFile());
		System.out.println(torrent.getOutputFileSize());
		System.out.println(torrent.getInfoHash());


		//		PeerIdBuilder peerId = new PeerIdBuilder();
		//		Map<String, String> params = new ParameterBuilder(new URLHashBuilder(new PythonHash()), peerId).build();
		//		URLBuilder urlBuilder = new URLBuilder(announce, params);
		//		System.out.println(urlBuilder.getUrl());
		//
		//		HttpGetRequest httpGetRequest = new HttpGetRequest(urlBuilder);
		//		httpGetRequest.sendRequest();
		//		String responseMessage = httpGetRequest.getResponseMessage();
		//		System.out.println(responseMessage);
		//		BMap decode = new BDecoder(responseMessage).decode();
		//		System.out.println(decode);
		//		String peers = (String) decode.get(new BString("peers")).getValue();
		//		System.out.println(peers.getBytes("cp1251").length);
		//		PeerParser parser = new PeerParser(peers.getBytes("cp1251"));
		//		List<Address> addresses = parser.getAddresses();
		//		System.out.println(addresses);
	}

}
