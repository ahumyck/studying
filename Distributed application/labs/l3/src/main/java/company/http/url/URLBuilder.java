package company.http.url;

import company.http.parameters.ParameterStringBuilder;

import java.io.UnsupportedEncodingException;
import java.util.Map;

public class URLBuilder {

	private final String url;
	private final Map<String, String> params;

	public URLBuilder(String url, Map<String, String> params) {
		this.url = url;
		this.params = params;
	}

	public String getUrl() throws UnsupportedEncodingException {
		return url + '?' + new ParameterStringBuilder(params).getParamsString();
	}
}
