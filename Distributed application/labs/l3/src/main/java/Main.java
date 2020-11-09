import company.Constants;
import company.Torrent;
import company.bencode.coders.Decoder;
import company.bencode.objects.BMap;
import company.bencode.objects.BString;
import company.hash.PythonHash;
import company.http.HttpGetRequest;
import company.http.parameters.ParameterBuilder;
import company.http.peers.Address;
import company.http.peers.PeerParser;
import company.http.url.PeerIdBuilder;
import company.http.url.URLBuilder;
import company.http.url.impl.URLHashBuilder;
import company.jBittorrentAPI.BDecoder;
import company.jBittorrentAPI.Utils;

import java.io.*;
import java.net.Socket;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;
import java.util.Map;

public class Main {

	private static final String torrentFile = Constants.BASE_PATH + Constants.UBUNTU_TORRENT_FILE;
	private static final int port = 6969;

	public static void main(String[] args) throws IOException {

		//		Map<Object, Object> decode = BDecoder.decode(new File(torrentFile));
		//		System.out.println(decode);
		//		Map<Object, Object> info = (Map<Object, Object>) decode.get("info");
		//		System.out.println(info);


		Torrent torrent = Torrent.readTorrentFile(torrentFile);
		System.out.println("ANNOUNCE: " + torrent.getAnnounce());
		System.out.println("FILE NAME: " + torrent.getOutputFile());
		System.out.println("FILE SIZE: " + torrent.getOutputFileSize());
		System.out.println("INFO HASH: " + torrent.getInfoHash());

		URLBuilder url = new URLBuilder(torrent, port);
		System.out.println(url);

		HttpGetRequest httpGetRequest = new HttpGetRequest(url.getUrl());
		httpGetRequest.sendRequest();
		String responseMessage = httpGetRequest.getResponseMessage();
		System.out.println(responseMessage);
		BMap decode = new Decoder(responseMessage).decode();
		System.out.println(decode);


		String peers = (String) decode.get(new BString("peers")).getValue();
		System.out.println(peers.getBytes("cp1251").length);
		PeerParser parser = new PeerParser(peers.getBytes("cp1251"));
		List<Address> addresses = parser.getAddresses();
		System.out.println(addresses);

		Address address = addresses.get(0);
		try (Socket socket = new Socket(address.getIp(), address.getPort())) {
			System.out.println("open?");
			byte[] first_part = "68BitTorrent protocol".getBytes();
			byte[] empty_part = {0, 0, 0, 0, 0, 0, 0, 0};
			byte[] hash_part = torrent.getInfoHash().getBytes();
			byte[] peer = torrent.getPeerId().getBytes();
			socket.getOutputStream().write(Utils.concat(Utils.concat(first_part, empty_part), Utils.concat(hash_part, peer)));
			System.out.println(socket.getReceiveBufferSize());
			System.out.println(socket.isConnected());
			InputStream inputStream = socket.getInputStream();
			System.out.println(inputStream.available());
			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
			String line;
			while ((line = bufferedReader.readLine()) != null) {
				System.out.println(line);
			}
		}


	}

}
