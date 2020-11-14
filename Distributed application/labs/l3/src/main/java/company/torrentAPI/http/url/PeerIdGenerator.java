package company.torrentAPI.http.url;

import java.util.Random;

public class PeerIdGenerator {

	private final Random random = new Random();
	private String cache = "";

	public PeerIdGenerator() {

	}

	public String getPeerId() {
		StringBuilder base = new StringBuilder("-PC0001-");
		for (int i = 0; i < 12; i++) {
			base.append(random.nextInt(10));
		}
		cache = base.toString();
		return base.toString();
	}

	public String getCache() {
		return cache;
	}
}

