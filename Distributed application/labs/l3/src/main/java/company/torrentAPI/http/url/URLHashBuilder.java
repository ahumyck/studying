package company.torrentAPI.http.url;

import java.util.ArrayList;
import java.util.List;

public class URLHashBuilder {

	private final String hash;

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
