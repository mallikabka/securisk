package com.insure.rfq.login.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LocationLoginDto {

	private Long locationId;
	private String sno;
	private String locationName;
	private List<UsersNewDtoGet> usersNewId;
//	private String status;
}
