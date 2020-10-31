package com.company.http;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;

public class ParameterStringBuilder {

    private final Map<String, String> params;

    public ParameterStringBuilder(Map<String, String> params) {
        this.params = params;
    }

    public String getParamsString() throws UnsupportedEncodingException {
        StringBuilder result = new StringBuilder();

        for (Map.Entry<String, String> entry : params.entrySet()) {
            result.append(URLEncoder.encode(entry.getKey(), "cp1251"));
            result.append("=");
            result.append(URLEncoder.encode(entry.getValue(), "cp1251"));
            result.append("&");
        }

        String resultString = result.toString();
        return resultString.length() > 0 ? resultString.substring(0, resultString.length() - 1) : resultString;
    }
}
