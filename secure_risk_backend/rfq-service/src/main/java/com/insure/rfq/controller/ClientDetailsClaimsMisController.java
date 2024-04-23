package com.insure.rfq.controller;

import com.insure.rfq.dto.*;
import com.insure.rfq.service.ClientDetailsClaimsMisService;
import com.insure.rfq.service.CoverageDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ClientDetails/ClaimsMis")
@CrossOrigin(origins = "*")
public class ClientDetailsClaimsMisController {

    @Autowired
    private ClientDetailsClaimsMisService clientDetailsClaimsMisService;

    @Autowired
    private CoverageDetailsService service;

    @PostMapping("/createClaimsMis")
    public ResponseEntity<String> createCoverage(@ModelAttribute ClaimsMisClientDetailsDto coverageDto, @RequestParam Long ClientId) {
        if (coverageDto != null) {
            String rfqId = String.valueOf(clientDetailsClaimsMisService.create(coverageDto,ClientId));
            return new ResponseEntity<>(rfqId, HttpStatus.CREATED);
        }
        return null;
    }
    @PostMapping("/uploadFile")
    public ResponseEntity<String> uploadCoverageDetails(@ModelAttribute ClientDetailsClaimsMisUploadDto coverageUploadDto, @RequestParam Long clientlistId, @RequestParam Long productId) {
        if (!coverageUploadDto.getFile().isEmpty()) {
            String filePath = clientDetailsClaimsMisService.uploadFileCoverage(coverageUploadDto,clientlistId,productId);
            return new ResponseEntity<>(filePath, HttpStatus.OK);
        }
        return new ResponseEntity<>("No File Found", HttpStatus.NOT_FOUND);
    }
    @GetMapping("/getClientListClaimsUploadData")
    public ResponseEntity<List<ClaimsMisNewDto>> getClientListClaimsUploadData(@RequestParam  String rfqId){
        return ResponseEntity.ok(clientDetailsClaimsMisService.getDataWithStatus(rfqId));
    }

    @GetMapping("/statusCounts")
    public ResponseEntity<Map<String, Long>> getStatusCounts(@RequestParam String rfqId) {
        Map<String, Long> statusCounts = (Map<String, Long>) clientDetailsClaimsMisService.getStatusCounts(rfqId);
        return ResponseEntity.ok().body(statusCounts);
    }

    @GetMapping("/getAllClaimsMis")
    public ResponseEntity<List<ClaimsMisNewDto>> getAllClaimsMis( @RequestParam Long clientListId, @RequestParam Long productId) {
        return new ResponseEntity<>(clientDetailsClaimsMisService.getAllClaimsMisByRfqId(clientListId,productId), HttpStatus.OK);
    }
    @PostMapping("/headerClaimsMiscValidation")
    public ResponseEntity<CovergaeHeaderValidateDto> claimsMisHeaderValidation(@RequestPart MultipartFile file,
                                                                               @RequestParam String tpaName) {
        CovergaeHeaderValidateDto validateDto = clientDetailsClaimsMisService.validateClaimsMisHeader(file, tpaName);
        return new ResponseEntity<>(validateDto, HttpStatus.OK);
    }

    @PostMapping("/getAllClaimsMisWithStatus")
    public ResponseEntity<List<ClaimsMisDataStatusValidateDto>> claimsMisDataValidation(@RequestPart MultipartFile file,
                                                                                        @RequestParam String tpaName) {
        List<ClaimsMisDataStatusValidateDto> validateClaimsMisDataWithStatus = clientDetailsClaimsMisService
                .validateClaimsMisDataWithStatus(file, tpaName);
        if (!validateClaimsMisDataWithStatus.isEmpty()) {
            return new ResponseEntity<>(validateClaimsMisDataWithStatus, HttpStatus.OK);
        }
        return new ResponseEntity<>(validateClaimsMisDataWithStatus, HttpStatus.NO_CONTENT);
    }
    @GetMapping("/clientDetailsClaimsMisDetailsExport")
    @ResponseStatus(HttpStatus.OK)
    public ResponseEntity<byte[]> getAllMembersDetailsByExcelFormatByClientListProduct(

            @RequestParam Long clientListId, @RequestParam Long productId) {

        byte[] excelData = clientDetailsClaimsMisService.generateExcelFromData(clientListId, productId);

        HttpHeaders headers = new HttpHeaders();

        headers.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));

        headers.setContentDispositionFormData("attachment", "Client_Details_Claims_Mis.xlsx");

        return new ResponseEntity<>(excelData, headers, HttpStatus.OK);

    }

}
