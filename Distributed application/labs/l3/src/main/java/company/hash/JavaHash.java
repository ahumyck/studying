package company.hash;

import lombok.SneakyThrows;

import java.security.MessageDigest;
import java.util.Formatter;

public class JavaHash implements Hash {

	private final String secretInformation;

	public JavaHash(String secretInformation) {
		this.secretInformation = secretInformation;
	}

	public JavaHash(SecretInformationBuilder builder) {
		this.secretInformation = builder.getSecretInformation();
	}

	@Override
	@SneakyThrows
	public String getHash() {
		return hash(secretInformation);
	}

	@SneakyThrows
	private String hash(String secret) {
		MessageDigest crypt = MessageDigest.getInstance("SHA-1");
		crypt.reset();
		crypt.update(secret.getBytes());
		return byteToHex(crypt.digest());
	}

	private String byteToHex(final byte[] hash) {
		Formatter formatter = new Formatter();
		for (byte b : hash) {
			formatter.format("%02x", b);
		}
		String result = formatter.toString();
		formatter.close();
		return result;
	}
}
