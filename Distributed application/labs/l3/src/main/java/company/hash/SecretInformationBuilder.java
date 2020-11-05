package company.hash;

public class SecretInformationBuilder {

	private final String content;

	public SecretInformationBuilder(String content) {
		this.content = content;
	}

	public String getSecretInformation() {
		return content.substring(content.indexOf("d6:length"), content.length() - 1);
	}

}
