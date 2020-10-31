package com.company.http;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.util.Iterator;
import java.util.List;

public class FullResponseBuilder {

    private HttpURLConnection connection;

    public FullResponseBuilder(HttpURLConnection connection) {
        this.connection = connection;
    }

    public String getFullResponse() throws IOException {
        StringBuilder fullResponseBuilder = new StringBuilder();

        fullResponseBuilder.append(connection.getResponseCode())
                .append(" ")
                .append(connection.getResponseMessage())
                .append("\n");

        connection.getHeaderFields()
                .entrySet()
                .stream()
                .filter(entry -> entry.getKey() != null)
                .forEach(entry -> {

                    fullResponseBuilder.append(entry.getKey())
                            .append(": ");

                    List<String> headerValues = entry.getValue();
                    Iterator<String> it = headerValues.iterator();
                    if (it.hasNext()) {
                        fullResponseBuilder.append(it.next());

                        while (it.hasNext()) {
                            fullResponseBuilder.append(", ")
                                    .append(it.next());
                        }
                    }

                    fullResponseBuilder.append("\n");
                });

        Reader streamReader = null;

        if (connection.getResponseCode() > 299) {
            streamReader = new InputStreamReader(connection.getErrorStream());
        } else {
            streamReader = new InputStreamReader(connection.getInputStream());
        }

        BufferedReader in = new BufferedReader(streamReader);
        String inputLine;
        StringBuilder content = new StringBuilder();
        while ((inputLine = in.readLine()) != null) {
            content.append(inputLine);
        }

        in.close();

        fullResponseBuilder.append("Response: ")
                .append(content);

        return fullResponseBuilder.toString();
    }
}
