package com.insure.rfq.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PolicyCoverageDto {

	private Long coverageId;
	private String coverage;
//	@JsonIgnore
//	private Product product;
}
