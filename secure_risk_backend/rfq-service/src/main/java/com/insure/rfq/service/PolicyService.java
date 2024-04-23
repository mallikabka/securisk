package com.insure.rfq.service;

import java.util.List;

import com.insure.rfq.dto.GetClientListPolicyDto;
import com.insure.rfq.dto.PolicyDto;

public interface PolicyService {

	public String createPolicyData(PolicyDto policyDto ,Long clientID ,Long produtId) ;

	public List<GetClientListPolicyDto> getAllPolicyEntities();
}
