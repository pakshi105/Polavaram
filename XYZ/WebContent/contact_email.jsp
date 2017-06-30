<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.MessagingException" %> 
<%@ page import="javax.mail.PasswordAuthentication" %> 
<%@ page import="javax.mail.Session" %> 
<%@ page import="javax.mail.Transport" %> 
<%@ page import="javax.mail.internet.InternetAddress" %> 
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="java.util.Properties" %>     
<%
//Recipient's email ID needs to be mentioned.
		String to = request.getParameter("email1");

		// Get the session object
		Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.socketFactory.port", "465");
		props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.port", "465");

		Session mySession = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication("krishna.teja@mysmartprice.com", "Teja@123");// change
																						// accordingly
			}
		});

		// compose message
		try {
			MimeMessage message = new MimeMessage(mySession);
			message.setFrom(new InternetAddress("krishna.teja@mysmartprice.com"));// change
																			// accordingly
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
			message.setSubject("Hello! Welcome to XYZ");
			message.setText("Hello, " + request.getParameter("name1") + ". Thank you for contacting us. We will get back to you ASAP! ");

			// send message
			Transport.send(message);

			out.print("success");

		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}

%>