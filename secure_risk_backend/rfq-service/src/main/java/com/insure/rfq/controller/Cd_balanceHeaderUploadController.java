package com.insure.rfq.controller;

import com.insure.rfq.dto.Cd_balanceHeaderMappingDto;
import com.insure.rfq.service.Cd_balanceHeaderUploadService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("/rfq/Cd_balanceHeaderUploadController")
@Slf4j
@CrossOrigin(originPatterns = "*")
public class Cd_balanceHeaderUploadController {

	@Autowired
	private Cd_balanceHeaderUploadService cd_balanceHeaderUploadService;

	@PostMapping("/uploadheaders")
	public ResponseEntity<?> uploadEnrollement(@RequestBody Cd_balanceHeaderMappingDto cd_balanceHeaderMappingDto) {
		try {
			Cd_balanceHeaderMappingDto result = cd_balanceHeaderUploadService
					.uploadEnrollement(cd_balanceHeaderMappingDto);
			if (result != null) {
				return ResponseEntity.ok(result);
			} else {
				return ResponseEntity.status(HttpStatus.BAD_REQUEST)
						.body("Request body is empty or headers list is null");
			}
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occurred: " + e.getMessage());
		}
	}

	 @PostMapping ("/Cd_balanceheaderSave")
	    public ResponseEntity<?> saveData(@RequestPart MultipartFile multipartFile,@RequestParam Long clientId,
	                                                        @RequestParam Long productId)  throws IOException {
	        //return  ResponseEntity.ok(cd_balanceHeaderUploadService.getDataformFile(multipartFile,clientId,productId));
	        return  ResponseEntity.ok(cd_balanceHeaderUploadService.saveData(multipartFile,clientId,productId));
	    }
	 @PostMapping ("/Cd_balanceheaderValidation")
	    public ResponseEntity<?> validations(@RequestPart MultipartFile file)  throws IOException {
	        //return  ResponseEntity.ok(cd_balanceHeaderUploadService.getDataformFile(multipartFile,clientId,productId));
	        return  ResponseEntity.ok(cd_balanceHeaderUploadService.validateHeaders(file));
	    }
	@GetMapping("/Cd_balanceheadergetDataByClientIdAndProductId")
	public ResponseEntity<?> getData(@RequestParam Long clientId, @RequestParam Long productId) throws IOException {
		return ResponseEntity.ok(cd_balanceHeaderUploadService.getDataformFile(clientId, productId));
		// return
		// ResponseEntity.ok(cd_balanceHeaderUploadService.saveData(multipartFile,clientId,productId));
	}

	@GetMapping("/exportExcel")
	@ResponseStatus(value = HttpStatus.NOT_FOUND)
	public ResponseEntity<byte[]> exportExcel(@RequestParam Long clientId, @RequestParam Long productId) {
		log.info(clientId + " -----------" + productId);
		byte[] excelData = cd_balanceHeaderUploadService.generateExcelFromData(clientId, productId);
		// return new ResponseEntity<>(excelBytes, headers, HttpStatus.OK);
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		headers.setContentDispositionFormData("attachment", "Premium_Calculator.xlsx");

		return ResponseEntity.ok().contentType(MediaType.APPLICATION_OCTET_STREAM).headers(headers).body(excelData);
	}

	@GetMapping("/sayhai")
	public String say() {
		return "HAiiiiiiiiiiiiiii,";
	}

}
