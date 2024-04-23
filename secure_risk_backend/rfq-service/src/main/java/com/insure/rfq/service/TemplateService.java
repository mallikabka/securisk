package com.insure.rfq.service;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import com.insure.rfq.dto.TemplateDto;
import com.insure.rfq.entity.TemplateDetails;

public interface TemplateService {

	TemplateDto createTemplate(TemplateDto templatesDto);

	List<TemplateDto> getTemplatesByType(String type);

	List<byte[]> getTemplateFilesByType(String type);

	byte[] getFileDataById(Long id);

	List<TemplateDto> getAllTemplates();

	TemplateDto updateTemplate(Long id, TemplateDto updatedTemplateDto);

	boolean deleteTemplate(Long id);

	List<TemplateDetails> getTemplatesByProductId(Long productId);

	TemplateDto getTemplateById(Long id);

}
