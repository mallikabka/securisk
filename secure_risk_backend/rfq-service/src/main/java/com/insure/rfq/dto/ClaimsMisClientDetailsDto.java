package com.insure.rfq.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;

@Data
public class ClaimsMisClientDetailsDto {




    @JsonProperty(value ="claimsMiscFilePath")
    MultipartFile claimsMiscFilePath;

}
