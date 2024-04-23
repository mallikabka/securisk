package com.insure.rfq.login.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.insure.rfq.login.dto.AuthenticationDto;
import com.insure.rfq.login.dto.RefreshAuthDto;
import com.insure.rfq.login.dto.UserInfo;
import com.insure.rfq.login.service.JwtService;
import com.insure.rfq.login.service.UserJwtAuthenticationService;
import com.insure.rfq.login.service.UserService;

import lombok.extern.slf4j.Slf4j;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/user")
@Slf4j
public class UserLoginController {

//	String randomPassword;
//	String currentEmail;
	@Autowired
	private JwtService jwtService;
	@Autowired
	private UserJwtAuthenticationService userJwtAuthenticationService;
	@Autowired
	private UserJwtAuthenticationService authenticationService;

	private BCryptPasswordEncoder bCryptPasswordEncoder;

	private static final Logger Log = LoggerFactory.getLogger(UserLoginController.class);

	@Autowired
	private UserService userService;

//	@PostMapping("/adduser")
//	public ResponseEntity<Map<String, Object>> addUser2(@RequestBody @Valid UserLogin user) {
//		Map<String, Object> map = new HashMap<>();
//		try {
//			UserLogin userRegister = service.userRegister(user);
//			if (userRegister != null) {
//				map.put("message", "Registered Successfully");
//				map.put("timestamp", new Date());
//				return ResponseEntity.ok().body(map);
//			}
//			map.put("message", "Not Registered");
//			return ResponseEntity.badRequest().body(map);
//		} catch (EmailExistsException e) {
//			map.put("message", e.getMessage());
//			map.put("timestamp", new Date());
//			return ResponseEntity.badRequest().body(map);
//
//		}
//	}
//
//	@PostMapping("/login")
//	public ResponseEntity<Map<String, Object>> login2(@Valid @RequestBody UserLogin login) {
//		boolean log = service.login(login.getEmail(), login.getPassword());
//		Map<String, Object> map = new HashMap<>();
//		if (log) {
//			map.put("message", "LoggedIn Successfully");
//			map.put("timestamp", new Date());
//			return ResponseEntity.ok().body(map);
//		}
//
//		else {
//			map.put("message", "Invalid Credentials");
//			map.put("timestamp", new Date());
//			return ResponseEntity.badRequest().body(map);
//		}
//
//	}
//
//	@PostMapping("/forget")
//	public ResponseEntity<Map<String, Object>> forgetpassword(@RequestBody ResetPassword reset) {
//		Map<String, Object> map = new HashMap<>();
//		try {
//			randomPassword = service.forgotPassword(reset.getEmail());
//			System.out.println(reset.getEmail() + "  current email");
//			currentEmail = reset.getEmail();
//			System.out.println(randomPassword);
//			map.put("message", "Password successfully sent to your email");
//			map.put("timestamp", new Date());
//			return ResponseEntity.ok().body(map);
//		} catch (IllegalArgumentException e) {
//			map.put("message", "Error While Sending Email");
//			map.put("timestamp", new Date());
//			return ResponseEntity.badRequest().body(map);
//		}
//	}
//
//	@PutMapping("/{userId}/changePassword")
//	public ResponseEntity<Map<String, Object>> resetPassword(@RequestBody ChangePassword changePassword,
//			@PathVariable long userId) {
//		String pass = service.changePassword(changePassword, userId);
//		return null;
////		String resetPassword = "";
////		Map<String, Object> map = new HashMap<>();
////		System.out.println(reset);
//////		System.out.println(randomPassword + "   random password");
////		if (reset.getPassword().equals(randomPassword)) {
////			if (reset.getNewPassword().equals(reset.getConfirmPassword())) {
////				reset.setEmail(currentEmail);
////				resetPassword = service.resetPassword(reset);
////				System.out.println(resetPassword);
////				map.put("message", resetPassword);
////				map.put("timestamp", new Date());
////				return ResponseEntity.ok().body(map);
////			}
////			map.put("message", "Password Doesn't Match");
////			map.put("timestamp", new Date());
////			return ResponseEntity.ok().body(map);
////		} else {
////			map.put("message", "Incorrect password, Please Check your email for new password.");
////			map.put("timestamp", new Date());
////			return ResponseEntity.badRequest().body(map);
////		}
//	}
//
//	@GetMapping("/getData")
//	public List<UserLogin> getLoginData() {
//		return service.getLoginData();
//	}
//
//	@GetMapping("/byId/{id}")
//	public ResponseEntity<UserLogin> getById(@PathVariable long id) {
//		UserLogin byId = service.getById(id);
//		return ResponseEntity.ok(byId);
//	}

	@PostMapping("/authenticate")
	@ResponseStatus(value = HttpStatus.OK)
	public UserInfo getValidToken(@RequestBody AuthenticationDto authentication) {

		return userJwtAuthenticationService.getAuthenticated(authentication);

	}

	@PostMapping("/refreshToken")
	@ResponseStatus(value = HttpStatus.OK)
	public UserInfo getRefreshedToken(@RequestBody RefreshAuthDto authDto) {
		log.info(" process of retrive refresh token started ");
		return userJwtAuthenticationService.getAuthenticatedRefreshToken(authDto);
	}
}
