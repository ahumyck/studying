package company.torrentAPI.http.parameters;

import java.util.Map;

public class ParameterStringBuilder {

	private final Map<String, String> params;

	public ParameterStringBuilder(Map<String, String> params) {
		this.params = params;
	}

	public String getParamsString() {
		StringBuilder result = new StringBuilder();

		for (String key : params.keySet()) {
			result.append(key);
			result.append("=");
			result.append(params.get(key));
			result.append("&");
		}

		String resultString = result.toString();
		return resultString.length() > 0 ? resultString.substring(0, resultString.length() - 1) : resultString;
	}
}
