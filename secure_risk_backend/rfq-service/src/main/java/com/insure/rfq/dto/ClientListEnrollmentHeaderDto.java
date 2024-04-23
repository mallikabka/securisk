package com.insure.rfq.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ClientListEnrollmentHeaderDto {

	private boolean employeeIdStatus;

	private boolean employeeNameStatus;

	private boolean dateOfBirthStatus;

	private boolean genderStatus;

	private boolean relationStatus;

	private boolean ageStatus;

	private boolean dateOfJoiningStatus;

	private boolean eCardNumber;

	private boolean policyStartDateStatus;

	private boolean policyEndDateStatus;

	private boolean SumInsuredStatus;

	private boolean groupNameStatus;

	private boolean insuredCompanyNameStatus;
}
