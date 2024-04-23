package com.insure.rfq.dto;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.insure.rfq.entity.TemplateDetails;

import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TemplateDto {
	@Id
	@GeneratedValue
	private Long id;
	@JsonFormat
	private String templateName;

	@JsonFormat
	private String templateType;

	@JsonFormat
	private String type;
	@Lob
	private MultipartFile templateFile;

	@JsonProperty(value = "templateFileName")
	private String templateFileName;

	@JsonFormat
	private String permissions;

	
	private Long productId;
	private Date createDate; // Added createdate field

	private Date updateDate; // Added updatedate field
	

}
