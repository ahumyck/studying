package company.http.peers;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;

public class PeerParser {
	private final byte[] peers;

	public PeerParser(byte[] peers) {
		this.peers = peers;
	}

	public List<Address> getAddresses() {
		List<Address> addresses = new ArrayList<>();

		for (int i = 0; i < peers.length - peers.length % 6; i += 6) {
			byte[] bytes = new byte[6];
			System.arraycopy(peers, i, bytes, 0, 6);
			byte[] ipBytes = new byte[4];
			System.arraycopy(bytes, 0, ipBytes, 0, 4);
			byte[] portBytes = new byte[2];
			System.arraycopy(bytes, 4, portBytes, 0, 2);
			addresses.add(new Address(ByteBuffer.wrap(ipBytes).getInt(), ByteBuffer.wrap(portBytes).getShort()));
		}

		return addresses;
	}
}
