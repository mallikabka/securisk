package com.insure.rfq.service;

import com.insure.rfq.dto.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface ClientDetailsClaimsMisService {


    public MultipartFile create(ClaimsMisClientDetailsDto clientDetailsDto, Long clientlistId);

    CovergaeHeaderValidateDto validateClaimsMisHeader(MultipartFile file, String tpaName);

    List<ClaimsMisDataStatusValidateDto> validateClaimsMisDataWithStatus(MultipartFile file, String tpaName);

    List<ClaimsMisNewDto> getAllClaimsMisByRfqId( Long clientlistId, Long productId);

    List<Object[]> getRfqCounts();

    ClaimsUploadDto getClaimsAferUpload(String rfqId);

    ClaimsDumpDto getClaimsDump(String rfqId);

    List<ClaimsMisNewDto> getDataWithStatus(String rfqId);
    Object getStatusCounts(String rfqId);

    String uploadFileCoverage(ClientDetailsClaimsMisUploadDto coverageUploadDto, Long clientlistId, Long productId);
    public byte[] generateExcelFromData(Long clientListId, Long productId);

}
