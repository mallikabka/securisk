package com.insure.rfq.login.dto;

import java.util.List;
import java.util.Optional;

import com.insure.rfq.login.entity.Department;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserInfo {
	private String accessToken;
	private String refreshToken;
	private LocationInfo locationInfo; 
	private DepartmentInfo departmentInfo;
	private List<ProductCategory> productCategory;
	private DesignationBasedOperation designationBasedOperation;
	private Boolean isLogin;
	
	private long userId;
	private int loginSession;

	
	
}
