package company.torrentAPI.http.peers;

public class LightPeer {
	private final String ip;
	private final int port;

	public LightPeer(String ip, int port) {
		this.ip = ip;
		this.port = port;
	}

	public String getIp() {
		return ip;
	}

	public int getPort() {
		return port;
	}

	@Override
	public String toString() {
		return ip + ":" + port;
	}
}
