package com.insure.rfq.service;

import java.util.List;
import java.util.UUID;

import com.insure.rfq.dto.PolicyTermsChildDto;
import com.insure.rfq.dto.PolicyTermsDto;
import com.insure.rfq.entity.PolicyTermsEntity;

public interface PolicyTermsService {

	List<PolicyTermsEntity> createPolicyTerms(PolicyTermsDto details);

	List<PolicyTermsEntity> updatePolicyTerms(PolicyTermsDto details);

	List<PolicyTermsEntity> getPolicyTermsByRfqId(String rfqId);

	String deletePolicyTermsByRfqId(String rfqId);
}
