package edu.cu.cloud;

import java.util.*;
import java.util.logging.Logger;

import javax.mail.*;
import javax.mail.internet.*;

public class SendEmail {
	private static final Logger log = Logger.getLogger(DownloadTweetServlet.class.getName());


	public static void send(String text) {

		final String username = "yunzhiye.nju@gmail.com";
		final String password = "19900710Yyz";

		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");

		Session session = Session.getInstance(props,
				new javax.mail.Authenticator() {
					protected PasswordAuthentication getPasswordAuthentication() {
						return new PasswordAuthentication(username, password);
					}
				});

		try {

			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress("yunzhiye.nju@gmail.com"));
			message.setRecipients(Message.RecipientType.TO,
					InternetAddress.parse("yunzhiye.nju@gmail.com"));
			message.setSubject("Testing Subject");
			message.setText(text);

			Transport.send(message);

			log.warning("Done");

		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}
	}
}