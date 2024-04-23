package com.insure.rfq.service;

import com.insure.rfq.dto.Cd_balanceDetailsHeadersDto;
import com.insure.rfq.dto.Cd_balanceDisplayDto;
import com.insure.rfq.dto.Cd_balanceHeaderMappingDto;
import com.insure.rfq.dto.Cd_balanceHeaderStatusDto;
import com.insure.rfq.entity.Cd_balanceEntitytable;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;


public interface Cd_balanceHeaderUploadService {

    Cd_balanceHeaderMappingDto uploadEnrollement(Cd_balanceHeaderMappingDto clientListEnrollementUploadDto);
    Cd_balanceHeaderStatusDto validateHeaders(MultipartFile multipartFile);
//    List<Cd_balanceEntitytable> getDataformFile(MultipartFile file);
List<Cd_balanceDisplayDto> getDataformFile(Long clientID, Long produtId);
    public String saveData(MultipartFile file, Long clientID, Long productId);
    public byte[] generateExcelFromData(Long clientListId, Long productId);

}
