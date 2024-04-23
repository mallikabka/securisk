package com.insure.rfq.service;

import java.util.List;

import com.insure.rfq.dto.EmpDepedentDto;
import com.insure.rfq.dto.EmpDependentHeaderDto;
import com.insure.rfq.dto.ExcelReportHeadersDto;
import com.insure.rfq.entity.EmpDependentHeaders;

public interface EmpDependentHeaderService {
	
	EmpDependentHeaderDto createHeaders(EmpDependentHeaderDto header);
	
	List<EmpDependentHeaders> viewAllHeaders();
	
	List<String> getAllEmpDependentHeaders();
}
