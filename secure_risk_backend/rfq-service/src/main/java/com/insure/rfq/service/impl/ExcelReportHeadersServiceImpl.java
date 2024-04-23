package com.insure.rfq.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.insure.rfq.dto.ExcelReportHeadersDto;
import com.insure.rfq.entity.ExcelReportHeaders;
import com.insure.rfq.entity.ExcelReportHeadersMapping;
import com.insure.rfq.repository.ExcelReportHeadersMappingRepository;
import com.insure.rfq.repository.ExcelReportHeadersRepository;
import com.insure.rfq.service.ExcelReportHeadersService;

@Service
public class ExcelReportHeadersServiceImpl implements ExcelReportHeadersService {

	@Autowired
	private ExcelReportHeadersRepository headersRepo;
	@Autowired
	private ExcelReportHeadersMappingRepository headerMappingRepo;
	@Autowired
	private ModelMapper modelMapper;

	@Override
	public ExcelReportHeadersDto createHeaders(ExcelReportHeadersDto header) {

//        List<ExcelReportHeaders> excelReportHeaders = headersRepo.findAll();
//        if(excelReportHeaders.isEmpty()) {
//            ExcelReportHeaders headers = new ExcelReportHeaders();
//            headers.setHeaderName(header.getHeaderName());
//            headers.setHeaderCategory(header.getHeaderCategory());
//            headers.setStatus("ACTIVE");
//            headers.setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
//            headersRepo.save(headers);
//            ExcelReportHeadersMapping headerMapping = new ExcelReportHeadersMapping();
//            headerMapping.setAliasName(header.getHeaderAliasname().getAliasName());
//            headerMapping.setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
//            headerMapping.setStatus("ACTIVE");
//            headerMapping.setReportHeaders(headers);
//            headerMappingRepo.save(headerMapping);
//            
//            return modelMapper.map(headers, ExcelReportHeadersDto.class);
//        }else {
//            boolean flag = false;
//            //For loop prevents redundant data(i..e both headerName and headerCategory considered as single record)
//            //But there might be headerName column consists of duplicate values
//            //But there might be headerCategory column consists of duplicate values
//            //But both headerName and headerCategory combine shouldn't store duplicate values
//            for (ExcelReportHeaders excelReportHeaders2 : excelReportHeaders) {
//                if(!excelReportHeaders2.getHeaderName().equals(header.getHeaderName()) || 
//                        !excelReportHeaders2.getHeaderCategory().equals(header.getHeaderCategory())) {
//                    flag = true;
//                }
//            }
//            if(flag) {
//                List<ExcelReportHeadersMapping> mappings = new ArrayList<>();
//                ExcelReportHeaders excelReportHeaders2 = new ExcelReportHeaders();
//                excelReportHeaders2.setHeaderName(header.getHeaderName());
//                excelReportHeaders2.setHeaderCategory(header.getHeaderCategory());
//                excelReportHeaders2.setStatus("ACTIVE");
//                excelReportHeaders2.setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
//                headersRepo.save(excelReportHeaders2);
//                
//                ExcelReportHeadersMapping headerMapping = new ExcelReportHeadersMapping();
//                headerMapping.setAliasName(header.getHeaderAliasname().getAliasName());
//                headerMapping.setReportHeaders(excelReportHeaders2);
//                headerMapping.setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
//                headerMapping.setStatus("ACTIVE");
//                mappings.add(headerMapping);
//                headerMappingRepo.save(headerMapping);
//                
//                return modelMapper.map(excelReportHeaders2, ExcelReportHeadersDto.class);
//            }
//        }
//        return null;
//        ClaimMisHeaderCreateDto misHeaderDto = new ClaimMisHeaderCreateDto();
		ExcelReportHeaders findByHeaderNameAndHeaderCategory = headersRepo
				.findByHeaderNameAndHeaderCategory(header.getHeaderName(), header.getHeaderCategory());
		System.out.println("findByHeaderNameAndHeaderCategory :: " + findByHeaderNameAndHeaderCategory);
		if (findByHeaderNameAndHeaderCategory == null) {
			ExcelReportHeaders excelHeaders = new ExcelReportHeaders();
			excelHeaders.setHeaderName(header.getHeaderName());
			excelHeaders.setHeaderCategory(header.getHeaderCategory());
			excelHeaders.setStatus("ACTIVE");
			excelHeaders.setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
			headersRepo.save(excelHeaders);

			ExcelReportHeadersMapping headerMapping = new ExcelReportHeadersMapping();
			headerMapping.setAliasName(header.getHeaderAliasname().getAliasName());
			headerMapping.setReportHeaders(excelHeaders);
			headerMapping.setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
			headerMapping.setStatus("ACTIVE");
			headerMappingRepo.save(headerMapping);

			header.setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
			header.setStatus("ACTIVE");
			header.getHeaderAliasname().setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
			header.getHeaderAliasname().setStatus("ACTIVE");
			return header;
		} else {
			ExcelReportHeaders findByHeaderName = headersRepo.findByHeaderName(header.getHeaderName());
//            Long headerId = findByHeaderName.getHeaderId();
//            List<ExcelReportHeadersMapping> findByExcelReportId = headerMappingRepo.getBasedOnHeaderId(headerId);

//            for (ExcelReportHeadersMapping excelReportHeadersMapping : findByExcelReportId) {
			ExcelReportHeadersMapping excelReportHeadersMapping = new ExcelReportHeadersMapping();
			excelReportHeadersMapping.setAliasName(header.getHeaderAliasname().getAliasName());
			excelReportHeadersMapping.setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
			excelReportHeadersMapping.setStatus("ACTIVE");
			excelReportHeadersMapping.setReportHeaders(findByHeaderName);
			ExcelReportHeadersMapping validateHeaderMapping = headerMappingRepo.save(excelReportHeadersMapping);

//                if(validateHeaderMapping != null) {
//                    misHeaderDto.setHeaderName(header.getHeaderName());
//                    misHeaderDto.setHeaderCategory(header.getHeaderCategory());
//                    misHeaderDto.setHeaderAliasName(header.getHeaderAliasname().getAliasName());
//                }
//            }
			header.setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
			header.setStatus("ACTIVE");
			header.getHeaderAliasname().setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
			header.getHeaderAliasname().setStatus("ACTIVE");
			return header;
		}
	}

	@Override
	public List<ExcelReportHeaders> viewAllHeaders() {
		return headersRepo.findAll();
	}

}
