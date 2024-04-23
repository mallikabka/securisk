package com.insure.rfq.dto;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class PolicyTermsDto {

//	@NotBlank
	@JsonProperty(value = "rfqId")
	private String rfqId;
	
	@Valid
	@JsonProperty(value = "policyDetails")
	private List<PolicyTermsChildDto> policyDetails;
	
	@JsonProperty(value= "createDate")
	private Date createDate;

	@JsonProperty(value= "updateDate")
	private Date updateDate;

	@JsonProperty(value= "recordStatus")
	private String recordStatus;
}
