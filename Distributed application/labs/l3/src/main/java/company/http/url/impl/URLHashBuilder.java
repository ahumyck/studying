package company.http.url.impl;

import company.hash.Hash;
import company.http.url.URLHash;

import java.util.ArrayList;
import java.util.List;

public class URLHashBuilder implements URLHash {

	private final String hash;

	public URLHashBuilder(Hash hash) {
		this.hash = hash.getHash();
	}

	public URLHashBuilder(String hash) {
		this.hash = hash;
	}

	public String getURLParameter() {
		return insert(this.hash.toUpperCase());
	}

	private String insert(String original) {
		List<Integer> positionForInsert = getPositionForInsert(original.length());
		for (int i = 0; i < positionForInsert.size(); i++) {
			int insertPosition = positionForInsert.get(i) + i;
			original = original.substring(0, insertPosition) + '%' + original.substring(insertPosition);
		}
		return original;
	}

	private List<Integer> getPositionForInsert(int length) {
		List<Integer> position = new ArrayList<>();
		for (int i = 0; i < length; i += 2) {
			position.add(i);
		}
		return position;
	}


}
