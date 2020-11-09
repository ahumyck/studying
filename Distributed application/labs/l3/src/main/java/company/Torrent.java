package company;

import company.bencode.coders.Decoder;
import company.bencode.objects.BElement;
import company.bencode.objects.BMap;
import company.bencode.objects.BString;
import company.files.BufferWriter;
import company.files.ContentReader;
import company.hash.PythonHash;
import company.http.url.PeerIdBuilder;
import lombok.SneakyThrows;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


public class Torrent {
	private final String torrentFile;
	private Map<BElement, BElement> map;
	private String hash;
	private String peerId;


	protected Torrent(String torrentFile) {
		this.torrentFile = torrentFile;
	}

	protected void loadTorrent(Map<BElement, BElement> map) {
		this.map = map;
	}

	protected void loadHash(String hash) {
		this.hash = hash;
	}

	protected void loadPeerId() {
		this.peerId = new PeerIdBuilder().getPeerId();
	}

	@SneakyThrows
	public static Torrent readTorrentFile(String torrentFile) {
		new BufferWriter().write(torrentFile);
		Torrent torrent = new Torrent(torrentFile);
		String content = new ContentReader(torrentFile).getContent();
		torrent.loadTorrent(new Decoder(content).decode().getValue());
		torrent.loadHash(new PythonHash().getHash());
		torrent.loadPeerId();
		return torrent;
	}

	public String getPeerId() {
		return peerId;
	}

	public String getTorrentFile() {
		return torrentFile;
	}

	public String getInfoHash() {
		return hash;
	}

	public String getAnnounce() {
		return (String) map.get(new BString("announce")).getValue();
	}

	public String getOutputFile() {
		return (String) ((BMap) map.get(new BString("info"))).get(new BString("name")).getValue();
	}

	public BigInteger getOutputFileSize() {
		return (BigInteger) ((BMap) map.get(new BString("info"))).get(new BString("length")).getValue();
	}

	public BigInteger getPieceLength() {
		return (BigInteger) ((BMap) map.get(new BString("info"))).get(new BString("piece length")).getValue();
	}

	public List<String> getPieces() {
		List<String> pieces = new ArrayList<>();
		String chunk = (String) ((BMap) map.get(new BString("info"))).get(new BString("piece length")).getValue();
		int length = chunk.length();
		return pieces;
	}


}
