package com.insure.rfq.login.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.insure.rfq.login.repository.UserLoginRepo;
import com.insure.rfq.login.repository.UserRepositiry;
import com.insure.rfq.login.service.UserLoginService;

@Service

public class UserLoginServiceImpl implements UserLoginService {

	@Autowired
	private UserLoginRepo repo;

	@Autowired
	private UserRepositiry userRepo;
//
////	@Override
////	public boolean login(String email, String password) {
////		UserLogin findByEmail = repo.findByEmail(email).orElseThrow(() -> new InvalidUser("Email doesn't exits"));
////		System.out.println(findByEmail);
////		if ((findByEmail.getEmail().equalsIgnoreCase(email)) && (findByEmail.getPassword().equals(password)))
////			return true;
////		else
////			return false;
////	}
//
//	@Override
//	public UserLogin userRegister(UserLogin user) throws EmailExistsException {
//		boolean existsByEmail = repo.existsByEmail(user.getEmail());
//
//		if (existsByEmail) {
//			throw new EmailExistsException("Email already registered");
//		}
//
//		return repo.save(user);
//	}
//
//	@Override
//	public List<UserLogin> getLoginData() {
//		return repo.findAll();
//	}
//
//	@Override
//	public UserLogin getById(long id) {
//		return repo.findById(id).orElseThrow(() -> new InvalidUser(" user not found"));
//	}
//
//	@Override
//	public String forgotPassword(String email) {
//		// Generate a random password
//		String randomPassword = generateRandomPassword();
//		UserLogin user = repo.findByEmail(email).orElseThrow(() -> new InvalidUser("Email doesn't exits"));
//		sendEmail(user.getEmail(), randomPassword);
//
//		return randomPassword;
//	}
//
//	public String generateRandomPassword() {
//		String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
//		StringBuilder randomPassword = new StringBuilder();
//		Random random = new Random();
//		for (int i = 0; i < 8; i++) {
//			int index = random.nextInt(chars.length());
//			randomPassword.append(chars.charAt(index));
//		}
//		return randomPassword.toString();
//	}
//
//	public void sendEmail(String email, String randomPassword) {
//		// Email configuration
//		String host = "smtp.office365.com";
//		String username = "jashwanth.pendyala@ojas-it.com";
//		String password = "frqnwgwcmpspqmck";
//		int port = 587;
//
//		// Sender and recipient email addresses
//		String senderEmail = "jashwanth.pendyala@ojas-it.com";
//		String recipientEmail = email;
//
//		// Email subject and body
//		String subject = "Password Reset";
//		String body = "Your new password is: " + randomPassword;
//
//		// Set the mail properties
//		Properties properties = new Properties();
//		properties.put("mail.smtp.auth", "true");
//		properties.put("mail.smtp.starttls.enable", "true");
//		properties.put("mail.smtp.host", host);
//		properties.put("mail.smtp.port", port);
//
//		// Create a Session object with the authentication credentials
//		Session session = Session.getInstance(properties, new Authenticator() {
//			@Override
//			protected PasswordAuthentication getPasswordAuthentication() {
//				return new PasswordAuthentication(username, password);
//			}
//		});
//
//		try {
//			// Create a MimeMessage object
//			MimeMessage message = new MimeMessage(session);
//
//			// Set the sender and recipient addresses
//			message.setFrom(new InternetAddress(senderEmail));
//			message.addRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
//
//			// Set the email subject and body
//			message.setSubject(subject);
//			message.setText(body);
//
//			// Send the email
//			Transport.send(message);
//			System.out.println("Password reset email sent successfully!");
//		} catch (MessagingException e) {
//			System.out.println("Failed to send password reset email.");
//			e.printStackTrace();
//		}

//	@Override
//	public String changePassword(ChangePassword changePassword, long id) {
//
//		UserRegisteration user = userRepo.findById(id).orElseThrow(() -> new InvalidUser("user not found"));
//		
////		System.out.println(user);
//		
////		UserLogin save = repo.save(user);
//		String msg = "";
//		if (user != null) {
//			msg = "Password Reset Successfull";
//		} else {
//			msg = "Password Reset Not Successfull";
//		}
//
//		return msg;
//	}
}
