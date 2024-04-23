package com.insure.rfq.login.service;
//package com.insurance.service;
//
//import org.springframework.mail.SimpleMailMessage;
//import org.springframework.mail.javamail.JavaMailSender;
//import org.springframework.stereotype.Service;
//
//import lombok.RequiredArgsConstructor;
//
//@Service
//@RequiredArgsConstructor
//public class MailService {
//
//    private final JavaMailSender javaMailSender;
//
//    
//
//    public void sendPasswordResetEmail(String recipientEmail, String newPassword) {
//        SimpleMailMessage message = new SimpleMailMessage();
//        message.setTo(recipientEmail);
//        message.setSubject("Password Reset");
//        message.setText("Your new password is: " + newPassword);
//
//        javaMailSender.send(message);
//    }
//}
//
