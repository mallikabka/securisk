package com.insure.rfq.controller;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import com.insure.rfq.dto.ClientListCoverageDetailsDto;
import com.insure.rfq.service.DownloadService;
import com.itextpdf.text.DocumentException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.insure.rfq.dto.ClientListCoverageDetailsDto;
import com.insure.rfq.generator.RFQReportPDfGenerator;
import com.insure.rfq.repository.EmployeeRepository;
import com.insure.rfq.service.CorporateDetailsService;
import com.insure.rfq.service.DownloadService;
import com.itextpdf.text.DocumentException;

@RestController
@RequestMapping("/rfq/download")
@CrossOrigin(value = { "*" })
public class DownloadController {
	@Autowired
	private RFQReportPDfGenerator pDfGenerator;

	@Autowired
	private DownloadService downloadService;
	@Autowired
	private EmployeeRepository employeeRepository;
	@Autowired
	private CorporateDetailsService service;

	@GetMapping("/pdf/{id}")
	public ResponseEntity<byte[]> downloadPdf(@PathVariable String id) {
		byte[] generatePdf = pDfGenerator.generatePdf(id);
		HttpHeaders headers = new HttpHeaders();
		headers.add(HttpHeaders.CONTENT_DISPOSITION, " attachment;filename:data.pdf");
		return ResponseEntity.ok().headers(headers).contentType(MediaType.APPLICATION_PDF).body(generatePdf);

	}

	@GetMapping("/coveragePdf/{rfqId}")
	public ResponseEntity<byte[]> downloadCoveragePdf(@PathVariable String rfqId) throws IOException, DocumentException {
		byte[] generatePdf = downloadService.generateCoverageDetails(rfqId);
		HttpHeaders headers = new HttpHeaders();
		headers.add(HttpHeaders.CONTENT_DISPOSITION, " attachment;filename:data.pdf");
		return ResponseEntity.ok().headers(headers).contentType(MediaType.APPLICATION_PDF).body(generatePdf);
	}

	@GetMapping("/employeeData")
	public ResponseEntity<Resource> downloadEmpDataPdf(@RequestParam String id) {

		byte[] downloadClaimMisc = service.getEmployeeData(id);
		ByteArrayResource resource = new ByteArrayResource(downloadClaimMisc);

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		headers.add(HttpHeaders.CONTENT_DISPOSITION, " attachment;filename:empdata.xlsx");
		return ResponseEntity.ok().headers(headers).contentLength(downloadClaimMisc.length).body(resource);
	}

	@GetMapping("/irda")
	public ResponseEntity<byte[]> downloadIrdaPdf(@RequestParam String rfqId) throws IOException {
		byte[] irdaData = service.getIrdaData(rfqId);
		HttpHeaders headers = new HttpHeaders();
		headers.add(HttpHeaders.CONTENT_DISPOSITION, " attachment;filename:empdata.pdf");
		return ResponseEntity.ok().headers(headers).contentType(MediaType.APPLICATION_PDF).body(irdaData);
	}

	@PostMapping("/clientListCoverage")
	public ResponseEntity<byte[]> downloadClientListCoveragePdf(@RequestParam Long clientListId, @RequestParam Long productId, @RequestBody List<ClientListCoverageDetailsDto> clientListCoverageDetailsDto) throws IOException, DocumentException {
		byte[] generatePdf = downloadService.generateClientListCoverageDetails(clientListId,productId,clientListCoverageDetailsDto);
		HttpHeaders headers = new HttpHeaders();
		headers.add(HttpHeaders.CONTENT_DISPOSITION, " attachment;filename:data.pdf");
		return ResponseEntity.ok().headers(headers).contentType(MediaType.APPLICATION_PDF).body(generatePdf);
	}
}
