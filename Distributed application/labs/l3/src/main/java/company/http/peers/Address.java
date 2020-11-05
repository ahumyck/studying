package company.http.peers;

public class Address {
	private final int ip;
	private final int port;

	public Address(int ip, int port) {
		this.ip = ip;
		this.port = port;
	}

	public String getIp() {
		return String.format("%d.%d.%d.%d", (ip >> 24 & 0xff), (ip >> 16 & 0xff), (ip >> 8 & 0xff), (ip & 0xff));
	}

	public int getPort() {
		return ((int)(port + 65536)) % 65536;
	}

	@Override
	public String toString() {
		return "Address{" + "ip=" + getIp() + ", port=" + getPort() + '}';
	}
}
