package com.insure.rfq.dto;

import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class PolicyTermsChildDto {
	
	@JsonProperty(value = "policyTermId")
	private UUID policyTermId;
	
//	@NotBlank
	@JsonProperty(value = "coverageName")
	private String coverageName;
	
//	@NotBlank
	@JsonProperty(value = "remark")
	private String remark;
}
