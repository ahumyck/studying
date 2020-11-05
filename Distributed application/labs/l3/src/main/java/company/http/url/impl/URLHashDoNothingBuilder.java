package company.http.url.impl;

import company.hash.Hash;
import company.http.url.URLHash;

public class URLHashDoNothingBuilder implements URLHash {

	private final Hash hash;

	public URLHashDoNothingBuilder(Hash hash) {
		this.hash = hash;
	}

	@Override
	public String getURLParameter() {
		return this.hash.getHash().toUpperCase();
	}
}
