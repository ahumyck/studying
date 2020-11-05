package company.http.protocol;

import company.http.peers.Address;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class PeerConnection {
	private final Address address;
	private Socket socket = null;
	private PrintWriter out = null;
	private BufferedReader in = null;

	public PeerConnection(Address address) {
		this.address = address;
	}

	public void startConnection() throws IOException {
		if (socket == null) {
			socket = new Socket(address.getIp(), address.getPort());
			out = new PrintWriter(socket.getOutputStream(), true);
			in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
		}
	}

	public String sendMessageAndGetResponse(String message) throws IOException {
		if(socket == null){
			startConnection();
		}
		out.println(message);
		return in.readLine();
	}

}
