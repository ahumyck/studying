package company;

import company.torrentAPI.http.url.PeerIdGenerator;
import company.torrentAPI.bencode.BDecoder;
import company.torrentAPI.bencode.BEncoder;
import company.jBittorrentAPI.Utils;
import lombok.SneakyThrows;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


public class Torrent {
	private final String torrentFile;
	private String announce;

	private String outputFile;
	private long outputFileSize;
	private byte[] hash;
	private String peerId;
	private long creationDate;

	private final List<byte[]> pieceHashValuesAsBinary = new ArrayList<>();

	protected Torrent(String torrentFile) {
		this.torrentFile = torrentFile;
	}


	protected void loadAnnounce(String announce) {
		this.announce = announce;
	}

	protected void loadCreationDate(long creationDate) {
		this.creationDate = creationDate;
	}

	protected void loadPieces(Map info) {
		if (info.containsKey("pieces")) {
			byte[] piecesHash2 = (byte[]) info.get("pieces");
			if (piecesHash2.length % 20 == 0) {

				for (int i = 0; i < piecesHash2.length / 20; i++) {
					this.pieceHashValuesAsBinary.add(Utils.subArray(piecesHash2, i * 20, 20));
				}
			}
		}
	}

	@SneakyThrows
	protected void loadHash(Map info) {
		this.hash = Utils.hash(BEncoder.encode(info));
	}

	protected void loadPeerId() {
		this.peerId = new PeerIdGenerator().getPeerId();
	}

	protected void loadOutputFilename(String outputFile) {
		this.outputFile = outputFile;
	}

	@SneakyThrows
	public static Torrent readTorrentFile(String torrentFile) {
		Map m = BDecoder.decode(new File(torrentFile));
		Torrent torrent = new Torrent(torrentFile);
		torrent.loadAnnounce(new String((byte[]) m.get("announce")));
		torrent.loadCreationDate((Long) m.get("creation date"));
		torrent.loadHash(((Map) m.get("info")));
		torrent.loadPieces((Map) m.get("info"));
		torrent.loadPeerId();
		return torrent;
	}

	public byte[] getHash() {
		return hash;
	}

	public long getCreationDate() {
		return creationDate;
	}

	public List<byte[]> getPieceHashValuesAsBinary() {
		return pieceHashValuesAsBinary;
	}

	public String getPeerId() {
		return peerId;
	}

	public String getTorrentFile() {
		return torrentFile;
	}

	public byte[] getInfoHash() {
		return hash;
	}

	public String getInfoHashHex() {
		return Utils.bytesToHex(getInfoHash());
	}

	public String getAnnounce() {
		return announce;
	}

	public String getOutputFile() {
		return outputFile;
	}

	public long getOutputFileSize() {
		return outputFileSize;
	}

	public List<byte[]> getPieces() {
		return pieceHashValuesAsBinary;
	}


}
