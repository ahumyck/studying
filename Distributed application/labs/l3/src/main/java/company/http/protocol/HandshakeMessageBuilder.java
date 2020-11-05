package company.http.protocol;

import company.hash.Hash;

public class HandshakeMessageBuilder {

	private final Hash hash;
	private final String peerId;
	private final String protocol = "BitTorrent protocol";
	private final String code = "19";

	public HandshakeMessageBuilder(Hash hash, String peerId) {
		this.hash = hash;
		this.peerId = peerId;
	}

	public String build() {
		String hashString = this.hash.getHash();
//		byte[] codeBytes = code.getBytes();
//		byte[] protocolBytes = protocol.getBytes();
//		byte[] hashBytes = hashString.getBytes();
//		byte[] peerBytes = peerId.getBytes();
		return code + protocol + hashString + peerId;
	}
}
