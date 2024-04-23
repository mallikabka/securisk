package com.insure.rfq.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.insure.rfq.dto.PolicyTypeDto;
import com.insure.rfq.service.impl.PolicyTypeServiceImpl;

@RequestMapping("/policyType")
@RestController
@CrossOrigin(origins = "*")
public class PolicyTypeController {

	@Autowired
	private PolicyTypeServiceImpl policyTypeServiceImpl;

	@PostMapping("/addPolicyType/{id}")
	public ResponseEntity<PolicyTypeDto> createPolicyType(@RequestBody PolicyTypeDto policyTypeDto,
			@PathVariable Long id) {
		PolicyTypeDto createPolicy = policyTypeServiceImpl.createPolicy(policyTypeDto, id);
		return new ResponseEntity<>(createPolicy, HttpStatus.CREATED);
	}

	@GetMapping("/getPolicyTypeById/{id}")
	public ResponseEntity<List<String>> getPolicyTypeById(@PathVariable Long id) {
		List<String> policyTypeById = policyTypeServiceImpl.getPolicyTypeById(id);
		return new ResponseEntity<>(policyTypeById, HttpStatus.OK);
	}
}
