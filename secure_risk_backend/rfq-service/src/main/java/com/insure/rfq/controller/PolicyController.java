package com.insure.rfq.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.insure.rfq.dto.GetClientListPolicyDto;
import com.insure.rfq.dto.PolicyDto;
import com.insure.rfq.service.impl.PolicyServiceImpl;

@RestController
@RequestMapping("/rfq/policy")
@CrossOrigin("*")
public class PolicyController {

	@Autowired
	private PolicyServiceImpl policyServiceImpl;
	@Autowired
	private final ObjectMapper objectMapper;

	public PolicyController(ObjectMapper objectMapper) {
		this.objectMapper = objectMapper;
	}

	@PostMapping("/addPolicy")
	@ResponseStatus(value = HttpStatus.CREATED)
	public String saveEntity(@ModelAttribute PolicyDto policyDto, @RequestParam Long clientId,
			@RequestParam Long productId) {
		//System.out.println(clientId + " -----" + productId);
		return policyServiceImpl.createPolicyData(policyDto, clientId, productId);

	}

	@GetMapping("/getAllPolicys")
	@ResponseStatus(value = HttpStatus.OK)
	public List<GetClientListPolicyDto> getAllPloicDto() {
		return policyServiceImpl.getAllPolicyEntities();
	}
	@GetMapping("/getAPolicy")
	@ResponseStatus(value = HttpStatus.OK)
	public  GetClientListPolicyDto getClientListPolicy( @RequestParam Long clientId,
													   @RequestParam Long productId) {
		return  policyServiceImpl.getByProductAndClientId(clientId,productId);
	}
}
