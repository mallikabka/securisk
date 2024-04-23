package com.insure.rfq.login.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.insure.rfq.login.dto.ChangePasswordDto;
import com.insure.rfq.login.dto.ForgotPasswordDto;
import com.insure.rfq.login.dto.UsersNewDto;
import com.insure.rfq.login.dto.UsersNewDtoGet;
import com.insure.rfq.login.service.UserService;

@RestController
@RequestMapping("/roles")
@CrossOrigin(origins = "*")
public class UserController {

	@Autowired
	private UserService userService;

	@PostMapping("/create-userLogin")
	@ResponseStatus(value = HttpStatus.CREATED)
	public UsersNewDto createUser(@Validated @RequestBody UsersNewDto newDto, @RequestParam Long locationId,
			@RequestParam Long designationId, @RequestParam Long departmentId) {
		if (newDto != null) {
			return userService.createUser(locationId, designationId, departmentId, newDto);
		}
		return null;
	}

	@GetMapping("/getAllUsersByLocationIdLogin/{locationId}")
	@ResponseStatus(value = HttpStatus.OK)
	public List<UsersNewDto> getAllUsers(@PathVariable Long locationId) {
		return userService.getAllUsersByLocationId(locationId).stream()
				.filter(obj -> obj.getStatus().equalsIgnoreCase("ACTIVE")).toList();
	}

	@DeleteMapping("/deleteUserByIdLogin/{id}")
	public ResponseEntity<String> deleteUser(@PathVariable Long id) {

		if (userService.deleteUser(id) != 0) {
			return ResponseEntity.ok("sucessfully deleted");
		} else {
			return ResponseEntity.ok(" not deleted ");
		}
	}

	@GetMapping("/getAllUsersLogin")
	@ResponseStatus(value = HttpStatus.OK)
	public List<UsersNewDtoGet> getAllData() {
		return userService.getAllUsers();
	}

	@PutMapping("/{userId}/changePassword")
	@ResponseStatus(value = HttpStatus.OK)
	public Map<String, String> resetPassword(@RequestBody ChangePasswordDto changePassword, @PathVariable long userId) {
		String passResponse = userService.changePassword(changePassword, userId);
		Map<String, String> response = new HashMap<>();
		response.put("message", passResponse);
		return response;
	}

	@PostMapping("/forgotPassword/sendOtp")
	public Map<String, String> forgotPasswordSendOtp(@RequestBody ForgotPasswordDto forgotPassword) {
		return userService.forgotPasswordSendOtp(forgotPassword);
	}

	@PostMapping("/forgotPassword/sendPassword")
	@ResponseStatus(value = HttpStatus.OK)
	public Map<String, String> forgotPasswordSendPassword(@RequestBody ForgotPasswordDto otp) {
		return userService.forforgotPasswordSendPassword(otp);
	}

}
