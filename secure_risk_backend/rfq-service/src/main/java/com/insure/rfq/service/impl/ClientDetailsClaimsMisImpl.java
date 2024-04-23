package com.insure.rfq.service.impl;

import com.insure.rfq.dto.*;
import com.insure.rfq.entity.*;
import com.insure.rfq.exception.InvalidClientList;
import com.insure.rfq.exception.InvalidProduct;
import com.insure.rfq.repository.*;
import com.insure.rfq.service.ClientDetailsClaimsMisService;
import com.insure.rfq.utils.ExcelUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.compress.utils.FileNameUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.poi.EncryptedDocumentException;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
public class ClientDetailsClaimsMisImpl implements ClientDetailsClaimsMisService {

    @Autowired
    private ClaimsMisRepository claimsMisRepo;
    @Autowired
    private TpaRepository tpaRepo;


    @Autowired
    private ClientDetailsClaimsMisRepository clientDetailsClaimsMisRepository;

    @Autowired
    private CoverageFileUploadRepository fileUploadRepo;


    @Value("${file.path.coverageMain}")
    private String mainpath;

    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private ClientListRepository clientListRepository;
    @Autowired
    private ExcelUtils excelUtils;

    @Autowired
    private ClientDetailsClaimsMisNewRepo clientDetailsClaimsMisNewRepo;

    @Override
    public MultipartFile create(ClaimsMisClientDetailsDto clientDetailsDto, Long clientlistId ) {

        ClientDetailsClaimsMisEntity clientDetailsClaimsMisEntity = new ClientDetailsClaimsMisEntity();
        File folder = new File(mainpath);
        if (clientlistId != null) {
            ClientList clientList = clientListRepository.findById(clientlistId).orElseThrow(() -> new InvalidClientList("ClientList Not Found"));
            clientDetailsClaimsMisEntity.setRfqId(clientList.getRfqId());
        }


        clientDetailsClaimsMisEntity.setClaimsMiscFilePath(String.valueOf(clientDetailsDto.getClaimsMiscFilePath()));
     //   clientDetailsClaimsMisEntity.setClaimsSummaryFilePath(clientDetailsDto.getClaimsSummaryFilePath());
        clientDetailsClaimsMisEntity.setCreateDate(new Date());
        clientDetailsClaimsMisEntity.setRecordStatus("ACTIVE");
        clientDetailsClaimsMisNewRepo.save(clientDetailsClaimsMisEntity);
        return clientDetailsDto.getClaimsMiscFilePath();
    }

    @Override
    public CovergaeHeaderValidateDto validateClaimsMisHeader(MultipartFile file, String tpaName) {


        try (Workbook workbook = getWorkbook(file, tpaName)) {
            Sheet sheet = null;
            int numberOfSheets = workbook.getNumberOfSheets();
            for (int k = 0; k < numberOfSheets; k++) {
                if (tpaName.equals("HealthIndia")) {
//				sheet = workbook.getSheet("Health India-Claim MIS");
                    sheet = workbook.getSheetAt(k);
                } else if (tpaName.equals("Vidal")) {
//				sheet = workbook.getSheet("CLAIMS DUMP");
                    sheet = workbook.getSheetAt(k);
                } else if (tpaName.equals("Starhealth")) {
//				sheet = workbook.getSheet("Sheet_2_crosstab");
                    sheet = workbook.getSheetAt(k);
                } else if (tpaName.equals("Medseva")) {
//				sheet = workbook.getSheet("total claims dump");
                    sheet = workbook.getSheetAt(k);
                } else if (tpaName.equals("FHPL")) {
//                sheet = workbook.getSheet("Claims&Preauth");
                    sheet = workbook.getSheetAt(k);
                } else if (tpaName.equals("MediAssist")) {
//				sheet = workbook.getSheet("RI & CL_1");
                    sheet = workbook.getSheetAt(k);
                } else if (tpaName.equals("GHPL")) {
//				sheet = workbook.getSheet("Data");
                    sheet = workbook.getSheetAt(k);
                } else if (tpaName.equals("ICICI")) {
//				sheet = workbook.getSheet("Sheet1");
                    sheet = workbook.getSheetAt(k);
                } else if (tpaName.equals("MD India")) {
//				sheet = workbook.getSheet("Claims Paid");
                    sheet = workbook.getSheetAt(k);
                } else if (tpaName.equals("R-care")) {
//                sheet = workbook.getSheet("CL");
                    sheet = workbook.getSheetAt(k);
                } else {
                    sheet = workbook.getSheetAt(k);
                }
                if (sheet != null) {
                    sheet = workbook.getSheetAt(k);
                }

                Iterator<Row> rowIterator = sheet.iterator();

                // Assuming the first row contains the column names
                Row headerRow = rowIterator.next();

                CovergaeHeaderValidateDto validateDto = new CovergaeHeaderValidateDto();
                Iterator<Cell> cellIterator = headerRow.cellIterator();
                List<String> headerList = new ArrayList<>();
                while (cellIterator.hasNext()) {
                    Cell cell = cellIterator.next();
                    String columnName = cell.getStringCellValue().trim(); // Convert to lowercase for
                    // case-insensitive matching
                    headerList.add(columnName);
                }

                Tpa findByTpaName = tpaRepo.findByTpaName(tpaName);
                List<ClaimsTPAHeaders> tpaHeaders = findByTpaName.getTpaHeaders();
                tpaHeaders.stream().forEach(i -> {

                    switch (i.getHeaderAliasName()) {
                        case "Policy Number": {
                            validateDto.setPolicyNumberStatus(true);
                            break;
                        }
                        case "Claim Number": {
                            validateDto.setClaimsNumberStatus(true);
                            break;
                        }
                        case "Employee Id": {
                            validateDto.setEmployeeIdStatus(true);
                            break;
                        }
                        case "Employee Name": {
                            validateDto.setEmployeeNameStatus(true);
                            break;
                        }
                        case "RelationShip": {
                            validateDto.setRelationshipStatus(true);
                            break;
                        }
                        case "Gender": {
                            validateDto.setGenderStatus(true);
                            break;
                        }
                        case "Age": {
                            validateDto.setAgeStatus(true);
                            break;
                        }
                        case "Patient Name": {
                            validateDto.setPatientNameStatus(true);
                            break;
                        }
                        case "Sum Insured": {
                            validateDto.setSumInsuredStatus(true);
                            break;
                        }
                        case "Claimed Amount": {
                            validateDto.setClaimedAmountStatus(true);
                            break;
                        }
                        case "Paid Amount": {
                            validateDto.setPaidAmountStatus(true);
                            break;
                        }
                        case "Outstanding Amount": {
                            validateDto.setOutstandingAmountStatus(true);
                            break;
                        }
                        case "Claim Status": {
                            validateDto.setClaimStatus(true);
                            break;
                        }
                        case "Date Of Claim": {
                            validateDto.setDateOfClaimStatus(true);
                            break;
                        }
                        case "Claim Type": {
                            validateDto.setClaimTypeStatus(true);
                            break;
                        }
                        case "Network Type": {
                            validateDto.setNetworkTypeStatus(true);
                            break;
                        }
                        case "Hospital Name": {
                            validateDto.setHospitalNameStatus(true);
                            break;
                        }
                        case "Admission Date": {
                            validateDto.setAdmissionDateStatus(true);
                            break;
                        }
                        case "Disease": {
                            validateDto.setDiseaseStatus(true);
                            break;
                        }
                        case "Date of Discharge": {
                            validateDto.setDischargeDateStatus(true);
                            break;
                        }
                        case "Member Code": {
                            validateDto.setMemberCodeStatus(true);
                            break;
                        }
                        case "Policy Start Date": {
                            validateDto.setPolicyStartDateStatus(true);
                            break;
                        }
                        case "Policy End Date": {
                            validateDto.setPolicyEndDateStatus(true);
                            break;
                        }
                        case "Hospital State": {
                            validateDto.setHospitalStateStatus(true);
                            break;
                        }
                        case "Hospital City": {
                            validateDto.setHospitalCityStatus(true);
                            break;
                        }
                    }
                });

                if (tpaName.equals("MediAssit")) {
                    validateDto.setNetworkTypeStatus(true);
                    validateDto.setHospitalStateStatus(true);
                } else if (tpaName.equals("Medseva")) {
                    validateDto.setSumInsuredStatus(true);
                    validateDto.setNetworkTypeStatus(true);
                } else if (tpaName.equals("R-Care")) {
                    validateDto.setNetworkTypeStatus(true);
                } else if (tpaName.equals("GHPL")) {
                    validateDto.setNetworkTypeStatus(true);
                    validateDto.setHospitalStateStatus(true);
                } else if (tpaName.equals("ICICI")) {
                    validateDto.setAgeStatus(true);
                    validateDto.setGenderStatus(true);
                    validateDto.setNetworkTypeStatus(true);
                    validateDto.setPolicyStartDateStatus(true);
                    validateDto.setPolicyEndDateStatus(true);
                    validateDto.setHospitalStateStatus(true);
                    validateDto.setHospitalCityStatus(true);
                } else if (tpaName.equals("MD India")) {
                    validateDto.setNetworkTypeStatus(true);
                }

                validateDto.setStatus(true);

                return validateDto;

            }
        } catch (EncryptedDocumentException | IOException e) {
            e.printStackTrace();
            //return null;
        }
        return null;
    }

    private Workbook getWorkbook(MultipartFile file, String tpaName) throws IOException {

        String extension = FileNameUtils.getExtension(file.getOriginalFilename());
        String fileName = file.getOriginalFilename();

        System.out.println("extension :: " + extension);
        System.out.println("fileName :: " + fileName);

        if (fileName != null && (fileName.endsWith(".xlsx") || fileName.endsWith(".XLSX") || fileName.endsWith(".xlsb")
                || fileName.endsWith(".XLSB"))) {
            // Handle XLSX
            return new XSSFWorkbook(file.getInputStream());
        } else {
            // Handle XLS
            return new HSSFWorkbook(file.getInputStream());
        }

    }

    @Override
    public List<ClaimsMisDataStatusValidateDto> validateClaimsMisDataWithStatus(MultipartFile file, String tpaName) {

        List<ClaimsMisDataStatusValidateDto> claimsMisValidateData = new ArrayList<>();

        try (Workbook workbook = getWorkbook(file, tpaName)) {
            Sheet sheet = null;
            // Sheet sheetAL = null;
            int numberOfSheets = workbook.getNumberOfSheets();
            log.info("Sheet name  and it's no of sheets :{} ", numberOfSheets);
            for (int i = 0; i < numberOfSheets; i++) {

                if (tpaName.equals("HealthIndia")) {
//				sheet = workbook.getSheet("Health India-Claim MIS");
                    sheet = workbook.getSheetAt(i);
                } else if (tpaName.equals("Vidal")) {
//				sheet = workbook.getSheet("CLAIMS DUMP");
                    sheet = workbook.getSheetAt(i);
                } else if (tpaName.equals("Starhealth")) {
//				sheet = workbook.getSheet("Sheet_2_crosstab");
                    sheet = workbook.getSheetAt(i);
                } else if (tpaName.equals("Medseva")) {
//				sheet = workbook.getSheet("total claims dump");
                    sheet = workbook.getSheetAt(i);
                } else if (tpaName.equals("FHPL")) {
//                sheet = workbook.getSheet("Claims&Preauth");
                    sheet = workbook.getSheetAt(i);
                } else if (tpaName.equals("MediAssist")) {
//				sheet = workbook.getSheet("RI & CL_1");
                    sheet = workbook.getSheetAt(i);
                } else if (tpaName.equals("GHPL")) {
//                sheet = workbook.getSheet("Data");
                    sheet = workbook.getSheetAt(i);
                } else if (tpaName.equals("ICICI")) {
//                sheet = workbook.getSheet("Sheet1");
                    sheet = workbook.getSheetAt(i);
                } else if (tpaName.equals("MD India")) {
//				sheet = workbook.getSheet("Claims Paid");
                    sheet = workbook.getSheetAt(i);
                } else if (tpaName.equals("R-Care")) {
                    sheet = workbook.getSheetAt(i);
                    // sheetAL = workbook.getSheet("AL");
//                sheet = workbook.getSheetAt(0);
                } else {
                    sheet = workbook.getSheetAt(i);
                }
                if (sheet == null) {
                    sheet = workbook.getSheetAt(i);
                }

                validateBasedOnSheet(sheet, tpaName, claimsMisValidateData);
            }
        } catch (EncryptedDocumentException | IOException | IllegalArgumentException e) {
            e.printStackTrace();
        }
        return claimsMisValidateData;

    }


    public byte[] generateExcelFromData(Long clientListId, Long productId) {
        List<ClientDetailsClaimsMis> insurerBankDetails = clientDetailsClaimsMisRepository.findAll().
                stream().filter(filter -> filter.getRecordStatus().equalsIgnoreCase("ACTIVE"))
                .filter(client -> clientListId != null && client.getClientList().getCid()
                        == clientListId)
                .filter(c -> productId != null && c.getProduct().getProductId().equals(productId)).toList();
        log.info("Service     : " +clientListId + " -----------" + productId);


        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("ClientDetailsClaimsMIs");

            String[] headers = { "Claims ID",
                    "Claim Status",
                    "Claim Type",
                    "Claims Number",
                    "Claimed Amount",
                    "Age",
                    "Disease",
                    "Date of Claim",
                    "Admission Date",
                    "Date of Discharge",
                    "Sum Insured",
                    "Relationship",
                    "Policy Start Date",
                    "Policy End Date",
                    "Patient Name",
                    "Record Status",
                    "Outstanding Amount",
                    "Hospital State",
                    "Hospital City",
                    "Gender",
                    "Network Type",
                    "Employee ID",
                    "Employee Name",
                    "Paid Amount"};
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                headerRow.createCell(i).setCellValue(headers[i]);
            }

            int rowNum = 1;
            for (ClientDetailsClaimsMis cpfc : insurerBankDetails) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(cpfc.getClaimsId());
                row.createCell(1).setCellValue(cpfc.getClaimStatus());
                row.createCell(2).setCellValue(cpfc.getClaimType());
                row.createCell(3).setCellValue(cpfc.getClaimsNumber());
                row.createCell(4).setCellValue(cpfc.getClaimedAmount());
                row.createCell(5).setCellValue(cpfc.getAge());
                row.createCell(6).setCellValue(cpfc.getDisease());
                row.createCell(7).setCellValue(cpfc.getDateOfClaim());
                row.createCell(8).setCellValue(cpfc.getAdmissionDate());
                row.createCell(9).setCellValue(cpfc.getDateOfDischarge());
                row.createCell(10).setCellValue(cpfc.getSumInsured());
                row.createCell(11).setCellValue(cpfc.getRelationship());
                row.createCell(12).setCellValue(cpfc.getPolicyStartDate());
                row.createCell(13).setCellValue(cpfc.getPolicyEndDate());
                row.createCell(14).setCellValue(cpfc.getPatientName());
                row.createCell(15).setCellValue(cpfc.getRecordStatus());
                row.createCell(16).setCellValue(cpfc.getOutstandingAmount());
                row.createCell(17).setCellValue(cpfc.getHospitalState());
                row.createCell(18).setCellValue(cpfc.getHospitalCity());
                row.createCell(19).setCellValue(cpfc.getGender());
                row.createCell(20).setCellValue(cpfc.getNetworkType());
                row.createCell(21).setCellValue(cpfc.getEmployeeId());
                row.createCell(22).setCellValue(cpfc.getEmployeeName());
                row.createCell(23).setCellValue(cpfc.getPaidAmount());


            }

            workbook.write(out);
            return out.toByteArray();
        } catch (IOException e) {
            e.printStackTrace();
            return new byte[0];
        }
    }


    @Override
    public List<ClaimsMisNewDto> getAllClaimsMisByRfqId( Long clientlistId, Long productId) {

        return clientDetailsClaimsMisRepository.findAll()
                .stream()
                .filter(i -> i.getRecordStatus().equalsIgnoreCase("ACTIVE"))
                .filter(i -> clientlistId != 0 &&  i.getClientList()!=null
                        && i.getClientList().getCid() == (clientlistId))
                .filter(i -> productId != 0 && i.getProduct()!=null
                        && i.getProduct().getProductId().equals(productId))
               // .filter(i -> i.getRfqId().equals(rfqId))
                .map(c->{

                    ClaimsMisNewDto claimsMisDto = new ClaimsMisNewDto();
                    claimsMisDto.setPolicyNumber(c.getPolicyNumber());
                    claimsMisDto.setClaimsNumber(c.getClaimsNumber());
                    claimsMisDto.setEmployeeId(c.getEmployeeId());
                    claimsMisDto.setEmployeeName(c.getEmployeeName());
                    claimsMisDto.setRelationship(c.getRelationship());
                    claimsMisDto.setGender(c.getGender());
                    claimsMisDto.setAge(c.getAge());
                    claimsMisDto.setSumInsured(c.getSumInsured());
                    claimsMisDto.setClaimedAmount(c.getClaimedAmount());
                    claimsMisDto.setPaidAmount(c.getPaidAmount());
                    claimsMisDto.setDateOfClaim(c.getDateOfClaim());
                    claimsMisDto.setAdmissionDate(c.getAdmissionDate());
                    claimsMisDto.setDisease(c.getDisease());
                    claimsMisDto.setNetworkType(c.getNetworkType());
                    claimsMisDto.setOutstandingAmount(c.getOutstandingAmount());
                    claimsMisDto.setHospitalName(c.getHospitalName());
                    claimsMisDto.setHospitalCity(c.getHospitalCity());

                    return claimsMisDto;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<Object[]> getRfqCounts() {
        List<Object[]> statusCount = claimsMisRepo.statusCount();
        return statusCount;
    }

    public ClaimsUploadDto getClaimsAferUpload(String rfqId) {
        List<ClientDetailsClaimsMis> detailsAfterUpload = clientDetailsClaimsMisRepository.getClaimsDetailsAfterUpload(rfqId);

        if (!detailsAfterUpload.isEmpty()) {
            ClientDetailsClaimsMis firstEntity = detailsAfterUpload.get(0); // Get the first element
            ClaimsUploadDto firstDto = new ClaimsUploadDto();

            if (firstEntity.getPolicyNumber() != null) {
                firstDto.setPolicyNumber(firstEntity.getPolicyNumber());
            } else {
                firstDto.setPolicyNumber(null);
            }

            if (firstEntity.getAdmissionDate() != null) {
                firstDto.setStartDate(String.valueOf(firstEntity.getAdmissionDate()));
            } else {
                firstDto.setStartDate(null);
            }

            if (firstEntity.getDateOfDischarge() != null) {
                firstDto.setEndDate(String.valueOf(firstEntity.getDateOfDischarge()));
            } else {
                firstDto.setEndDate(null);
            }

            return firstDto;
        } else {
            return null; // List is empty, return null
        }
    }


    @Override
    public ClaimsDumpDto getClaimsDump(String rfqId) {

        List<ClientDetailsClaimsMis> claimsDump = clientDetailsClaimsMisRepository.findByRfqId(rfqId);

        List<String> settled = Arrays.asList("Settled", "APPROVED AND PAID", "APPROVED", "Claim Paid", "Paid");
        List<String> lowerSettled = settled.stream().map(String::toLowerCase).collect(Collectors.toList());

        List<String> underProcessing = Arrays.asList("Under Process", "Underprocess", "Under Query", "Cheque Pending",
                "Intimation received", "Claim Bills Pending", "Deficiency", "OUTSTANDING", "Claim document awaited",
                "Pending claim adjudication", "Processed ready for payment",
                "Information / query pending from hospital - FINAL", "Pending for data entry", "Query", "In Process",
                "PreAuth Issued", "Intimation Registered", "Pending", "Approved (Enhancement)", "Approved (Pre Auth)",
                "SHORTFALL", "BILLS PENDING", "CHEQUE PENDING");
        List<String> lowerUnderProcessing = underProcessing.stream().map(String::toLowerCase)
                .collect(Collectors.toList());

        List<String> cashLess = Arrays.asList("Cashless");
        List<String> lowerCashLess = cashLess.stream().map(String::toLowerCase).collect(Collectors.toList());

        List<String> reimbursement = Arrays.asList("Reimbursement", "Member");
        List<String> lowerReimbursement = reimbursement.stream().map(String::toLowerCase).collect(Collectors.toList());

//  claims paid settled and Reimbursement
        double reimbursementPaidTotal = claimsDump.parallelStream()
                .filter(claim -> lowerSettled.contains(claim.getClaimStatus().toLowerCase())
                        && lowerReimbursement.contains(claim.getClaimType().toLowerCase()))
                .mapToDouble(ClientDetailsClaimsMis::getPaidAmount).sum();

//  claims paid settled and Cashless
        double cashLessPaidTotal = claimsDump.parallelStream()
                .filter(claim -> lowerSettled.contains(claim.getClaimStatus().toLowerCase())
                        && lowerCashLess.contains(claim.getClaimType().toLowerCase()))
                .mapToDouble(ClientDetailsClaimsMis::getPaidAmount).sum();

//  OutStanding Under process and Cashless
        double cashLessOutStandingTotal = claimsDump.parallelStream()
                .filter(claim -> lowerUnderProcessing.contains(claim.getClaimStatus().toLowerCase())
                        && lowerCashLess.contains(claim.getClaimType().toLowerCase()))
                .mapToDouble(ClientDetailsClaimsMis::getPaidAmount).sum();

//  OutStanding Under process and Reimbursement
        double reimbursementOutStandingTotal = claimsDump.parallelStream()
                .filter(claim -> lowerUnderProcessing.contains(claim.getClaimStatus().toLowerCase())
                        && lowerReimbursement.contains(claim.getClaimType().toLowerCase()))
                .mapToDouble(ClientDetailsClaimsMis::getPaidAmount).sum();

        ClaimsDumpDto claimsDumpDto = ClaimsDumpDto.builder().claimPaidReimbursement(reimbursementPaidTotal)
                .claimsPaidCashless(cashLessPaidTotal).claimsOutStandingReimbursement(reimbursementOutStandingTotal)
                .claimsOutStandingCashless(cashLessOutStandingTotal).build();

        return claimsDumpDto;
    }


    @Override
    public Map<String, Long> getStatusCounts(String rfqId) {
        String[] approvedStatuses = {"Claim Paid", "SETTLED"};
        String[] rejectedStatuses = {"Claim Repudiated", "REPUDIATED"};
        String[] pendingStatuses = {"Repudiated - awaiting insurer concurrence", "OUTSTANDING"};

        return clientDetailsClaimsMisRepository.findByRfqId(rfqId).stream()
                .map(c -> {
                    // Map "SETTLED" to "Claim Paid"
                    if (c.getClaimStatus().equalsIgnoreCase("SETTLED")) {
                        c.setClaimStatus("Claim Paid");
                    }
                    // Map "REPUDIATED" to "Claim Repudiated"
                    if (c.getClaimStatus().equalsIgnoreCase("REPUDIATED")) {
                        c.setClaimStatus("Claim Repudiated");
                    }
                    // Map "OUTSTANDING" to "Repudiated - awaiting insurer concurrence"
                    if (c.getClaimStatus().equalsIgnoreCase("OUTSTANDING")) {
                        c.setClaimStatus("Repudiated - awaiting insurer concurrence");
                    }
                    return c;
                })
                .filter(c -> Arrays.asList(approvedStatuses).contains(c.getClaimStatus()) ||
                        Arrays.asList(rejectedStatuses).contains(c.getClaimStatus()) ||
                        Arrays.asList(pendingStatuses).contains(c.getClaimStatus()))
                .collect(Collectors.groupingBy(
                        // Map key to "approved", "Rejected", or "outstanding" based on claim status
                        c -> {
                            if (Arrays.asList(approvedStatuses).contains(c.getClaimStatus())) {
                                return "approved";
                            } else if (Arrays.asList(rejectedStatuses).contains(c.getClaimStatus())) {
                                return "Rejected";
                            } else {
                                return "outstanding";
                            }
                        },
                        Collectors.counting()));
    }

    @Override
    public List<ClaimsMisNewDto> getDataWithStatus(String rfqId) {
        String approved = "SETTLED";
        String rejected = "CLOSED";
        String pending = "OUTSTANDING";
        return clientDetailsClaimsMisRepository.findByRfqId(rfqId).stream().filter(c -> c.getClaimStatus().equalsIgnoreCase(approved) ||
                        c.getClaimStatus().equalsIgnoreCase(rejected) ||
                        c.getClaimStatus().equalsIgnoreCase(pending))
                .map(c -> {
                    ClaimsMisNewDto claimsMisDto = new ClaimsMisNewDto();
                    claimsMisDto.setPolicyNumber(c.getPolicyNumber());
                    claimsMisDto.setClaimsNumber(c.getClaimsNumber());
                    claimsMisDto.setEmployeeId(c.getEmployeeId());
                    claimsMisDto.setEmployeeName(c.getEmployeeName());
                    claimsMisDto.setRelationship(c.getRelationship());
                    claimsMisDto.setGender(c.getGender());
                    claimsMisDto.setAge(c.getAge());
                    claimsMisDto.setSumInsured(c.getSumInsured());
                    claimsMisDto.setClaimedAmount(c.getClaimedAmount());
                    claimsMisDto.setPaidAmount(c.getPaidAmount());
                    claimsMisDto.setDateOfClaim(c.getDateOfClaim());
                    claimsMisDto.setAdmissionDate(c.getAdmissionDate());
                    claimsMisDto.setDisease(c.getDisease());
                    claimsMisDto.setNetworkType(c.getNetworkType());
                    claimsMisDto.setOutstandingAmount(c.getOutstandingAmount());
                    claimsMisDto.setHospitalName(c.getHospitalName());
                    claimsMisDto.setHospitalCity(c.getHospitalCity());
                    if (c.getClaimStatus().equalsIgnoreCase(approved)) {
                        claimsMisDto.setClaimStatus("Settled");
                    } else if (c.getClaimStatus().equalsIgnoreCase(rejected)) {
                        claimsMisDto.setClaimStatus("CLOSED");
                    } else if (c.getClaimStatus().equalsIgnoreCase(pending)) {
                        claimsMisDto.setClaimStatus("OUTSTANDING");
                    }


                    return claimsMisDto;
                }).collect(Collectors.toList());

    }

    public void validateBasedOnSheet(Sheet sheet, String tpaName,
                                     List<ClaimsMisDataStatusValidateDto> claimsMisValidateData) {

        Iterator<Row> rowIterator = sheet.iterator();

        // Assuming the first row contains the column names
        Row headerRow = rowIterator.next();
        int snoColumnIndex = -1;
        int policyNumberColumnIndex = -1;
        int claimsNumberColumnIndex = -1;
        int employeeIdColumnIndex = -1;
        int employeeNameColumnIndex = -1;
        int relationshipColumnIndex = -1;
        int genderColumnIndex = -1;
        int ageColumnIndex = -1;
        int patientNameColumnIndex = -1;
        int sumInsuredColumnIndex = -1;
        int claimedAmountColumnIndex = -1;
        int paidAmountColumnIndex = -1;
        int outstandingAmountColumnIndex = -1;
        int claimStatusColumnIndex = -1;
        int dateOfClaimColumnIndex = -1;
        int claimTypeColumnIndex = -1;
        int networkTypeColumnIndex = -1;
        int hospitalNameColumnIndex = -1;
        int admissionDateColumnIndex = -1;
        int dischargeDateColumnIndex = -1;
        int diseaseColumnIndex = -1;
        int memberCodeColumnIndex = -1;
        int policyStartDateColumnIndex = -1;
        int policyEndDateColumnIndex = -1;
        int hospitalStateColumnIndex = -1;
        int hospitalCityColumnIndex = -1;

        boolean snoColumnIndexFlag = false;
        boolean policyNumberColumnIndexFlag = false;
        boolean claimsNumberColumnIndexFlag = false;
        boolean employeeIdColumnIndexFlag = false;
        boolean employeeNameColumnIndexFlag = false;
        boolean relationshipColumnIndexFlag = false;
        boolean genderColumnIndexFlag = false;
        boolean ageColumnIndexFlag = false;
        boolean patientNameColumnIndexFlag = false;
        boolean sumInsuredColumnIndexFlag = false;
        boolean claimedAmountColumnIndexFlag = false;
        boolean paidAmountColumnIndexFlag = false;
        boolean outstandingColumnIndexFlag = false;
        boolean claimStatusColumnIndexFlag = false;
        boolean dateOfClaimColumnIndexFlag = false;
        boolean claimTypeColumnIndexFlag = false;
        boolean networkTypeColumnIndexFlag = false;
        boolean hospitalNameColumnIndexFlag = false;
        boolean admissionDateColumnIndexFlag = false;
        boolean dischargeDateColumnIndexFlag = false;
        boolean diseaseColumnIndexFlag = false;
        boolean memberCodeColumnIndexFlag = false;
        boolean policyStartDateColumnIndexFlag = false;
        boolean policyEndDateColumnIndexFlag = false;
        boolean hospitalStateColumnIndexFlag = false;
        boolean hospitalCityColumnIndexFlag = false;

        Tpa tpa_data = tpaRepo.findByTpaName(tpaName);
        List<ClaimsTPAHeaders> tpaHeadersBasedOnTPA = tpa_data.getTpaHeaders();

        Iterator<Cell> cellIterator = headerRow.cellIterator();
        int columnIndex = 0;
        while (cellIterator.hasNext()) {

//			System.out.println("tpaHeadersBasedOnTPA : " + tpaHeadersBasedOnTPA.size());
            Cell cell = cellIterator.next();
            String columnName = cell.getStringCellValue().trim();

            for (ClaimsTPAHeaders i : tpaHeadersBasedOnTPA) {
//				System.out.println("columnName : " + columnName);
//				System.out.println("HeaderName : " + i.getHeaderName());
                if (columnName.trim().equals(i.getHeaderName().trim()) && i.getHeaderAliasName().trim().equals("SNO")) {
                    snoColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Policy Number")) {
                    policyNumberColumnIndex = columnIndex;
                    System.out.println("policyNumberColumnIndex : " + policyNumberColumnIndex);
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Claim Number")) {
                    claimsNumberColumnIndex = columnIndex;
                    System.out.println("claimsNumberColumnIndex : " + claimsNumberColumnIndex);
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Employee Id")) {
                    System.out.println("employeeIdColumnIndex : " + employeeIdColumnIndex);
                    employeeIdColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Employee Name")) {
                    employeeNameColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Gender")) {
                    genderColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("RelationShip")) {
                    relationshipColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Age")) {
                    ageColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Patient Name")) {
                    System.out.println("patientNameColumnIndex : " + patientNameColumnIndex);
                    patientNameColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Sum Insured")) {
                    sumInsuredColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Claimed Amount")) {
                    claimedAmountColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Paid Amount")) {
                    System.out.println("paidAmountColumnIndex : " + columnIndex);
                    paidAmountColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Outstanding Amount")) {
                    outstandingAmountColumnIndex = columnIndex;
                    System.out.println("outStandingAmount :" + outstandingAmountColumnIndex);
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Claim Status")) {
                    claimStatusColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Date Of Claim")) {
                    dateOfClaimColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Hospital Name")) {
                    hospitalNameColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Network Type")) {
                    networkTypeColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Claim Type")) {
                    claimTypeColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Admission Date")) {
                    admissionDateColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Disease")) {
                    diseaseColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Date of Discharge")) {
                    dischargeDateColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Member Code")) {
                    memberCodeColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Policy Start Date")) {
                    policyStartDateColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Policy End Date")) {
                    policyEndDateColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Hospital State")) {
                    hospitalStateColumnIndex = columnIndex;
                } else if (columnName.trim().equals(i.getHeaderName().trim())
                        && i.getHeaderAliasName().trim().equals("Hospital City")) {
                    hospitalCityColumnIndex = columnIndex;
                }
            }
            columnIndex++;
        }

        // while loop used to handle any cell having null value,not to throw
        // NullPointerException
        while (rowIterator.hasNext()) {
            Row dataRow = rowIterator.next();
            if (policyNumberColumnIndex >= 0 && claimsNumberColumnIndex >= 0 && employeeIdColumnIndex >= 0
                    && employeeNameColumnIndex >= 0 && relationshipColumnIndex >= 0 && genderColumnIndex >= 0
                    && ageColumnIndex >= 0 && patientNameColumnIndex >= 0 && sumInsuredColumnIndex >= 0
                    && claimedAmountColumnIndex >= 0 && paidAmountColumnIndex >= 0 && claimTypeColumnIndex >= 0
                    && outstandingAmountColumnIndex >= 0 && claimStatusColumnIndex >= 0 && dateOfClaimColumnIndex >= 0
                    && networkTypeColumnIndex >= 0 && hospitalNameColumnIndex >= 0 && admissionDateColumnIndex >= 0
                    && diseaseColumnIndex >= 0 && dischargeDateColumnIndex >= 0 && memberCodeColumnIndex >= 0
                    && policyStartDateColumnIndex >= 0 && policyEndDateColumnIndex >= 0 && hospitalStateColumnIndex >= 0
                    && hospitalCityColumnIndex >= 0) {
                if (dataRow.getCell(policyNumberColumnIndex) != null && dataRow.getCell(claimsNumberColumnIndex) != null
                        && dataRow.getCell(employeeIdColumnIndex) != null
                        && dataRow.getCell(employeeNameColumnIndex) != null
                        && dataRow.getCell(relationshipColumnIndex) != null
                        && dataRow.getCell(genderColumnIndex) != null && dataRow.getCell(ageColumnIndex) != null
                        && dataRow.getCell(patientNameColumnIndex) != null
                        && dataRow.getCell(sumInsuredColumnIndex) != null
                        && dataRow.getCell(claimedAmountColumnIndex) != null
                        && dataRow.getCell(paidAmountColumnIndex) != null
                        && dataRow.getCell(outstandingAmountColumnIndex) != null
                        && dataRow.getCell(claimStatusColumnIndex) != null
                        && dataRow.getCell(dateOfClaimColumnIndex) != null
                        && dataRow.getCell(claimTypeColumnIndex) != null
                        && dataRow.getCell(networkTypeColumnIndex) != null
                        && dataRow.getCell(hospitalNameColumnIndex) != null
                        && dataRow.getCell(admissionDateColumnIndex) != null
                        && dataRow.getCell(dischargeDateColumnIndex) != null
                        && dataRow.getCell(diseaseColumnIndex) != null && dataRow.getCell(memberCodeColumnIndex) != null
                        && dataRow.getCell(policyStartDateColumnIndex) != null
                        && dataRow.getCell(policyEndDateColumnIndex) != null
                        && dataRow.getCell(hospitalStateColumnIndex) != null
                        && dataRow.getCell(hospitalCityColumnIndex) != null) {
                    if (dataRow.getCell(policyNumberColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(claimsNumberColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(employeeIdColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(employeeNameColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(relationshipColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(genderColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(ageColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(patientNameColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(sumInsuredColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(claimedAmountColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(paidAmountColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(outstandingAmountColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(claimStatusColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(dateOfClaimColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(claimTypeColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(networkTypeColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(hospitalNameColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(admissionDateColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(dischargeDateColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(diseaseColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(memberCodeColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(policyStartDateColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(policyEndDateColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(hospitalStateColumnIndex).getCellType() == CellType.BLANK
                            && dataRow.getCell(hospitalCityColumnIndex).getCellType() == CellType.BLANK) {
                        continue;
                    }
                }

            }

            String remarks;

            int policyNumberInteger, claimsNumberInteger, employeeIdInteger, memberCodeInteger;
            ClaimsMisDataStatusValidateDto validateDto = new ClaimsMisDataStatusValidateDto();
            if (dataRow.getCell(policyNumberColumnIndex) != null) {
                Cell policyNumberCell = dataRow.getCell(policyNumberColumnIndex);
                if (policyNumberCell.getCellType() == CellType.NUMERIC) {
                    policyNumberInteger = (int) policyNumberCell.getNumericCellValue();
                    validateDto.setPolicyNumber(String.valueOf(policyNumberInteger).trim());
                    validateDto.setPolicyNumberStatus(true);
                } else if (policyNumberCell.getCellType() == CellType.STRING) {
                    String policyNumber = policyNumberCell.getStringCellValue().trim();
                    validateDto.setPolicyNumber(policyNumber);
                    validateDto.setPolicyNumberStatus(true);
                } else if (policyNumberCell.getCellType() == CellType._NONE) {
                    policyNumberColumnIndexFlag = true;
                    validateDto.setPolicyNumberStatus(false);
                    validateDto.setPolicyNumberErrorMessage("Policy Number None :: ");
                    remarks = "No Policy Number";
                } else if (policyNumberCell.getCellType() == CellType.BLANK) {
                    policyNumberColumnIndexFlag = true;
                    validateDto.setPolicyNumberStatus(false);
                    validateDto.setPolicyNumberErrorMessage("Policy Number Blank :: ");
                    remarks = "Blank Policy Number";
                } else if (policyNumberCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = policyNumberCell.getErrorCellValue();
                    validateDto.setPolicyNumber(String.valueOf(errorCellValue).trim());
                    validateDto.setPolicyNumberStatus(false);
                    validateDto.setPolicyNumberErrorMessage("Policy Number Error :: ");
                    remarks = "Error Policy Number";
                } else if (policyNumberCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = policyNumberCell.getBooleanCellValue();
                    validateDto.setPolicyNumber(String.valueOf(booleanCellValue).trim());
                    validateDto.setPolicyNumberStatus(false);
                    validateDto.setPolicyNumberErrorMessage("Policy Number Boolean :: ");
                } else if (policyNumberCell.getCellType() == CellType.FORMULA) {
                    switch (policyNumberCell.getCellType()) {
                        case NUMERIC: {
                            policyNumberInteger = (int) policyNumberCell.getNumericCellValue();
                            validateDto.setPolicyNumber(String.valueOf(policyNumberInteger).trim());
                            validateDto.setPolicyNumberStatus(true);
                            break;
                        }
                        case STRING: {
                            String policyNumber = policyNumberCell.getStringCellValue().trim();
                            validateDto.setPolicyNumber(policyNumber);
                            validateDto.setPolicyNumberStatus(true);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = policyNumberCell.getBooleanCellValue();
                            validateDto.setPolicyNumber(String.valueOf(booleanCellValue).trim());
                            validateDto.setPolicyNumberStatus(false);
                            validateDto.setPolicyNumberErrorMessage("Policy Number Boolean :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = policyNumberCell.getErrorCellValue();
                            validateDto.setPolicyNumber(String.valueOf(errorCellValue).trim());
                            validateDto.setPolicyNumberStatus(false);
                            validateDto.setPolicyNumberErrorMessage("Policy Number Error :: ");
                            remarks = "Error Policy Number";
                            break;
                        }
                        case _NONE: {
                            policyNumberColumnIndexFlag = true;
                            validateDto.setPolicyNumberStatus(false);
                            validateDto.setPolicyNumberErrorMessage("Policy Number None :: ");
                            remarks = "No Policy Number";
                            break;
                        }
                        case BLANK: {
                            policyNumberColumnIndexFlag = true;
                            validateDto.setPolicyNumberStatus(false);
                            validateDto.setPolicyNumberErrorMessage("Policy Number Blank :: ");
                            remarks = "Blank Policy Number";
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + policyNumberCell.getCachedFormulaResultType());
                    }
                }
            }

            if (dataRow.getCell(claimsNumberColumnIndex) != null) {
                Cell claimsNumberCell = dataRow.getCell(claimsNumberColumnIndex);
                if (claimsNumberCell.getCellType() == CellType.NUMERIC) {
                    claimsNumberInteger = (int) claimsNumberCell.getNumericCellValue();
                    validateDto.setClaimsNumber(String.valueOf(claimsNumberInteger).trim());
                    validateDto.setClaimsNumberStatus(true);
                } else if (claimsNumberCell.getCellType() == CellType.STRING) {
                    String claimsNumber = claimsNumberCell.getStringCellValue().trim();
                    validateDto.setClaimsNumber(claimsNumber);
                    validateDto.setClaimsNumberStatus(true);
                } else if (claimsNumberCell.getCellType() == CellType._NONE) {
                    claimsNumberColumnIndexFlag = true;
                    validateDto.setClaimsNumberStatus(false);
                    validateDto.setClaimsNumberErrorMessage("Claims Number None :: ");
                } else if (claimsNumberCell.getCellType() == CellType.BLANK) {
                    claimsNumberColumnIndexFlag = true;
                    validateDto.setClaimsNumberStatus(false);
                    validateDto.setClaimsNumberErrorMessage("Claims Number Blank :: ");
                } else if (claimsNumberCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = claimsNumberCell.getErrorCellValue();
                    validateDto.setClaimsNumber(String.valueOf(errorCellValue).trim());
                    validateDto.setClaimsNumberStatus(false);
                    validateDto.setClaimsNumberErrorMessage("Claims Number Error :: ");
                } else if (claimsNumberCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = claimsNumberCell.getBooleanCellValue();
                    validateDto.setClaimsNumber(String.valueOf(booleanCellValue).trim());
                    validateDto.setClaimsNumberStatus(false);
                    validateDto.setClaimsNumberErrorMessage("Claims Number Boolean :: ");
                } else if (claimsNumberCell.getCellType() == CellType.FORMULA) {
                    switch (claimsNumberCell.getCellType()) {
                        case NUMERIC: {
                            claimsNumberInteger = (int) claimsNumberCell.getNumericCellValue();
                            validateDto.setClaimsNumber(String.valueOf(claimsNumberInteger).trim());
                            validateDto.setClaimsNumberStatus(true);
                            break;
                        }
                        case STRING: {
                            String claimsNumber = claimsNumberCell.getStringCellValue().trim();
                            validateDto.setClaimsNumber(claimsNumber);
                            validateDto.setClaimsNumberStatus(true);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = claimsNumberCell.getBooleanCellValue();
                            validateDto.setClaimsNumber(String.valueOf(booleanCellValue).trim());
                            validateDto.setClaimsNumberStatus(false);
                            validateDto.setClaimsNumberErrorMessage("Claims Number Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = claimsNumberCell.getErrorCellValue();
                            validateDto.setClaimsNumber(String.valueOf(errorCellValue).trim());
                            validateDto.setClaimsNumberStatus(false);
                            validateDto.setClaimsNumberErrorMessage("Claims Number Error Formula :: ");
                            break;
                        }
                        case _NONE: {
                            claimsNumberColumnIndexFlag = true;
                            validateDto.setClaimsNumberStatus(false);
                            validateDto.setClaimsNumberErrorMessage("Claims Number None Formula :: ");
                            break;
                        }
                        case BLANK: {
                            claimsNumberColumnIndexFlag = true;
                            validateDto.setClaimsNumberStatus(false);
                            validateDto.setClaimsNumberErrorMessage("Claims Number Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + claimsNumberCell.getCachedFormulaResultType());
                    }
                }
            }

            if (dataRow.getCell(employeeIdColumnIndex) != null) {
                Cell employeeIdCell = dataRow.getCell(employeeIdColumnIndex);
                if (employeeIdCell.getCellType() == CellType.NUMERIC) {
                    employeeIdInteger = (int) employeeIdCell.getNumericCellValue();
                    validateDto.setEmployeeId(String.valueOf(employeeIdInteger).trim());
                    validateDto.setEmployeeIdStatus(true);
                } else if (employeeIdCell.getCellType() == CellType.STRING) {
                    String employeeId = employeeIdCell.getStringCellValue().trim();
                    validateDto.setEmployeeId(employeeId);
                    validateDto.setEmployeeIdStatus(true);
                } else if (employeeIdCell.getCellType() == CellType._NONE) {
                    employeeIdColumnIndexFlag = true;
                    validateDto.setEmployeeIdStatus(false);
                    validateDto.setEmployeeIdErrorMessage("Employee Id None :: ");
                } else if (employeeIdCell.getCellType() == CellType.BLANK) {
                    employeeIdColumnIndexFlag = true;
                    validateDto.setEmployeeIdStatus(false);
                    validateDto.setEmployeeIdErrorMessage("Employee Id Blank :: ");
                } else if (employeeIdCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = employeeIdCell.getErrorCellValue();
                    validateDto.setEmployeeId(String.valueOf(errorCellValue).trim());
                    validateDto.setEmployeeIdStatus(false);
                    validateDto.setEmployeeIdErrorMessage("Employee Id Error :: ");
                } else if (employeeIdCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = employeeIdCell.getBooleanCellValue();
                    validateDto.setEmployeeId(String.valueOf(booleanCellValue).trim());
                    validateDto.setEmployeeIdStatus(false);
                    validateDto.setEmployeeIdErrorMessage("Employee Id Boolean :: ");
                } else if (employeeIdCell.getCellType() == CellType.FORMULA) {
                    switch (employeeIdCell.getCellType()) {
                        case NUMERIC: {
                            employeeIdInteger = (int) employeeIdCell.getNumericCellValue();
                            validateDto.setEmployeeId(String.valueOf(employeeIdInteger).trim());
                            validateDto.setEmployeeIdStatus(true);
                            break;
                        }
                        case STRING: {
                            String employeeId = employeeIdCell.getStringCellValue().trim();
                            validateDto.setEmployeeId(employeeId);
                            validateDto.setEmployeeIdStatus(true);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = employeeIdCell.getBooleanCellValue();
                            validateDto.setEmployeeId(String.valueOf(booleanCellValue).trim());
                            validateDto.setEmployeeIdStatus(false);
                            validateDto.setEmployeeIdErrorMessage("Employee Id Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = employeeIdCell.getErrorCellValue();
                            validateDto.setEmployeeId(String.valueOf(errorCellValue).trim());
                            validateDto.setEmployeeIdStatus(false);
                            validateDto.setEmployeeIdErrorMessage("Employee Id Error Formula :: ");
                            break;
                        }
                        case _NONE: {
                            employeeIdColumnIndexFlag = true;
                            validateDto.setEmployeeIdStatus(false);
                            validateDto.setEmployeeIdErrorMessage("Employee Id None Formula :: ");
                            break;
                        }
                        case BLANK: {
                            employeeIdColumnIndexFlag = true;
                            validateDto.setEmployeeIdStatus(false);
                            validateDto.setEmployeeIdErrorMessage("Employee Id Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + employeeIdCell.getCachedFormulaResultType());
                    }
                }
            }

            if (dataRow.getCell(memberCodeColumnIndex) != null) {
                Cell memberCodeCell = dataRow.getCell(memberCodeColumnIndex);
                if (memberCodeCell.getCellType() == CellType.NUMERIC) {
                    memberCodeInteger = (int) memberCodeCell.getNumericCellValue();
                    validateDto.setMemberCode(String.valueOf(memberCodeInteger).trim());
                    validateDto.setMemberCodeStatus(true);
                } else if (memberCodeCell.getCellType() == CellType.STRING) {
                    String memberCode = memberCodeCell.getStringCellValue().trim();
                    validateDto.setMemberCode(memberCode);
                    validateDto.setMemberCodeStatus(true);
                } else if (memberCodeCell.getCellType() == CellType._NONE) {
                    memberCodeColumnIndexFlag = true;
                    validateDto.setMemberCodeStatus(false);
                    validateDto.setMemberCodeErrorMessage("Member Code None :: ");
                } else if (memberCodeCell.getCellType() == CellType.BLANK) {
                    memberCodeColumnIndexFlag = true;
                    validateDto.setMemberCodeStatus(false);
                    validateDto.setMemberCodeErrorMessage("Member Code Blank :: ");
                } else if (memberCodeCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = memberCodeCell.getErrorCellValue();
                    validateDto.setMemberCode(String.valueOf(errorCellValue).trim());
                    validateDto.setMemberCodeStatus(false);
                    validateDto.setMemberCodeErrorMessage("Member Code Error :: ");
                } else if (memberCodeCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = memberCodeCell.getBooleanCellValue();
                    validateDto.setMemberCode(String.valueOf(booleanCellValue).trim());
                    validateDto.setMemberCodeStatus(false);
                    validateDto.setMemberCodeErrorMessage("Member Code Boolean :: ");
                } else if (memberCodeCell.getCellType() == CellType.FORMULA) {
                    switch (memberCodeCell.getCellType()) {
                        case NUMERIC: {
                            memberCodeInteger = (int) memberCodeCell.getNumericCellValue();
                            validateDto.setMemberCode(String.valueOf(memberCodeInteger).trim());
                            validateDto.setMemberCodeStatus(true);
                            break;
                        }
                        case STRING: {
                            String memberCode = memberCodeCell.getStringCellValue().trim();
                            validateDto.setMemberCode(memberCode);
                            validateDto.setMemberCodeStatus(true);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = memberCodeCell.getBooleanCellValue();
                            validateDto.setMemberCode(String.valueOf(booleanCellValue).trim());
                            validateDto.setMemberCodeStatus(false);
                            validateDto.setMemberCodeErrorMessage("Member Code Boolean :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = memberCodeCell.getErrorCellValue();
                            validateDto.setMemberCode(String.valueOf(errorCellValue).trim());
                            validateDto.setMemberCodeStatus(false);
                            validateDto.setMemberCodeErrorMessage("Member Code Error :: ");
                            break;
                        }
                        case _NONE: {
                            memberCodeColumnIndexFlag = true;
                            validateDto.setMemberCodeStatus(false);
                            validateDto.setMemberCodeErrorMessage("Member Code None :: ");
                            break;
                        }
                        case BLANK: {
                            memberCodeColumnIndexFlag = true;
                            validateDto.setMemberCodeStatus(false);
                            validateDto.setMemberCodeErrorMessage("Member Code Blank :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + memberCodeCell.getCachedFormulaResultType());
                    }
                }
            }

            String employeeName;
            String gender;
            String relationship;
            String patientName;
            String claimType;
            String networkType;
            String hospitalName;
            String disease;
            String hospitalState;
            String hospitalCity;

            if (dataRow.getCell(employeeNameColumnIndex) != null) {
                Cell employeeNameCell = dataRow.getCell(employeeNameColumnIndex);
                if (employeeNameCell.getCellType() == CellType.NUMERIC) {
                    employeeName = String.valueOf(employeeNameCell.getNumericCellValue()).trim();
                    validateDto.setEmployeeName(String.valueOf(employeeName));
                    validateDto.setEmployeeNameStatus(false);
                } else if (employeeNameCell.getCellType() == CellType.STRING) {
                    employeeName = employeeNameCell.getStringCellValue().trim();
                    validateDto.setEmployeeName(employeeName);
                    validateDto.setEmployeeNameStatus(true);
                } else if (employeeNameCell.getCellType() == CellType._NONE) {
                    employeeNameColumnIndexFlag = true;
                    validateDto.setEmployeeNameStatus(false);
                    validateDto.setEmployeeNameErrorMessage("Employee Name None :: ");
                } else if (employeeNameCell.getCellType() == CellType.BLANK) {
                    employeeNameColumnIndexFlag = true;
                    validateDto.setEmployeeNameStatus(false);
                    validateDto.setEmployeeNameErrorMessage("Employee Name Blank :: ");
                } else if (employeeNameCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = employeeNameCell.getErrorCellValue();
                    validateDto.setEmployeeName(String.valueOf(errorCellValue).trim());
                    validateDto.setEmployeeNameStatus(false);
                    validateDto.setEmployeeNameErrorMessage("Employee Name Error :: ");
                } else if (employeeNameCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = employeeNameCell.getBooleanCellValue();
                    validateDto.setEmployeeName(String.valueOf(booleanCellValue).trim());
                    validateDto.setEmployeeNameStatus(false);
                    validateDto.setEmployeeNameErrorMessage("Employee Name Boolean :: ");
                } else if (employeeNameCell.getCellType() == CellType.FORMULA) {
                    switch (employeeNameCell.getCellType()) {
                        case NUMERIC: {
                            employeeName = String.valueOf(employeeNameCell.getNumericCellValue()).trim();
                            validateDto.setEmployeeName(String.valueOf(employeeName));
                            validateDto.setEmployeeNameStatus(false);
                            break;
                        }
                        case STRING: {
                            employeeName = employeeNameCell.getStringCellValue().trim();
                            validateDto.setEmployeeName(employeeName);
                            validateDto.setEmployeeNameStatus(true);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = employeeNameCell.getBooleanCellValue();
                            validateDto.setEmployeeName(String.valueOf(booleanCellValue).trim());
                            validateDto.setEmployeeNameStatus(false);
                            validateDto.setEmployeeIdErrorMessage("Employee Name Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = employeeNameCell.getErrorCellValue();
                            validateDto.setEmployeeName(String.valueOf(errorCellValue).trim());
                            validateDto.setEmployeeNameStatus(false);
                            validateDto.setEmployeeIdErrorMessage("Employee Name Error Formula :: ");
                            break;
                        }
                        case _NONE: {
                            employeeNameColumnIndexFlag = true;
                            validateDto.setEmployeeNameStatus(false);
                            validateDto.setEmployeeNameErrorMessage("Employee Name None Formula :: ");
                            break;
                        }
                        case BLANK: {
                            employeeNameColumnIndexFlag = true;
                            validateDto.setEmployeeNameStatus(false);
                            validateDto.setEmployeeNameErrorMessage("Employee Name Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + employeeNameCell.getCachedFormulaResultType());
                    }
                }

            }

            if (!tpaName.equals("ICICI")) {
                String[] genderArr = {"M", "F", "Male", "Female", "Trans", "TransGender"};
                if (dataRow.getCell(genderColumnIndex) != null) {
                    Cell genderCell = dataRow.getCell(genderColumnIndex);
                    if (genderCell.getCellType() == CellType.NUMERIC) {
                        gender = String.valueOf(genderCell.getNumericCellValue()).trim();
                        validateDto.setGenderStatus(false);
                        validateDto.setGender(gender);
                    } else if (genderCell.getCellType() == CellType.STRING) {
                        gender = genderCell.getStringCellValue().trim().replaceAll("\\p{C}", "").replaceAll("\\s", "")
                                .replaceAll("[^\\p{Print}]", "").trim();
                        if (Arrays.asList(genderArr).stream().map(s -> s.toLowerCase()).toList()
                                .contains(gender.toLowerCase())) {
                            validateDto.setGenderStatus(true);
                            validateDto.setGender(gender);
                        } else {
                            validateDto.setGenderStatus(false);
                            validateDto.setGenderErrorMessage("Gender is Improper :: ");
                        }
                    } else if (genderCell.getCellType() == CellType._NONE) {
                        genderColumnIndexFlag = true;
                        validateDto.setGenderStatus(false);
                        validateDto.setGenderErrorMessage("Gender None :: ");
                    } else if (genderCell.getCellType() == CellType.BLANK) {
                        genderColumnIndexFlag = true;
                        validateDto.setGenderStatus(false);
                        validateDto.setGenderErrorMessage("Gender Blank :: ");
                    } else if (genderCell.getCellType() == CellType.ERROR) {
                        byte errorCellValue = genderCell.getErrorCellValue();
                        validateDto.setGender(String.valueOf(errorCellValue).trim());
                        validateDto.setGenderStatus(false);
                        validateDto.setGenderErrorMessage("Gender Error :: ");
                    } else if (genderCell.getCellType() == CellType.BOOLEAN) {
                        boolean booleanCellValue = genderCell.getBooleanCellValue();
                        validateDto.setGender(String.valueOf(booleanCellValue).trim());
                        validateDto.setGenderStatus(false);
                        validateDto.setGenderErrorMessage("Gender Boolean :: ");
                    } else if (genderCell.getCellType() == CellType.FORMULA) {
                        switch (genderCell.getCellType()) {
                            case NUMERIC: {
                                gender = String.valueOf(genderCell.getNumericCellValue()).trim();
                                validateDto.setGenderStatus(false);
                                validateDto.setGender(gender);
                                break;
                            }
                            case STRING: {
                                gender = genderCell.getStringCellValue().trim().replaceAll("\\p{C}", "")
                                        .replaceAll("\\s", "").replaceAll("[^\\p{Print}]", "").trim();
                                if (Arrays.asList(genderArr).stream().map(s -> s.toLowerCase()).toList()
                                        .contains(gender.toLowerCase())) {
                                    validateDto.setGenderStatus(true);
                                    validateDto.setGender(gender);
                                } else {
                                    validateDto.setGenderStatus(false);
                                    validateDto.setGenderErrorMessage("Gender is Improper :: ");
                                }
                                break;
                            }
                            case BOOLEAN: {
                                boolean booleanCellValue = genderCell.getBooleanCellValue();
                                validateDto.setGender(String.valueOf(booleanCellValue).trim());
                                validateDto.setGenderStatus(false);
                                validateDto.setGenderErrorMessage("Gender Boolean Formula :: ");
                                break;
                            }
                            case ERROR: {
                                byte errorCellValue = genderCell.getErrorCellValue();
                                validateDto.setGender(String.valueOf(errorCellValue).trim());
                                validateDto.setGenderStatus(false);
                                validateDto.setGenderErrorMessage("Gender Error Formula :: ");
                                break;
                            }
                            case _NONE: {
                                genderColumnIndexFlag = true;
                                validateDto.setGenderStatus(false);
                                validateDto.setGenderErrorMessage("Gender None Formula :: ");
                                break;
                            }
                            case BLANK: {
                                genderColumnIndexFlag = true;
                                validateDto.setGenderStatus(false);
                                validateDto.setGenderErrorMessage("Gender Blank Formula :: ");
                                break;
                            }
                            default:
                                throw new IllegalArgumentException(
                                        "Unexpected value: " + genderCell.getCachedFormulaResultType());
                        }
                    }

                }

                String ageValue;
                if (dataRow.getCell(ageColumnIndex) != null) {
                    Cell ageCell = dataRow.getCell(ageColumnIndex);
                    if (ageCell.getCellType() == CellType.NUMERIC) {
                        double numericCellValue = ageCell.getNumericCellValue();
                        DecimalFormat df = new DecimalFormat("#");
                        String stringValue = df.format(numericCellValue).trim();
//                        ageValue = String.valueOf(ageCell.getNumericCellValue());
                        validateDto.setAgeStatus(true);
                        validateDto.setAge(stringValue);
                    } else if (ageCell.getCellType() == CellType.STRING) {
                        ageValue = ageCell.getStringCellValue().trim();
                        validateDto.setAgeStatus(true);
                        validateDto.setAge(ageValue);
                    } else if (ageCell.getCellType() == CellType._NONE) {
                        ageColumnIndexFlag = true;
                        validateDto.setAgeStatus(false);
                        validateDto.setAgeErrorMessage("Age None :: ");
                    } else if (ageCell.getCellType() == CellType.BLANK) {
                        ageColumnIndexFlag = true;
                        validateDto.setAgeStatus(false);
                        validateDto.setAgeErrorMessage("Age Blank :: ");
                    } else if (ageCell.getCellType() == CellType.ERROR) {
                        byte errorCellValue = ageCell.getErrorCellValue();
                        validateDto.setAge(String.valueOf(errorCellValue).trim());
                        validateDto.setAgeStatus(false);
                        validateDto.setAgeErrorMessage("Age Error :: ");
                    } else if (ageCell.getCellType() == CellType.BOOLEAN) {
                        boolean booleanCellValue = ageCell.getBooleanCellValue();
                        validateDto.setAge(String.valueOf(booleanCellValue).trim());
                        validateDto.setAgeStatus(false);
                        validateDto.setAgeErrorMessage("Age Boolean :: ");
                    } else if (ageCell.getCellType() == CellType.FORMULA) {
                        switch (ageCell.getCellType()) {
                            case NUMERIC: {
                                ageValue = String.valueOf(ageCell.getNumericCellValue()).trim();
                                validateDto.setAgeStatus(true);
                                validateDto.setAge(ageValue);
                                break;
                            }
                            case STRING: {
                                ageValue = ageCell.getStringCellValue().trim();
                                validateDto.setAgeStatus(true);
                                validateDto.setAge(ageValue);
                                break;
                            }
                            case BOOLEAN: {
                                boolean booleanCellValue = ageCell.getBooleanCellValue();
                                validateDto.setAge(String.valueOf(booleanCellValue).trim());
                                validateDto.setAgeStatus(false);
                                validateDto.setAgeErrorMessage("Age Boolean FORMULA:: ");
                                break;
                            }
                            case ERROR: {
                                byte errorCellValue = ageCell.getErrorCellValue();
                                validateDto.setAge(String.valueOf(errorCellValue).trim());
                                validateDto.setAgeStatus(false);
                                validateDto.setAgeErrorMessage("Age Error FORMULA:: ");
                                break;
                            }
                            case _NONE: {
                                ageColumnIndexFlag = true;
                                validateDto.setAgeStatus(false);
                                validateDto.setAgeErrorMessage("Age None FORMULA:: ");
                                break;
                            }
                            case BLANK: {
                                ageColumnIndexFlag = true;
                                validateDto.setAgeStatus(false);
                                validateDto.setAgeErrorMessage("Age Blank FORMULA :: ");
                                break;
                            }
                            default:
                                throw new IllegalArgumentException(
                                        "Unexpected value: " + ageCell.getCachedFormulaResultType());
                        }
                    }
                }
            }

            if (!tpaName.equals("ICICI") || !tpaName.equals("GHPL") || !tpaName.equals("RCare")
                    || !tpaName.equals("Medseva") || !tpaName.equals("MediAssist")) {
                if (dataRow.getCell(networkTypeColumnIndex) != null) {
                    Cell networkTypeCell = dataRow.getCell(networkTypeColumnIndex);

                    if (networkTypeCell.getCellType() == CellType.NUMERIC) {
                        networkType = String.valueOf(networkTypeCell.getNumericCellValue()).trim();
                        validateDto.setNetworkTypeStatus(false);
                        validateDto.setNetworkType(networkType);
                    } else if (networkTypeCell.getCellType() == CellType.STRING) {
                        networkType = networkTypeCell.getStringCellValue().trim();
                        validateDto.setNetworkTypeStatus(true);
                        validateDto.setNetworkType(networkType);
                    } else if (networkTypeCell.getCellType() == CellType._NONE) {
//                        networkTypeColumnIndexFlag = true;
                        validateDto.setNetworkTypeStatus(true);
//                        validateDto.setNetworkTypeErrorMessage("NetworkType None :: ");
                    } else if (networkTypeCell.getCellType() == CellType.BLANK) {
//                        networkTypeColumnIndexFlag = true;
                        validateDto.setNetworkTypeStatus(true);
//                        validateDto.setNetworkTypeErrorMessage("NetworkType Blank :: ");
                    } else if (networkTypeCell.getCellType() == CellType.ERROR) {
                        byte errorCellValue = networkTypeCell.getErrorCellValue();
                        validateDto.setNetworkType(String.valueOf(errorCellValue).trim());
                        validateDto.setNetworkTypeStatus(true);
//                        validateDto.setNetworkTypeErrorMessage("NetworkType Error :: ");
                    } else if (networkTypeCell.getCellType() == CellType.BOOLEAN) {
                        boolean booleanCellValue = networkTypeCell.getBooleanCellValue();
                        validateDto.setNetworkType(String.valueOf(booleanCellValue).trim());
                        validateDto.setNetworkTypeStatus(true);
//                        validateDto.setNetworkTypeErrorMessage("NetworkType Boolean :: ");
                    } else if (networkTypeCell.getCellType() == CellType.FORMULA) {
                        switch (networkTypeCell.getCellType()) {
                            case NUMERIC: {
                                networkType = String.valueOf(networkTypeCell.getNumericCellValue()).trim();
                                validateDto.setNetworkTypeStatus(true);
                                validateDto.setNetworkType(networkType);
                                break;
                            }
                            case STRING: {
                                networkType = networkTypeCell.getStringCellValue().trim();
                                validateDto.setNetworkTypeStatus(true);
                                validateDto.setNetworkType(networkType);
                                break;
                            }
                            case BOOLEAN: {
                                boolean booleanCellValue = networkTypeCell.getBooleanCellValue();
                                validateDto.setNetworkType(String.valueOf(booleanCellValue).trim());
                                validateDto.setNetworkTypeStatus(true);
//                                validateDto.setNetworkTypeErrorMessage("NetworkType Boolean Formula :: ");
                                break;
                            }
                            case ERROR: {
                                byte errorCellValue = networkTypeCell.getErrorCellValue();
                                validateDto.setNetworkType(String.valueOf(errorCellValue).trim());
                                validateDto.setNetworkTypeStatus(true);
//                                validateDto.setNetworkTypeErrorMessage("NetworkType Error Formula :: ");
                                break;
                            }
                            case _NONE: {
//                                networkTypeColumnIndexFlag = true;
                                validateDto.setNetworkTypeStatus(true);
//                                validateDto.setNetworkTypeErrorMessage("NetworkType None Formula :: ");
                                break;
                            }
                            case BLANK: {
//                                networkTypeColumnIndexFlag = true;
                                validateDto.setNetworkTypeStatus(true);
//                                validateDto.setNetworkTypeErrorMessage("NetworkType Blank Formula :: ");
                                break;
                            }
                            default:
                                throw new IllegalArgumentException(
                                        "Unexpected value: " + networkTypeCell.getCachedFormulaResultType());
                        }
                    }
                }
            }

            if (!tpaName.equals("Medseva")) {
                String sumInsuredValue;
                if (dataRow.getCell(sumInsuredColumnIndex) != null) {
                    Cell sumInsuredCell = dataRow.getCell(sumInsuredColumnIndex);
                    if (sumInsuredCell.getCellType() == CellType.NUMERIC) {
                        double numericCellValue = sumInsuredCell.getNumericCellValue();
                        DecimalFormat df = new DecimalFormat("#");
                        String stringValue = df.format(numericCellValue).trim();
//                        sumInsuredValue = String.valueOf(sumInsuredCell.getNumericCellValue());
                        validateDto.setSumInsuredStatus(true);
                        validateDto.setSumInsured(stringValue);
                    } else if (sumInsuredCell.getCellType() == CellType.STRING) {
                        String sumInsuredStr = sumInsuredCell.getStringCellValue().replaceAll(",", "");
                        try {
                            double sumInsuredDouble = Double.parseDouble(sumInsuredStr);
                            DecimalFormat df = new DecimalFormat("#");
                            String stringValue = df.format(sumInsuredDouble).trim();
//                            sumInsuredValue = String.valueOf(sumInsuredDouble);
                            validateDto.setSumInsuredStatus(true);
                            validateDto.setSumInsured(stringValue);
                        } catch (NumberFormatException e) {
                            // Handle parsing exception
                            validateDto.setSumInsuredStatus(false);
                            validateDto.setSumInsuredErrorMessage("Error parsing sum insured value: " + e.getMessage());
                        }

                    } else if (sumInsuredCell.getCellType() == CellType._NONE) {
//                        sumInsuredColumnIndexFlag = true;
                        validateDto.setSumInsuredStatus(true);
                        validateDto.setSumInsured("0");
//                        validateDto.setSumInsuredErrorMessage("SumInsured None :: ");
                    } else if (sumInsuredCell.getCellType() == CellType.BLANK) {
//                        sumInsuredColumnIndexFlag = true;
                        validateDto.setSumInsuredStatus(true);
                        validateDto.setSumInsured("0");
//                        validateDto.setSumInsuredErrorMessage("SumInsured Blank :: ");
                    } else if (sumInsuredCell.getCellType() == CellType.ERROR) {
                        byte errorCellValue = sumInsuredCell.getErrorCellValue();
                        validateDto.setSumInsured(String.valueOf(errorCellValue).trim());
                        validateDto.setSumInsuredStatus(true);
//                        validateDto.setSumInsuredErrorMessage("SumInsured Error :: ");
                    } else if (sumInsuredCell.getCellType() == CellType.BOOLEAN) {
                        boolean booleanCellValue = sumInsuredCell.getBooleanCellValue();
                        validateDto.setSumInsured(String.valueOf(booleanCellValue).trim());
                        validateDto.setSumInsuredStatus(true);
//                        validateDto.setSumInsuredErrorMessage("SumInsured Boolean :: ");
                    } else if (sumInsuredCell.getCellType() == CellType.FORMULA) {
                        if (sumInsuredCell.getCachedFormulaResultType() == CellType.NUMERIC) {
                            sumInsuredValue = String.valueOf(sumInsuredCell.getNumericCellValue()).trim();
                            validateDto.setSumInsuredStatus(true);
                            validateDto.setSumInsured(sumInsuredValue);
                        } else if (sumInsuredCell.getCachedFormulaResultType() == CellType.STRING) {
                            String sumInsuredStr = sumInsuredCell.getStringCellValue().replaceAll(",", "");
                            try {
                                double sumInsuredDouble = Double.parseDouble(sumInsuredStr);
                                DecimalFormat df = new DecimalFormat("#");
                                String stringValue = df.format(sumInsuredDouble).trim();
//                            sumInsuredValue = String.valueOf(sumInsuredDouble);
                                validateDto.setSumInsuredStatus(true);
                                validateDto.setSumInsured(stringValue);
                            } catch (NumberFormatException e) {
                                // Handle parsing exception
                                validateDto.setSumInsuredStatus(false);
                                validateDto.setSumInsuredErrorMessage(
                                        "Error parsing sum insured value: " + e.getMessage());
                            }
//                            sumInsuredValue = sumInsuredCell.getStringCellValue();
//                            validateDto.setSumInsuredStatus(true);
//                            validateDto.setSumInsured(sumInsuredValue);
                        } else if (sumInsuredCell.getCachedFormulaResultType() == CellType.BOOLEAN) {
                            boolean booleanCellValue = sumInsuredCell.getBooleanCellValue();
                            validateDto.setSumInsured(String.valueOf(booleanCellValue).trim());
                            validateDto.setSumInsuredStatus(false);
                            validateDto.setSumInsuredErrorMessage("SumInsured Boolean Formula :: ");
                        } else if (sumInsuredCell.getCachedFormulaResultType() == CellType.ERROR) {
                            byte errorCellValue = sumInsuredCell.getErrorCellValue();
                            validateDto.setSumInsured(String.valueOf(errorCellValue).trim());
                            validateDto.setSumInsuredStatus(false);
                            validateDto.setSumInsuredErrorMessage("SumInsured Error Formula :: ");
                        } else if (sumInsuredCell.getCachedFormulaResultType() == CellType._NONE) {
//                            sumInsuredColumnIndexFlag = true;
                            validateDto.setSumInsuredStatus(true);
//                            validateDto.setSumInsuredErrorMessage("SumInsured None Formula :: ");
                        } else if (sumInsuredCell.getCachedFormulaResultType() == CellType.BLANK) {
//                            sumInsuredColumnIndexFlag = true;
                            validateDto.setSumInsuredStatus(true);
//                            validateDto.setSumInsuredErrorMessage("SumInsured Blank Formula :: ");
                        } else {
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + sumInsuredCell.getCachedFormulaResultType());
                        }
                    }
                }
            }

            if (dataRow.getCell(relationshipColumnIndex) != null) {
                Cell relationshipCell = dataRow.getCell(relationshipColumnIndex);
                if (relationshipCell.getCellType() == CellType.NUMERIC) {
                    relationship = String.valueOf(relationshipCell.getNumericCellValue()).trim();
                    validateDto.setRelationshipStatus(false);
                    validateDto.setRelationship(relationship);
                } else if (relationshipCell.getCellType() == CellType.STRING) {
                    relationship = relationshipCell.getStringCellValue().trim();
                    validateDto.setRelationship(relationship);
                    validateDto.setRelationshipStatus(true);
                } else if (relationshipCell.getCellType() == CellType._NONE) {
                    relationshipColumnIndexFlag = true;
                    validateDto.setRelationshipStatus(false);
                    validateDto.setRelationshipErrorMessage("Relationship None :: ");
                } else if (relationshipCell.getCellType() == CellType.BLANK) {
                    relationshipColumnIndexFlag = true;
                    validateDto.setRelationshipStatus(false);
                    validateDto.setRelationshipErrorMessage("Relationship Blank :: ");
                } else if (relationshipCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = relationshipCell.getErrorCellValue();
                    validateDto.setRelationship(String.valueOf(errorCellValue).trim());
                    validateDto.setRelationshipStatus(false);
                    validateDto.setRelationshipErrorMessage("Relationship Error :: ");
                } else if (relationshipCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = relationshipCell.getBooleanCellValue();
                    validateDto.setRelationship(String.valueOf(booleanCellValue).trim());
                    validateDto.setRelationshipStatus(false);
                    validateDto.setRelationshipErrorMessage("Relationship Boolean :: ");
                } else if (relationshipCell.getCellType() == CellType.FORMULA) {
                    switch (relationshipCell.getCellType()) {
                        case NUMERIC: {
                            relationship = String.valueOf(relationshipCell.getNumericCellValue()).trim();
                            validateDto.setRelationshipStatus(false);
                            validateDto.setRelationship(relationship);
                            break;
                        }
                        case STRING: {
                            relationship = relationshipCell.getStringCellValue().trim();
                            validateDto.setRelationship(relationship);
                            validateDto.setRelationshipStatus(true);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = relationshipCell.getBooleanCellValue();
                            validateDto.setRelationship(String.valueOf(booleanCellValue).trim());
                            validateDto.setRelationshipStatus(false);
                            validateDto.setRelationshipErrorMessage("Relationship Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = relationshipCell.getErrorCellValue();
                            validateDto.setRelationship(String.valueOf(errorCellValue).trim());
                            validateDto.setRelationshipStatus(false);
                            validateDto.setRelationshipErrorMessage("Relationship Error Formula :: ");
                            break;
                        }
                        case _NONE: {
                            relationshipColumnIndexFlag = true;
                            validateDto.setRelationshipStatus(false);
                            validateDto.setRelationshipErrorMessage("Relationship None Formula :: ");
                            break;
                        }
                        case BLANK: {
                            relationshipColumnIndexFlag = true;
                            validateDto.setRelationshipStatus(false);
                            validateDto.setRelationshipErrorMessage("Relationship Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + relationshipCell.getCachedFormulaResultType());
                    }
                }

            }

            if (dataRow.getCell(patientNameColumnIndex) != null) {
                Cell patientNameCell = dataRow.getCell(patientNameColumnIndex);
                if (patientNameCell.getCellType() == CellType.NUMERIC) {
                    patientName = String.valueOf(patientNameCell.getNumericCellValue()).trim();
                    validateDto.setPatientNameStatus(false);
                    validateDto.setPatientName(patientName);
                } else if (patientNameCell.getCellType() == CellType.STRING) {
                    patientName = patientNameCell.getStringCellValue().trim();
                    validateDto.setPatientNameStatus(true);
                    validateDto.setPatientName(patientName);
                } else if (patientNameCell.getCellType() == CellType._NONE) {
                    patientNameColumnIndexFlag = true;
                    validateDto.setPatientNameStatus(false);
                    validateDto.setPatientNameErrorMessage("PatientName None :: ");
                } else if (patientNameCell.getCellType() == CellType.BLANK) {
                    patientNameColumnIndexFlag = true;
                    validateDto.setPatientNameStatus(false);
                    validateDto.setPatientNameErrorMessage("PatientName Blank :: ");
                } else if (patientNameCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = patientNameCell.getErrorCellValue();
                    validateDto.setPatientName(String.valueOf(errorCellValue).trim());
                    validateDto.setPatientNameStatus(false);
                    validateDto.setPatientNameErrorMessage("PatientName Error :: ");
                } else if (patientNameCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = patientNameCell.getBooleanCellValue();
                    validateDto.setPatientName(String.valueOf(booleanCellValue).trim());
                    validateDto.setPatientNameStatus(false);
                    validateDto.setPatientNameErrorMessage("PatientName Boolean :: ");
                } else if (patientNameCell.getCellType() == CellType.FORMULA) {
                    switch (patientNameCell.getCellType()) {
                        case NUMERIC: {
                            patientName = String.valueOf(patientNameCell.getNumericCellValue()).trim();
                            validateDto.setPatientNameStatus(false);
                            validateDto.setPatientName(patientName);
                            break;
                        }
                        case STRING: {
                            patientName = patientNameCell.getStringCellValue().trim();
                            validateDto.setPatientNameStatus(true);
                            validateDto.setPatientName(patientName);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = patientNameCell.getBooleanCellValue();
                            validateDto.setPatientName(String.valueOf(booleanCellValue).trim());
                            validateDto.setPatientNameStatus(false);
                            validateDto.setPatientNameErrorMessage("PatientName Boolean Formula:: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = patientNameCell.getErrorCellValue();
                            validateDto.setPatientName(String.valueOf(errorCellValue).trim());
                            validateDto.setPatientNameStatus(false);
                            validateDto.setPatientNameErrorMessage("PatientName Error Formula :: ");
                            break;
                        }
                        case _NONE: {
                            patientNameColumnIndexFlag = true;
                            validateDto.setPatientNameStatus(false);
                            validateDto.setPatientNameErrorMessage("PatientName None Formula :: ");
                            break;
                        }
                        case BLANK: {
                            patientNameColumnIndexFlag = true;
                            validateDto.setPatientNameStatus(false);
                            validateDto.setPatientNameErrorMessage("PatientName Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + patientNameCell.getCachedFormulaResultType());
                    }
                }

            }

            String claimStatus = null;
            if (dataRow.getCell(claimStatusColumnIndex) != null) {
                Cell claimStatusCell = dataRow.getCell(claimStatusColumnIndex);
                if (claimStatusCell.getCellType() == CellType.NUMERIC) {
                    claimStatus = String.valueOf(claimStatusCell.getNumericCellValue()).trim();
                    validateDto.setClaimStatus(false);
                    validateDto.setClaimStatusValue(claimStatus);
                } else if (claimStatusCell.getCellType() == CellType.STRING) {
                    claimStatus = claimStatusCell.getStringCellValue().trim();
                    validateDto.setClaimStatus(true);
                    validateDto.setClaimStatusValue(claimStatus);
                } else if (claimStatusCell.getCellType() == CellType._NONE) {
                    claimStatusColumnIndexFlag = true;
                    validateDto.setClaimStatus(false);
                    validateDto.setClaimStatusErrorMessage("Claim Type None :: ");
                } else if (claimStatusCell.getCellType() == CellType.BLANK) {
                    claimStatusColumnIndexFlag = true;
                    validateDto.setClaimStatus(false);
                    validateDto.setClaimStatusErrorMessage("Claim Type Blank :: ");
                } else if (claimStatusCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = claimStatusCell.getErrorCellValue();
                    validateDto.setClaimStatusValue(String.valueOf(errorCellValue).trim());
                    validateDto.setClaimStatus(false);
                    validateDto.setClaimStatusErrorMessage("Claim Type Error :: ");
                } else if (claimStatusCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = claimStatusCell.getBooleanCellValue();
                    validateDto.setClaimStatusValue(String.valueOf(booleanCellValue).trim());
                    validateDto.setClaimStatus(false);
                    validateDto.setClaimStatusErrorMessage("Claim Type Boolean :: ");
                } else if (claimStatusCell.getCellType() == CellType.FORMULA) {
                    switch (claimStatusCell.getCellType()) {
                        case NUMERIC: {
                            claimStatus = String.valueOf(claimStatusCell.getNumericCellValue()).trim();
                            validateDto.setClaimStatus(false);
                            validateDto.setClaimStatusValue(claimStatus);
                            break;
                        }
                        case STRING: {
                            claimStatus = claimStatusCell.getStringCellValue().trim();
                            validateDto.setClaimStatus(true);
                            validateDto.setClaimStatusValue(claimStatus);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = claimStatusCell.getBooleanCellValue();
                            validateDto.setClaimStatusValue(String.valueOf(booleanCellValue).trim());
                            validateDto.setClaimStatus(false);
                            validateDto.setClaimStatusErrorMessage("Claim Type Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = claimStatusCell.getErrorCellValue();
                            validateDto.setClaimStatusValue(String.valueOf(errorCellValue).trim());
                            validateDto.setClaimStatus(false);
                            validateDto.setClaimStatusErrorMessage("Claim Type Error Formula :: ");
                            break;
                        }
                        case _NONE: {
                            claimStatusColumnIndexFlag = true;
                            validateDto.setClaimStatus(false);
                            validateDto.setClaimStatusErrorMessage("Claim Type None Formula :: ");
                            break;
                        }
                        case BLANK: {
                            claimStatusColumnIndexFlag = true;
                            validateDto.setClaimStatus(false);
                            validateDto.setClaimStatusErrorMessage("Claim Type Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + claimStatusCell.getCachedFormulaResultType());
                    }
                }
            }

            if (dataRow.getCell(claimTypeColumnIndex) != null) {
                Cell claimTypeCell = dataRow.getCell(claimTypeColumnIndex);
                if (claimTypeCell.getCellType() == CellType.NUMERIC) {
                    claimType = String.valueOf(claimTypeCell.getNumericCellValue()).trim();
                    validateDto.setClaimTypeStatus(false);
                    validateDto.setClaimType(claimType);
                } else if (claimTypeCell.getCellType() == CellType.STRING) {
                    claimType = claimTypeCell.getStringCellValue().trim();
                    validateDto.setClaimTypeStatus(true);
                    validateDto.setClaimType(claimType);
                } else if (claimTypeCell.getCellType() == CellType._NONE) {
                    claimTypeColumnIndexFlag = true;
                    validateDto.setClaimTypeStatus(false);
                    validateDto.setClaimTypeErrorMessage("Claim Type None :: ");
                } else if (claimTypeCell.getCellType() == CellType.BLANK) {
                    claimTypeColumnIndexFlag = true;
                    validateDto.setClaimTypeStatus(false);
                    validateDto.setClaimTypeErrorMessage("Claim Type Blank :: ");
                } else if (claimTypeCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = claimTypeCell.getErrorCellValue();
                    validateDto.setClaimType(String.valueOf(errorCellValue).trim());
                    validateDto.setClaimTypeStatus(false);
                    validateDto.setClaimTypeErrorMessage("Claim Type Error :: ");
                } else if (claimTypeCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = claimTypeCell.getBooleanCellValue();
                    validateDto.setClaimType(String.valueOf(booleanCellValue).trim());
                    validateDto.setClaimTypeStatus(false);
                    validateDto.setClaimTypeErrorMessage("Claim Type Boolean :: ");
                } else if (claimTypeCell.getCellType() == CellType.FORMULA) {
                    switch (claimTypeCell.getCellType()) {
                        case NUMERIC: {
                            claimType = String.valueOf(claimTypeCell.getNumericCellValue()).trim();
                            validateDto.setClaimTypeStatus(false);
                            validateDto.setClaimType(claimType);
                            break;
                        }
                        case STRING: {
                            claimType = claimTypeCell.getStringCellValue().trim();
                            validateDto.setClaimTypeStatus(true);
                            validateDto.setClaimType(claimType);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = claimTypeCell.getBooleanCellValue();
                            validateDto.setClaimType(String.valueOf(booleanCellValue).trim());
                            validateDto.setClaimTypeStatus(false);
                            validateDto.setClaimTypeErrorMessage("Claim Type Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = claimTypeCell.getErrorCellValue();
                            validateDto.setClaimType(String.valueOf(errorCellValue).trim());
                            validateDto.setClaimTypeStatus(false);
                            validateDto.setClaimTypeErrorMessage("Claim Type Error Formula :: ");
                            break;
                        }
                        case _NONE: {
                            claimTypeColumnIndexFlag = true;
                            validateDto.setClaimTypeStatus(false);
                            validateDto.setClaimTypeErrorMessage("Claim Type None Formula :: ");
                            break;
                        }
                        case BLANK: {
                            claimTypeColumnIndexFlag = true;
                            validateDto.setClaimTypeStatus(false);
                            validateDto.setClaimTypeErrorMessage("Claim Type Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + claimTypeCell.getCachedFormulaResultType());
                    }
                }
            }

            if (dataRow.getCell(hospitalNameColumnIndex) != null) {
                Cell hospitalNameCell = dataRow.getCell(hospitalNameColumnIndex);
                if (hospitalNameCell.getCellType() == CellType.NUMERIC) {
                    hospitalName = String.valueOf(hospitalNameCell.getNumericCellValue()).trim();
                    validateDto.setHospitalNameStatus(true);
                    validateDto.setHospitalName(hospitalName);
                } else if (hospitalNameCell.getCellType() == CellType.STRING) {
                    hospitalName = hospitalNameCell.getStringCellValue().trim();
                    validateDto.setHospitalNameStatus(true);
                    validateDto.setHospitalName(hospitalName);
                } else if (hospitalNameCell.getCellType() == CellType._NONE) {
//                    hospitalNameColumnIndexFlag = true;
                    validateDto.setHospitalNameStatus(true);
//                    validateDto.setHospitalNameErrorMessage("HospitalName None :: ");
                } else if (hospitalNameCell.getCellType() == CellType.BLANK) {
//                    hospitalNameColumnIndexFlag = true;
                    validateDto.setHospitalNameStatus(true);
//                    validateDto.setHospitalNameErrorMessage("HospitalName Blank :: ");
                } else if (hospitalNameCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = hospitalNameCell.getErrorCellValue();
                    validateDto.setHospitalName(String.valueOf(errorCellValue).trim());
                    validateDto.setHospitalNameStatus(true);
//                    validateDto.setHospitalNameErrorMessage("HospitalName Error :: ");
                } else if (hospitalNameCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = hospitalNameCell.getBooleanCellValue();
                    validateDto.setHospitalName(String.valueOf(booleanCellValue).trim());
                    validateDto.setHospitalNameStatus(true);
//                    validateDto.setHospitalNameErrorMessage("HospitalName Boolean :: ");
                } else if (hospitalNameCell.getCellType() == CellType.FORMULA) {
                    switch (hospitalNameCell.getCellType()) {
                        case NUMERIC: {
                            hospitalName = String.valueOf(hospitalNameCell.getNumericCellValue()).trim();
                            validateDto.setHospitalNameStatus(true);
                            validateDto.setHospitalName(hospitalName);
                            break;
                        }
                        case STRING: {
                            hospitalName = hospitalNameCell.getStringCellValue().trim();
                            validateDto.setHospitalNameStatus(true);
                            validateDto.setHospitalName(hospitalName);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = hospitalNameCell.getBooleanCellValue();
                            validateDto.setHospitalName(String.valueOf(booleanCellValue).trim());
                            validateDto.setHospitalNameStatus(true);
//                            validateDto.setHospitalNameErrorMessage("HospitalName Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = hospitalNameCell.getErrorCellValue();
                            validateDto.setHospitalName(String.valueOf(errorCellValue).trim());
                            validateDto.setHospitalNameStatus(true);
//                            validateDto.setHospitalNameErrorMessage("HospitalName Error Formula :: ");
                            break;
                        }
                        case _NONE: {
//                            hospitalNameColumnIndexFlag = true;
                            validateDto.setHospitalNameStatus(true);
//                            validateDto.setHospitalNameErrorMessage("HospitalName None Formula :: ");
                            break;
                        }
                        case BLANK: {
//                            hospitalNameColumnIndexFlag = true;
                            validateDto.setHospitalNameStatus(true);
//                            validateDto.setHospitalNameErrorMessage("HospitalName Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + hospitalNameCell.getCachedFormulaResultType());
                    }
                }
            }

            if (dataRow.getCell(diseaseColumnIndex) != null) {

                Cell diseaseCell = dataRow.getCell(diseaseColumnIndex);

                if (diseaseCell.getCellType() == CellType.NUMERIC) {
                    disease = String.valueOf(diseaseCell.getNumericCellValue()).trim();
                    validateDto.setDiseaseStatus(true);
                    validateDto.setDisease(disease);
                } else if (diseaseCell.getCellType() == CellType.STRING) {
                    disease = diseaseCell.getStringCellValue().trim();
                    validateDto.setDiseaseStatus(true);
                    validateDto.setDisease(disease);
                } else if (diseaseCell.getCellType() == CellType._NONE) {
//                    diseaseColumnIndexFlag = true;
                    validateDto.setDiseaseStatus(true);
//                    validateDto.setDiseaseErrorMessage("Disease None :: ");
                } else if (diseaseCell.getCellType() == CellType.BLANK) {
//                    diseaseColumnIndexFlag = true;
                    validateDto.setDiseaseStatus(true);
//                    validateDto.setDiseaseErrorMessage("Disease Blank :: ");
                } else if (diseaseCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = diseaseCell.getErrorCellValue();
                    validateDto.setDisease(String.valueOf(errorCellValue).trim());
                    validateDto.setDiseaseStatus(true);
//                    validateDto.setDiseaseErrorMessage("Disease Error :: ");
                } else if (diseaseCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = diseaseCell.getBooleanCellValue();
                    validateDto.setDisease(String.valueOf(booleanCellValue).trim());
                    validateDto.setDiseaseStatus(true);
//                    validateDto.setDiseaseErrorMessage("Disease Boolean :: ");
                } else if (diseaseCell.getCellType() == CellType.FORMULA) {
                    switch (diseaseCell.getCellType()) {
                        case NUMERIC: {
                            disease = String.valueOf(diseaseCell.getNumericCellValue()).trim();
                            validateDto.setDiseaseStatus(true);
                            validateDto.setDisease(disease);
                            break;
                        }
                        case STRING: {
                            disease = diseaseCell.getStringCellValue().trim();
                            validateDto.setDiseaseStatus(true);
                            validateDto.setDisease(disease);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = diseaseCell.getBooleanCellValue();
                            validateDto.setDisease(String.valueOf(booleanCellValue).trim());
                            validateDto.setDiseaseStatus(true);
//                            validateDto.setDiseaseErrorMessage("Disease Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = diseaseCell.getErrorCellValue();
                            validateDto.setDisease(String.valueOf(errorCellValue).trim());
                            validateDto.setDiseaseStatus(true);
//                            validateDto.setDiseaseErrorMessage("Disease Error Formula :: ");
                            break;
                        }
                        case _NONE: {
//                            diseaseColumnIndexFlag = true;
                            validateDto.setDiseaseStatus(true);
//                            validateDto.setDiseaseErrorMessage("Disease None Formula :: ");
                            break;
                        }
                        case BLANK: {
//                            diseaseColumnIndexFlag = true;
                            validateDto.setDiseaseStatus(true);
//                            validateDto.setDiseaseErrorMessage("Disease Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + diseaseCell.getCachedFormulaResultType());
                    }
                }
            }

            String dateOfClaimValue = null;
            if (dataRow.getCell(dateOfClaimColumnIndex) != null) {
                Cell dateOfClaimCell = dataRow.getCell(dateOfClaimColumnIndex);
                if (dateOfClaimCell.getCellType() == CellType.NUMERIC) {
                    dateOfClaimValue = String.valueOf(dateOfClaimCell.getDateCellValue());
                    SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                    String format = outputFormat.format(dateOfClaimCell.getDateCellValue()).trim();
                    validateDto.setDateOfClaimStatus(true);
                    validateDto.setDateOfClaim(format);
                } else if (dateOfClaimCell.getCellType() == CellType.STRING) {
                    dateOfClaimValue = dateOfClaimCell.getStringCellValue().trim();
                    validateDto.setDateOfClaimStatus(true);
                    validateDto.setDateOfClaim(dateOfClaimValue);
                } else if (dateOfClaimCell.getCellType() == CellType._NONE) {
                    dateOfClaimColumnIndexFlag = true;
                    validateDto.setDateOfClaimStatus(false);
                    validateDto.setDateOfClaimErrorMessage("DateOfClaim None :: ");
                } else if (dateOfClaimCell.getCellType() == CellType.BLANK) {
                    dateOfClaimColumnIndexFlag = true;
                    validateDto.setDateOfClaimStatus(false);
                    validateDto.setDateOfClaimErrorMessage("DateOfClaim Blank :: ");
                } else if (dateOfClaimCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = dateOfClaimCell.getErrorCellValue();
                    validateDto.setDateOfClaim(String.valueOf(errorCellValue).trim());
                    validateDto.setDateOfClaimStatus(false);
                    validateDto.setDateOfClaimErrorMessage("DateOfClaim Error :: ");
                } else if (dateOfClaimCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = dateOfClaimCell.getBooleanCellValue();
                    validateDto.setDateOfClaim(String.valueOf(booleanCellValue).trim());
                    validateDto.setDateOfClaimStatus(false);
                    validateDto.setDateOfClaimErrorMessage("DateOfClaim Boolean :: ");
                } else if (dateOfClaimCell.getCellType() == CellType.FORMULA) {
                    switch (dateOfClaimCell.getCellType()) {
                        case NUMERIC: {
                            dateOfClaimValue = String.valueOf(dateOfClaimCell.getDateCellValue());
                            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                            String format = outputFormat.format(dateOfClaimCell.getDateCellValue()).trim();
                            validateDto.setDateOfClaimStatus(true);
                            validateDto.setDateOfClaim(format);
                            break;
                        }
                        case STRING: {
                            dateOfClaimValue = dateOfClaimCell.getStringCellValue().trim();
                            validateDto.setDateOfClaimStatus(true);
                            validateDto.setDateOfClaim(dateOfClaimValue);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = dateOfClaimCell.getBooleanCellValue();
                            validateDto.setDateOfClaim(String.valueOf(booleanCellValue));
                            validateDto.setDateOfClaimStatus(false);
                            validateDto.setDateOfClaimErrorMessage("DateOfClaim Boolean :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = dateOfClaimCell.getErrorCellValue();
                            validateDto.setDateOfClaim(String.valueOf(errorCellValue).trim());
                            validateDto.setDateOfClaimStatus(false);
                            validateDto.setDateOfClaimErrorMessage("DateOfClaim Error :: ");
                            break;
                        }
                        case _NONE: {
                            dateOfClaimColumnIndexFlag = true;
                            validateDto.setDateOfClaimStatus(false);
                            validateDto.setDateOfClaimErrorMessage("DateOfClaim None :: ");
                            break;
                        }
                        case BLANK: {
                            dateOfClaimColumnIndexFlag = true;
                            validateDto.setDateOfClaimStatus(false);
                            validateDto.setDateOfClaimErrorMessage("DateOfClaim Blank :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + dateOfClaimCell.getCachedFormulaResultType());
                    }
                }
            }

            String claimedAmountValue;
            if (dataRow.getCell(claimedAmountColumnIndex) != null) {
                Cell claimedAmountCell = dataRow.getCell(claimedAmountColumnIndex);
                if (claimedAmountCell.getCellType() == CellType.NUMERIC) {
                    double numericCellValue = claimedAmountCell.getNumericCellValue();
                    DecimalFormat df = new DecimalFormat("#");
                    String stringValue = df.format(numericCellValue).trim();
//                    claimedAmountValue = String.valueOf(claimedAmountCell.getNumericCellValue());
                    validateDto.setClaimedAmountStatus(true);
                    validateDto.setClaimedAmount(stringValue);
                } else if (claimedAmountCell.getCellType() == CellType.STRING) {
                    String sumInsuredStr = claimedAmountCell.getStringCellValue().replaceAll(",", "");
                    try {
                        double claimedAmountDouble = Double.parseDouble(sumInsuredStr);
                        DecimalFormat df = new DecimalFormat("#");
                        String stringValue = df.format(claimedAmountDouble).trim();
//                        claimedAmountValue = String.valueOf(claimedAmountDouble);
                        validateDto.setClaimedAmountStatus(true);
                        validateDto.setClaimedAmount(stringValue);
                    } catch (NumberFormatException e) {
                        // Handle parsing exception
                        validateDto.setClaimedAmountStatus(false);
                        validateDto.setAdmissionDateErrorMessage("Error parsing sum insured value: " + e.getMessage());
                    }
                } else if (claimedAmountCell.getCellType() == CellType._NONE) {
//                    claimedAmountColumnIndexFlag = true;
                    validateDto.setClaimedAmountStatus(true);
                    validateDto.setClaimedAmount("0");
//                    validateDto.setClaimedAmountErrorMessage("ClaimedAmount None :: ");
                } else if (claimedAmountCell.getCellType() == CellType.BLANK) {
//                    claimedAmountColumnIndexFlag = true;
                    validateDto.setClaimedAmountStatus(true);
                    validateDto.setClaimedAmount("0");
//                    validateDto.setClaimedAmountErrorMessage("ClaimedAmount Blank :: ");
                } else if (claimedAmountCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = claimedAmountCell.getErrorCellValue();
                    validateDto.setClaimedAmount(String.valueOf(errorCellValue).trim());
                    validateDto.setClaimedAmountStatus(true);
//                    validateDto.setClaimedAmountErrorMessage("ClaimedAmount Error :: ");
                } else if (claimedAmountCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = claimedAmountCell.getBooleanCellValue();
                    validateDto.setClaimedAmount(String.valueOf(booleanCellValue).trim());
                    validateDto.setClaimedAmountStatus(true);
//                    validateDto.setClaimedAmountErrorMessage("ClaimedAmount Boolean :: ");
                } else if (claimedAmountCell.getCellType() == CellType.FORMULA) {
                    if (claimedAmountCell.getCachedFormulaResultType() == CellType.NUMERIC) {
                        double numericCellValue = claimedAmountCell.getNumericCellValue();
                        DecimalFormat df = new DecimalFormat("#");
                        String stringValue = df.format(numericCellValue).trim();
//                    claimedAmountValue = String.valueOf(claimedAmountCell.getNumericCellValue());
                        validateDto.setClaimedAmountStatus(true);
                        validateDto.setClaimedAmount(stringValue);
//                        claimedAmountValue = String.valueOf(claimedAmountCell.getNumericCellValue());
//                        validateDto.setClaimedAmountStatus(true);
//                        validateDto.setClaimedAmount(claimedAmountValue);
                    } else if (claimedAmountCell.getCachedFormulaResultType() == CellType.STRING) {
                        String sumInsuredStr = claimedAmountCell.getStringCellValue().replaceAll(",", "");
                        try {
                            double claimedAmountDouble = Double.parseDouble(sumInsuredStr);
                            DecimalFormat df = new DecimalFormat("#");
                            String stringValue = df.format(claimedAmountDouble).trim();
//                        claimedAmountValue = String.valueOf(claimedAmountDouble);
                            validateDto.setClaimedAmountStatus(true);
                            validateDto.setClaimedAmount(stringValue);
                        } catch (NumberFormatException e) {
                            // Handle parsing exception
                            validateDto.setClaimedAmountStatus(false);
                            validateDto
                                    .setAdmissionDateErrorMessage("Error parsing sum insured value: " + e.getMessage());
                        }
//                        claimedAmountValue = claimedAmountCell.getStringCellValue();
//                        validateDto.setClaimedAmountStatus(false);
//                        validateDto.setClaimedAmount(claimedAmountValue);
                    } else if (claimedAmountCell.getCachedFormulaResultType() == CellType.BOOLEAN) {
                        boolean booleanCellValue = claimedAmountCell.getBooleanCellValue();
                        validateDto.setClaimedAmount(String.valueOf(booleanCellValue).trim());
                        validateDto.setClaimedAmountStatus(true);
//                        validateDto.setClaimedAmountErrorMessage("ClaimedAmount Boolean Formuala :: ");
                    } else if (claimedAmountCell.getCachedFormulaResultType() == CellType.ERROR) {
                        byte errorCellValue = claimedAmountCell.getErrorCellValue();
                        validateDto.setClaimedAmount(String.valueOf(errorCellValue).trim());
                        validateDto.setClaimedAmountStatus(true);
//                        validateDto.setClaimedAmountErrorMessage("ClaimedAmount Error Formuala :: ");
                    } else if (claimedAmountCell.getCachedFormulaResultType() == CellType._NONE) {
//                        claimedAmountColumnIndexFlag = true;
                        validateDto.setClaimedAmountStatus(true);
                        validateDto.setClaimedAmount("0");
//                        validateDto.setClaimedAmountErrorMessage("ClaimedAmount None Formuala :: ");
                    } else if (claimedAmountCell.getCachedFormulaResultType() == CellType.BLANK) {
//                        claimedAmountColumnIndexFlag = true;
                        validateDto.setClaimedAmountStatus(true);
                        validateDto.setClaimedAmount("0");
//                        validateDto.setClaimedAmountErrorMessage("ClaimedAmount Blank Formuala :: ");
                    } else {
                        throw new IllegalArgumentException(
                                "Unexpected value: " + claimedAmountCell.getCachedFormulaResultType());
                    }
                }
            }

            String paidAmountValue;
            if (dataRow.getCell(paidAmountColumnIndex) != null) {
                Cell paidAmountCell = dataRow.getCell(paidAmountColumnIndex);
                if (paidAmountCell.getCellType() == CellType.NUMERIC) {
                    double numericCellValue = paidAmountCell.getNumericCellValue();
                    DecimalFormat df = new DecimalFormat("#");
                    String stringValue = df.format(numericCellValue).trim();
//                    claimedAmountValue = String.valueOf(claimedAmountCell.getNumericCellValue());
                    validateDto.setPaidAmountStatus(true);
                    validateDto.setPaidAmount(stringValue);
                } else if (paidAmountCell.getCellType() == CellType.STRING) {
                    String sumInsuredStr = paidAmountCell.getStringCellValue().replaceAll(",", "");
                    try {
                        double claimedAmountDouble = Double.parseDouble(sumInsuredStr);
                        DecimalFormat df = new DecimalFormat("#");
                        String stringValue = df.format(claimedAmountDouble).trim();
//                        claimedAmountValue = String.valueOf(claimedAmountDouble);
                        validateDto.setPaidAmountStatus(true);
                        validateDto.setPaidAmount(stringValue);
                    } catch (NumberFormatException e) {
                        // Handle parsing exception
                        validateDto.setPaidAmountStatus(false);
                        validateDto.setPaidAmountErrorMessage("Error parsing sum insured value: " + e.getMessage());
                    }
                } else if (paidAmountCell.getCellType() == CellType._NONE) {
//                    claimedAmountColumnIndexFlag = true;
                    validateDto.setPaidAmountStatus(true);
                    validateDto.setPaidAmount("0");
//                    validateDto.setClaimedAmountErrorMessage("ClaimedAmount None :: ");
                } else if (paidAmountCell.getCellType() == CellType.BLANK) {
//                    claimedAmountColumnIndexFlag = true;
                    validateDto.setPaidAmountStatus(true);
                    validateDto.setPaidAmount("0");
//                    validateDto.setClaimedAmountErrorMessage("ClaimedAmount Blank :: ");
                } else if (paidAmountCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = paidAmountCell.getErrorCellValue();
                    validateDto.setPaidAmount(String.valueOf(errorCellValue).trim());
                    validateDto.setPaidAmountStatus(true);
//                    validateDto.setClaimedAmountErrorMessage("ClaimedAmount Error :: ");
                } else if (paidAmountCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = paidAmountCell.getBooleanCellValue();
                    validateDto.setPaidAmount(String.valueOf(booleanCellValue).trim());
                    validateDto.setPaidAmountStatus(true);
//                    validateDto.setClaimedAmountErrorMessage("ClaimedAmount Boolean :: ");
                } else if (paidAmountCell.getCellType() == CellType.FORMULA) {
                    if (paidAmountCell.getCachedFormulaResultType() == CellType.NUMERIC) {
                        double numericCellValue = paidAmountCell.getNumericCellValue();
                        DecimalFormat df = new DecimalFormat("#");
                        String stringValue = df.format(numericCellValue).trim();
//                    claimedAmountValue = String.valueOf(claimedAmountCell.getNumericCellValue());
                        validateDto.setPaidAmountStatus(true);
                        validateDto.setPaidAmount(stringValue);
//                        claimedAmountValue = String.valueOf(claimedAmountCell.getNumericCellValue());
//                        validateDto.setClaimedAmountStatus(true);
//                        validateDto.setClaimedAmount(claimedAmountValue);
                    } else if (paidAmountCell.getCachedFormulaResultType() == CellType.STRING) {
                        String sumInsuredStr = paidAmountCell.getStringCellValue().replaceAll(",", "");
                        try {
                            double claimedAmountDouble = Double.parseDouble(sumInsuredStr);
                            DecimalFormat df = new DecimalFormat("#");
                            String stringValue = df.format(claimedAmountDouble).trim();
//                        claimedAmountValue = String.valueOf(claimedAmountDouble);
                            validateDto.setPaidAmountStatus(true);
                            validateDto.setPaidAmount(stringValue);
                        } catch (NumberFormatException e) {
                            // Handle parsing exception
                            validateDto.setPaidAmountStatus(false);
                            validateDto.setPaidAmountErrorMessage("Error parsing sum insured value: " + e.getMessage());
                        }
//                        claimedAmountValue = claimedAmountCell.getStringCellValue();
//                        validateDto.setClaimedAmountStatus(false);
//                        validateDto.setClaimedAmount(claimedAmountValue);
                    } else if (paidAmountCell.getCachedFormulaResultType() == CellType.BOOLEAN) {
                        boolean booleanCellValue = paidAmountCell.getBooleanCellValue();
                        validateDto.setPaidAmount(String.valueOf(booleanCellValue).trim());
                        validateDto.setPaidAmountStatus(true);
//                        validateDto.setClaimedAmountErrorMessage("ClaimedAmount Boolean Formuala :: ");
                    } else if (paidAmountCell.getCachedFormulaResultType() == CellType.ERROR) {
                        byte errorCellValue = paidAmountCell.getErrorCellValue();
                        validateDto.setPaidAmount(String.valueOf(errorCellValue).trim());
                        validateDto.setPaidAmountStatus(true);
//                        validateDto.setClaimedAmountErrorMessage("ClaimedAmount Error Formuala :: ");
                    } else if (paidAmountCell.getCachedFormulaResultType() == CellType._NONE) {
//                        claimedAmountColumnIndexFlag = true;
                        validateDto.setClaimedAmountStatus(true);
                        validateDto.setClaimedAmount("0");
//                        validateDto.setClaimedAmountErrorMessage("ClaimedAmount None Formuala :: ");
                    } else if (paidAmountCell.getCachedFormulaResultType() == CellType.BLANK) {
//                        claimedAmountColumnIndexFlag = true;
                        validateDto.setPaidAmountStatus(true);
                        validateDto.setPaidAmount("0");
//                        validateDto.setClaimedAmountErrorMessage("ClaimedAmount Blank Formuala :: ");
                    } else {
                        throw new IllegalArgumentException(
                                "Unexpected value: " + paidAmountCell.getCachedFormulaResultType());
                    }
                }
            }

//            String paidAmountValue;
//            if (dataRow.getCell(paidAmountColumnIndex) != null) {
//                Cell paidAmountCell = dataRow.getCell(paidAmountColumnIndex);
//                if (paidAmountCell.getCellType() == CellType.NUMERIC) {
//                    double numericCellValue = paidAmountCell.getNumericCellValue();
//                    DecimalFormat df = new DecimalFormat("#");
//                    String stringValue = df.format(numericCellValue);
////                    paidAmountValue = String.valueOf(paidAmountCell.getNumericCellValue());
//                    validateDto.setPaidAmountStatus(true);
//                    validateDto.setPaidAmount(stringValue);
//                } else if (paidAmountCell.getCellType() == CellType.STRING) {
//                    String sumInsuredStr = paidAmountCell.getStringCellValue().replaceAll(",", "");
//                    try {
//                        double paidAmountDouble = Double.parseDouble(sumInsuredStr);
//                        DecimalFormat df = new DecimalFormat("#");
//                        String stringValue = df.format(paidAmountDouble);
////                        paidAmountValue = String.valueOf(paidAmountDouble);
//                        validateDto.setPaidAmountStatus(true);
//                        validateDto.setPaidAmount(stringValue);
//                    } catch (NumberFormatException e) {
//                        // Handle parsing exception
//                        validateDto.setPaidAmountStatus(false);
//                        validateDto.setPaidAmountErrorMessage("Error parsing sum insured value: " + e.getMessage());
//                    }
//                } else if (paidAmountCell.getCellType() == CellType._NONE) {
////                    paidAmountColumnIndexFlag = true;
//                    validateDto.setPaidAmountStatus(true);
//                    validateDto.setPaidAmount("0");
////                    validateDto.setPaidAmountErrorMessage("PaidAmount None :: ");
//                } else if (paidAmountCell.getCellType() == CellType.BLANK) {
////                    paidAmountColumnIndexFlag = true;
//                    validateDto.setPaidAmountStatus(true);
//                    validateDto.setPaidAmount("0");
////                    validateDto.setPaidAmountErrorMessage("PaidAmount Blank :: ");
//                } else if (paidAmountCell.getCellType() == CellType.ERROR) {
//                    byte errorCellValue = paidAmountCell.getErrorCellValue();
//                    validateDto.setPaidAmount(String.valueOf(errorCellValue));
//                    validateDto.setPaidAmountStatus(true);
////                    validateDto.setPaidAmountErrorMessage("PaidAmount Error :: ");
//                } else if (paidAmountCell.getCellType() == CellType.BOOLEAN) {
//                    boolean booleanCellValue = paidAmountCell.getBooleanCellValue();
//                    validateDto.setPaidAmount(String.valueOf(booleanCellValue));
//                    validateDto.setPaidAmountStatus(true);
////                    validateDto.setPaidAmountErrorMessage("PaidAmount Boolean :: ");
//                } else if (paidAmountCell.getCellType() == CellType.FORMULA) {
//                    switch (paidAmountCell.getCellType()) {
//                        case NUMERIC: {
//                            double numericCellValue = paidAmountCell.getNumericCellValue();
//                            DecimalFormat df = new DecimalFormat("#");
//                            String stringValue = df.format(numericCellValue);
////                    paidAmountValue = String.valueOf(paidAmountCell.getNumericCellValue());
//                            validateDto.setPaidAmountStatus(true);
//                            validateDto.setPaidAmount(stringValue);
////                            paidAmountValue = String.valueOf(paidAmountCell.getNumericCellValue());
////                            validateDto.setPaidAmountStatus(true);
////                            validateDto.setPaidAmount(paidAmountValue);
//                            break;
//                        }
//                        case STRING: {
//                            String sumInsuredStr = paidAmountCell.getStringCellValue().replaceAll(",", "");
//                            try {
//                                double paidAmountDouble = Double.parseDouble(sumInsuredStr);
//                                DecimalFormat df = new DecimalFormat("#");
//                                String stringValue = df.format(paidAmountDouble);
////                        paidAmountValue = String.valueOf(paidAmountDouble);
//                                validateDto.setPaidAmountStatus(true);
//                                validateDto.setPaidAmount(stringValue);
//                            } catch (NumberFormatException e) {
//                                // Handle parsing exception
//                                validateDto.setPaidAmountStatus(false);
//                                validateDto.setPaidAmountErrorMessage("Error parsing sum insured value: " + e.getMessage());
//                            }
////                            paidAmountValue = paidAmountCell.getStringCellValue();
////                            validateDto.setPaidAmountStatus(false);
////                            validateDto.setPaidAmount(paidAmountValue);
////                            validateDto.setPaidAmountErrorMessage("PaidAmount String :: ");
//                            break;
//                        }
//                        case BOOLEAN: {
//                            boolean booleanCellValue = paidAmountCell.getBooleanCellValue();
//                            validateDto.setPaidAmount(String.valueOf(booleanCellValue));
//                            validateDto.setPaidAmountStatus(true);
////                            validateDto.setPaidAmountErrorMessage("PaidAmount Boolean Formuala :: ");
//                            break;
//                        }
//                        case ERROR: {
//                            byte errorCellValue = paidAmountCell.getErrorCellValue();
//                            validateDto.setPaidAmount(String.valueOf(errorCellValue));
//                            validateDto.setPaidAmountStatus(true);
////                            validateDto.setPaidAmountErrorMessage("PaidAmount Error :: Formuala");
//                            break;
//                        }
//                        case _NONE: {
////                            paidAmountColumnIndexFlag = true;
//                            validateDto.setPaidAmountStatus(true);
//                            validateDto.setPaidAmount("0");
////                            validateDto.setPaidAmountErrorMessage("PaidAmount None Formuala :: ");
//                            break;
//                        }
//                        case BLANK: {
////                            paidAmountColumnIndexFlag = true;
//                            validateDto.setPaidAmountStatus(true);
//                            validateDto.setPaidAmount("0");
////                            validateDto.setPaidAmountErrorMessage("PaidAmount Blank Formuala :: ");
//                            break;
//                        }
//                        default:
//                            throw new IllegalArgumentException(
//                                    "Unexpected value: " + paidAmountCell.getCachedFormulaResultType());
//                    }
//                }
//            }

            String outstandingAmountValue;
            if (dataRow.getCell(outstandingAmountColumnIndex) != null) {
                Cell outstandingAmountCell = dataRow.getCell(outstandingAmountColumnIndex);
                if (outstandingAmountCell.getCellType() == CellType.NUMERIC) {
                    double numericValue = outstandingAmountCell.getNumericCellValue();
                    DecimalFormat df = new DecimalFormat("#");
                    String stringValue = df.format(numericValue).trim();
//                    outstandingAmountValue = String.valueOf(numericValue);
                    validateDto.setOutstandingAmountStatus(true);
                    validateDto.setOutstandingAmount(stringValue); // Set explicitly if the numeric value is 0.0
                } else if (outstandingAmountCell.getCellType() == CellType.STRING) {
                    String sumInsuredStr = outstandingAmountCell.getStringCellValue().replaceAll(",", "");
                    try {
                        double sumInsuredDouble = Double.parseDouble(sumInsuredStr);
                        DecimalFormat df = new DecimalFormat("#");
                        String stringValue = df.format(sumInsuredDouble).trim();
//                        outstandingAmountValue = String.valueOf(sumInsuredDouble);
                        validateDto.setOutstandingAmountStatus(true);
                        validateDto.setOutstandingAmount(stringValue);
                    } catch (NumberFormatException e) {
                        // Handle parsing exception
                        validateDto.setOutstandingAmountStatus(false);
                        validateDto
                                .setOutstandingAmountErrorMessage("Error parsing sum insured value: " + e.getMessage());
                    }
                } else if (outstandingAmountCell.getCellType() == CellType._NONE) {
//                    outstandingColumnIndexFlag = true;
                    validateDto.setOutstandingAmountStatus(true);
                    validateDto.setOutstandingAmount("0");
//                    validateDto.setOutstandingAmountErrorMessage("OutstandingAmount None");
                } else if (outstandingAmountCell.getCellType() == CellType.BLANK) {
//                    outstandingColumnIndexFlag = true;
                    validateDto.setOutstandingAmountStatus(true);
                    validateDto.setOutstandingAmount("0");
//                    validateDto.setOutstandingAmountErrorMessage("OutstandingAmount Blank");
                } else if (outstandingAmountCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = outstandingAmountCell.getErrorCellValue();
                    validateDto.setOutstandingAmount(String.valueOf(errorCellValue).trim());
                    validateDto.setOutstandingAmountStatus(true);
//                    validateDto.setOutstandingAmountErrorMessage("OutstandingAmount Error");
                } else if (outstandingAmountCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = outstandingAmountCell.getBooleanCellValue();
                    validateDto.setOutstandingAmount(String.valueOf(booleanCellValue).trim());
                    validateDto.setOutstandingAmountStatus(true);
//                    validateDto.setOutstandingAmountErrorMessage("OutstandingAmount Boolean");
                } else if (outstandingAmountCell.getCellType() == CellType.FORMULA) {
                    switch (outstandingAmountCell.getCellType()) {
                        case NUMERIC: {
                            double numericValue = outstandingAmountCell.getNumericCellValue();
                            DecimalFormat df = new DecimalFormat("#");
                            String stringValue = df.format(numericValue).trim();
//                    outstandingAmountValue = String.valueOf(numericValue);
                            validateDto.setOutstandingAmountStatus(true);
                            validateDto.setOutstandingAmount(stringValue); // Set explicitly if the numeric value is 0.0
//                            outstandingAmountValue = String.valueOf(outstandingAmountCell.getNumericCellValue());
//                            validateDto.setOutstandingAmountStatus(true);
//                            validateDto.setOutstandingAmount(outstandingAmountValue);
                            break;
                        }
                        case STRING: {
                            String sumInsuredStr = outstandingAmountCell.getStringCellValue().replaceAll(",", "");
                            try {
                                double sumInsuredDouble = Double.parseDouble(sumInsuredStr);
                                DecimalFormat df = new DecimalFormat("#");
                                String stringValue = df.format(sumInsuredDouble).trim();
//                        outstandingAmountValue = String.valueOf(sumInsuredDouble);
                                validateDto.setOutstandingAmountStatus(true);
                                validateDto.setOutstandingAmount(stringValue);
                            } catch (NumberFormatException e) {
                                // Handle parsing exception
                                validateDto.setOutstandingAmountStatus(false);
                                validateDto.setOutstandingAmountErrorMessage(
                                        "Error parsing sum insured value: " + e.getMessage());
                            }
//                            outstandingAmountValue = outstandingAmountCell.getStringCellValue();
//                            validateDto.setOutstandingAmountStatus(false);
//                            validateDto.setOutstandingAmount(outstandingAmountValue);
//                            validateDto.setOutstandingAmountErrorMessage("OutstandingAmount String");
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = outstandingAmountCell.getBooleanCellValue();
                            validateDto.setOutstandingAmount(String.valueOf(booleanCellValue).trim());
                            validateDto.setOutstandingAmountStatus(true);
//                            validateDto.setOutstandingAmountErrorMessage("OutstandingAmount Boolean Formuala :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = outstandingAmountCell.getErrorCellValue();
                            validateDto.setOutstandingAmount(String.valueOf(errorCellValue).trim());
                            validateDto.setOutstandingAmountStatus(true);
//                            validateDto.setOutstandingAmountErrorMessage("OutstandingAmount Error :: Formuala");
                            break;
                        }
                        case _NONE: {
//                            outstandingColumnIndexFlag = true;
                            validateDto.setOutstandingAmountStatus(true);
                            validateDto.setOutstandingAmount("0");
//                            validateDto.setOutstandingAmountErrorMessage("OutstandingAmount None Formuala :: ");
                            break;
                        }
                        case BLANK: {
//                            outstandingColumnIndexFlag = true;
                            validateDto.setOutstandingAmountStatus(true);
                            validateDto.setOutstandingAmount("0");
//                            validateDto.setOutstandingAmountErrorMessage("OutstandingAmount Blank Formuala :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + outstandingAmountCell.getCachedFormulaResultType());
                    }
                }
            }

            String admissionDateValue = null;
            if (dataRow.getCell(admissionDateColumnIndex) != null) {
                Cell admissionDateCell = dataRow.getCell(admissionDateColumnIndex);
                if (admissionDateCell.getCellType() == CellType.NUMERIC) {
                    admissionDateValue = String.valueOf(admissionDateCell.getDateCellValue()).trim();
                    SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                    String format = outputFormat.format(admissionDateCell.getDateCellValue());
                    validateDto.setAdmissionDateStatus(true);
                    validateDto.setAdmissionDate(format);
                } else if (admissionDateCell.getCellType() == CellType.STRING) {
                    admissionDateValue = admissionDateCell.getStringCellValue().trim();
                    validateDto.setAdmissionDateStatus(true);
                    validateDto.setAdmissionDate(admissionDateValue);
                } else if (admissionDateCell.getCellType() == CellType._NONE) {
                    admissionDateColumnIndexFlag = true;
                    validateDto.setAdmissionDateStatus(false);
                    validateDto.setAdmissionDateErrorMessage("AdmissionDate None :: ");
                } else if (admissionDateCell.getCellType() == CellType.BLANK) {
                    admissionDateColumnIndexFlag = true;
                    validateDto.setAdmissionDateStatus(false);
                    validateDto.setAdmissionDateErrorMessage("AdmissionDate Blank :: ");
                } else if (admissionDateCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = admissionDateCell.getErrorCellValue();
                    validateDto.setAdmissionDate(String.valueOf(errorCellValue).trim());
                    validateDto.setAdmissionDateStatus(false);
                    validateDto.setAdmissionDateErrorMessage("DateOfClaim Error :: ");
                } else if (admissionDateCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = admissionDateCell.getBooleanCellValue();
                    validateDto.setAdmissionDate(String.valueOf(booleanCellValue).trim());
                    validateDto.setAdmissionDateStatus(false);
                    validateDto.setAdmissionDateErrorMessage("DateOfClaim Boolean :: ");
                } else if (admissionDateCell.getCellType() == CellType.FORMULA) {
                    switch (admissionDateCell.getCellType()) {
                        case NUMERIC: {
                            admissionDateValue = String.valueOf(admissionDateCell.getDateCellValue()).trim();
                            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                            String format = outputFormat.format(admissionDateCell.getDateCellValue());
                            validateDto.setAdmissionDateStatus(true);
                            validateDto.setAdmissionDate(format);
                            break;
                        }
                        case STRING: {
                            admissionDateValue = admissionDateCell.getStringCellValue().trim();
                            validateDto.setAdmissionDateStatus(true);
                            validateDto.setAdmissionDate(admissionDateValue);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = admissionDateCell.getBooleanCellValue();
                            validateDto.setAdmissionDate(String.valueOf(booleanCellValue).trim());
                            validateDto.setAdmissionDateStatus(false);
                            validateDto.setAdmissionDateErrorMessage("AdmissionDate Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = admissionDateCell.getErrorCellValue();
                            validateDto.setAdmissionDate(String.valueOf(errorCellValue).trim());
                            validateDto.setAdmissionDateStatus(false);
                            validateDto.setAdmissionDateErrorMessage("AdmissionDate Error Formula :: ");
                            break;
                        }
                        case _NONE: {
                            admissionDateColumnIndexFlag = true;
                            validateDto.setAdmissionDateStatus(false);
                            validateDto.setAdmissionDateErrorMessage("AdmissionDate None Formula :: ");
                            break;
                        }
                        case BLANK: {
                            admissionDateColumnIndexFlag = true;
                            validateDto.setAdmissionDateStatus(false);
                            validateDto.setAdmissionDateErrorMessage("AdmissionDate Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + admissionDateCell.getCachedFormulaResultType());
                    }
                }
            }

            String dischargeDateValue = null;
            if (dataRow.getCell(dischargeDateColumnIndex) != null) {
                Cell dischargeDateCell = dataRow.getCell(dischargeDateColumnIndex);
                if (dischargeDateCell.getCellType() == CellType.NUMERIC) {
                    dischargeDateValue = String.valueOf(dischargeDateCell.getDateCellValue()).trim();
                    SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                    String format = outputFormat.format(dischargeDateCell.getDateCellValue());
                    validateDto.setDischargeDateStatus(true);
                    validateDto.setDischargeDate(format);
                } else if (dischargeDateCell.getCellType() == CellType.STRING) {
                    dischargeDateValue = dischargeDateCell.getStringCellValue().trim();
                    validateDto.setDischargeDateStatus(true);
                    validateDto.setDischargeDate(dischargeDateValue);
                } else if (dischargeDateCell.getCellType() == CellType._NONE) {
                    dischargeDateColumnIndexFlag = true;
                    validateDto.setDischargeDateStatus(false);
                    validateDto.setDischargeDateErrorMessage("DischargeDate None :: ");
                } else if (dischargeDateCell.getCellType() == CellType.BLANK) {
                    dischargeDateColumnIndexFlag = true;
                    validateDto.setDischargeDateStatus(false);
                    validateDto.setDischargeDateErrorMessage("DischargeDate Blank :: ");
                } else if (dischargeDateCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = dischargeDateCell.getErrorCellValue();
                    validateDto.setDischargeDate(String.valueOf(errorCellValue).trim());
                    validateDto.setDischargeDateStatus(false);
                    validateDto.setDischargeDateErrorMessage("DischargeDate Error :: ");
                } else if (dischargeDateCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = dischargeDateCell.getBooleanCellValue();
                    validateDto.setDischargeDate(String.valueOf(booleanCellValue).trim());
                    validateDto.setDischargeDateStatus(false);
                    validateDto.setDischargeDateErrorMessage("DischargeDate Boolean :: ");
                } else if (dischargeDateCell.getCellType() == CellType.FORMULA) {
                    switch (dischargeDateCell.getCellType()) {
                        case NUMERIC: {
                            dischargeDateValue = String.valueOf(dischargeDateCell.getDateCellValue()).trim();
                            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                            String format = outputFormat.format(dischargeDateCell.getDateCellValue());
                            validateDto.setDischargeDateStatus(true);
                            validateDto.setDischargeDate(format);
                            break;
                        }
                        case STRING: {
                            dischargeDateValue = dischargeDateCell.getStringCellValue().trim();
                            validateDto.setDischargeDateStatus(true);
                            validateDto.setDischargeDate(dischargeDateValue);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = dischargeDateCell.getBooleanCellValue();
                            validateDto.setDischargeDate(String.valueOf(booleanCellValue).trim());
                            validateDto.setDischargeDateStatus(false);
                            validateDto.setDischargeDateErrorMessage("DischargeDate Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = dischargeDateCell.getErrorCellValue();
                            validateDto.setDischargeDate(String.valueOf(errorCellValue).trim());
                            validateDto.setDischargeDateStatus(false);
                            validateDto.setDischargeDateErrorMessage("DischargeDate Error Formula :: ");
                            break;
                        }
                        case _NONE: {
                            dischargeDateColumnIndexFlag = true;
                            validateDto.setDischargeDateStatus(false);
                            validateDto.setDischargeDateErrorMessage("DischargeDate None Formula :: ");
                            break;
                        }
                        case BLANK: {
                            dischargeDateColumnIndexFlag = true;
                            validateDto.setDischargeDateStatus(false);
                            validateDto.setDischargeDateErrorMessage("DischargeDate Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + dischargeDateCell.getCachedFormulaResultType());
                    }
                }
            }

            String policyStartDateValue = null;
            if (dataRow.getCell(policyStartDateColumnIndex) != null) {
                Cell policyStartDateCell = dataRow.getCell(policyStartDateColumnIndex);
                if (policyStartDateCell.getCellType() == CellType.NUMERIC) {
                    policyStartDateValue = String.valueOf(policyStartDateCell.getDateCellValue()).trim();
                    SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                    String format = outputFormat.format(policyStartDateCell.getDateCellValue());
                    validateDto.setPolicyStartDateStatus(true);
                    validateDto.setPolicyStartDate(format);
                } else if (policyStartDateCell.getCellType() == CellType.STRING) {
                    policyStartDateValue = policyStartDateCell.getStringCellValue().trim();
                    validateDto.setPolicyStartDateStatus(true);
                    validateDto.setPolicyStartDate(admissionDateValue);
                } else if (policyStartDateCell.getCellType() == CellType._NONE) {
//                    policyStartDateColumnIndexFlag = true;
                    validateDto.setPolicyStartDateStatus(true);
//                    validateDto.setPolicyStartDateErrorMessage("PolicyStartDate None :: ");
                } else if (policyStartDateCell.getCellType() == CellType.BLANK) {
//                    policyStartDateColumnIndexFlag = true;
                    validateDto.setPolicyStartDateStatus(true);
//                    validateDto.setPolicyStartDateErrorMessage("PolicyStartDate Blank :: ");
                } else if (policyStartDateCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = policyStartDateCell.getErrorCellValue();
                    validateDto.setPolicyStartDate(String.valueOf(errorCellValue).trim());
                    validateDto.setPolicyStartDateStatus(true);
//                    validateDto.setPolicyStartDateErrorMessage("PolicyStartDate Error :: ");
                } else if (policyStartDateCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = policyStartDateCell.getBooleanCellValue();
                    validateDto.setPolicyStartDate(String.valueOf(booleanCellValue).trim());
                    validateDto.setPolicyStartDateStatus(true);
//                    validateDto.setPolicyStartDateErrorMessage("PolicyStartDate Boolean :: ");
                } else if (policyStartDateCell.getCellType() == CellType.FORMULA) {
                    switch (policyStartDateCell.getCellType()) {
                        case NUMERIC: {
                            policyStartDateValue = String.valueOf(policyStartDateCell.getDateCellValue()).trim();
                            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                            String format = outputFormat.format(policyStartDateCell.getDateCellValue());
                            validateDto.setPolicyStartDateStatus(true);
                            validateDto.setPolicyStartDate(format);
                            break;
                        }
                        case STRING: {
                            policyStartDateValue = policyStartDateCell.getStringCellValue().trim();
                            validateDto.setPolicyStartDateStatus(true);
                            validateDto.setPolicyStartDate(policyStartDateValue);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = policyStartDateCell.getBooleanCellValue();
                            validateDto.setPolicyStartDate(String.valueOf(booleanCellValue).trim());
                            validateDto.setPolicyStartDateStatus(true);
//                            validateDto.setPolicyStartDateErrorMessage("PolicyStartDate Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = policyStartDateCell.getErrorCellValue();
                            validateDto.setPolicyStartDate(String.valueOf(errorCellValue).trim());
                            validateDto.setPolicyStartDateStatus(true);
//                            validateDto.setPolicyStartDateErrorMessage("PolicyStartDate Error Formula :: ");
                            break;
                        }
                        case _NONE: {
//                            policyStartDateColumnIndexFlag = true;
                            validateDto.setPolicyStartDateStatus(true);
//                            validateDto.setPolicyStartDateErrorMessage("PolicyStartDate None Formula :: ");
                            break;
                        }
                        case BLANK: {
//                            policyStartDateColumnIndexFlag = true;
                            validateDto.setPolicyStartDateStatus(true);
//                            validateDto.setPolicyStartDateErrorMessage("PolicyStartDate Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + policyStartDateCell.getCachedFormulaResultType());
                    }
                }
            }

            String policyEndDateValue = null;
            if (dataRow.getCell(policyEndDateColumnIndex) != null) {
                Cell policyEndDateCell = dataRow.getCell(policyEndDateColumnIndex);
                if (policyEndDateCell.getCellType() == CellType.NUMERIC) {
                    policyEndDateValue = String.valueOf(policyEndDateCell.getDateCellValue()).trim();
                    SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                    String format = outputFormat.format(policyEndDateCell.getDateCellValue());
                    validateDto.setPolicyEndDateStatus(true);
                    validateDto.setPolicyEndDate(format);
                } else if (policyEndDateCell.getCellType() == CellType.STRING) {
                    policyEndDateValue = policyEndDateCell.getStringCellValue().trim();
                    validateDto.setPolicyEndDateStatus(true);
                    validateDto.setPolicyEndDate(policyEndDateValue);
                } else if (policyEndDateCell.getCellType() == CellType._NONE) {
//                    policyEndDateColumnIndexFlag = true;
                    validateDto.setPolicyEndDateStatus(true);
//                    validateDto.setPolicyEndDateErrorMessage("PolicyEndDate None :: ");
                } else if (policyEndDateCell.getCellType() == CellType.BLANK) {
//                    policyEndDateColumnIndexFlag = true;
                    validateDto.setPolicyEndDateStatus(true);
//                    validateDto.setPolicyEndDateErrorMessage("PolicyEndDate Blank :: ");
                } else if (policyEndDateCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = policyEndDateCell.getErrorCellValue();
                    validateDto.setPolicyEndDate(String.valueOf(errorCellValue).trim());
                    validateDto.setPolicyEndDateStatus(true);
//                    validateDto.setPolicyEndDateErrorMessage("PolicyEndDate Error :: ");
                } else if (policyEndDateCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = policyEndDateCell.getBooleanCellValue();
                    validateDto.setPolicyEndDate(String.valueOf(booleanCellValue).trim());
                    validateDto.setPolicyEndDateStatus(true);
//                    validateDto.setPolicyEndDateErrorMessage("PolicyEndDate Boolean :: ");
                } else if (policyEndDateCell.getCellType() == CellType.FORMULA) {
                    switch (policyEndDateCell.getCellType()) {
                        case NUMERIC: {
                            policyEndDateValue = String.valueOf(policyEndDateCell.getDateCellValue()).trim();
                            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                            String format = outputFormat.format(policyEndDateCell.getDateCellValue());
                            validateDto.setPolicyEndDateStatus(true);
                            validateDto.setPolicyEndDate(format);
                            break;
                        }
                        case STRING: {
                            policyEndDateValue = policyEndDateCell.getStringCellValue().trim();
                            validateDto.setPolicyEndDateStatus(true);
                            validateDto.setPolicyEndDate(policyEndDateValue);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = policyEndDateCell.getBooleanCellValue();
                            validateDto.setPolicyEndDate(String.valueOf(booleanCellValue).trim());
                            validateDto.setPolicyEndDateStatus(true);
//                            validateDto.setPolicyEndDateErrorMessage("PolicyEndDate Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = policyEndDateCell.getErrorCellValue();
                            validateDto.setPolicyEndDate(String.valueOf(errorCellValue).trim());
                            validateDto.setPolicyEndDateStatus(true);
//                            validateDto.setPolicyEndDateErrorMessage("PolicyEndDate Error Formula :: ");
                            break;
                        }
                        case _NONE: {
//                            policyEndDateColumnIndexFlag = true;
                            validateDto.setPolicyEndDateStatus(true);
//                            validateDto.setPolicyEndDateErrorMessage("PolicyEndDate None Formula :: ");
                            break;
                        }
                        case BLANK: {
//                            policyEndDateColumnIndexFlag = true;
                            validateDto.setPolicyEndDateStatus(true);
//                            validateDto.setPolicyEndDateErrorMessage("PolicyEndDate Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + policyEndDateCell.getCachedFormulaResultType());
                    }
                }
            }

            if (!tpaName.equals("GHPL") || !tpaName.equals("ICICI") || !tpaName.equals("MediAssist")) {
                if (dataRow.getCell(hospitalStateColumnIndex) != null) {
                    Cell hospitalStateCell = dataRow.getCell(hospitalStateColumnIndex);
                    if (hospitalStateCell.getCellType() == CellType.NUMERIC) {
                        hospitalState = String.valueOf(hospitalStateCell.getNumericCellValue()).trim();
                        validateDto.setHospitalStateStatus(false);
                        validateDto.setHospitalState(hospitalState);
                    } else if (hospitalStateCell.getCellType() == CellType.STRING) {
                        hospitalState = hospitalStateCell.getStringCellValue().trim();
                        validateDto.setHospitalStateStatus(true);
                        validateDto.setHospitalState(hospitalState);
                    } else if (hospitalStateCell.getCellType() == CellType._NONE) {
//                        hospitalStateColumnIndexFlag = true;
                        validateDto.setHospitalStateStatus(true);
//                        validateDto.setHospitalStateErrorMessage("HospitalState None :: ");
                    } else if (hospitalStateCell.getCellType() == CellType.BLANK) {
//                        hospitalStateColumnIndexFlag = true;
                        validateDto.setHospitalStateStatus(true);
//                        validateDto.setHospitalStateErrorMessage("HospitalState Blank :: ");
                    } else if (hospitalStateCell.getCellType() == CellType.ERROR) {
                        byte errorCellValue = hospitalStateCell.getErrorCellValue();
                        validateDto.setHospitalState(String.valueOf(errorCellValue).trim());
                        validateDto.setHospitalStateStatus(true);
//                        validateDto.setHospitalStateErrorMessage("HospitalState Error :: ");
                    } else if (hospitalStateCell.getCellType() == CellType.BOOLEAN) {
                        boolean booleanCellValue = hospitalStateCell.getBooleanCellValue();
                        validateDto.setHospitalState(String.valueOf(booleanCellValue).trim());
                        validateDto.setHospitalStateStatus(true);
//                        validateDto.setHospitalStateErrorMessage("HospitalState Boolean :: ");
                    } else if (hospitalStateCell.getCellType() == CellType.FORMULA) {
                        switch (hospitalStateCell.getCellType()) {
                            case NUMERIC: {
                                hospitalState = String.valueOf(hospitalStateCell.getNumericCellValue()).trim();
                                validateDto.setHospitalStateStatus(true);
                                validateDto.setHospitalState(hospitalState);
                                break;
                            }
                            case STRING: {
                                hospitalState = hospitalStateCell.getStringCellValue().trim();
                                validateDto.setHospitalStateStatus(true);
                                validateDto.setHospitalState(hospitalState);
                                break;
                            }
                            case BOOLEAN: {
                                boolean booleanCellValue = hospitalStateCell.getBooleanCellValue();
                                validateDto.setHospitalState(String.valueOf(booleanCellValue).trim());
                                validateDto.setHospitalStateStatus(true);
//                                validateDto.setHospitalStateErrorMessage("HospitalState Boolean Formula :: ");
                                break;
                            }
                            case ERROR: {
                                byte errorCellValue = hospitalStateCell.getErrorCellValue();
                                validateDto.setHospitalState(String.valueOf(errorCellValue).trim());
                                validateDto.setHospitalStateStatus(true);
//                                validateDto.setHospitalStateErrorMessage("HospitalState Error Formula :: ");
                                break;
                            }
                            case _NONE: {
//                                hospitalStateColumnIndexFlag = true;
                                validateDto.setHospitalStateStatus(true);
//                                validateDto.setHospitalStateErrorMessage("HospitalState None Formula :: ");
                                break;
                            }
                            case BLANK: {
//                                hospitalStateColumnIndexFlag = true;
                                validateDto.setHospitalStateStatus(true);
//                                validateDto.setHospitalStateErrorMessage("HospitalState Blank Formula :: ");
                                break;
                            }
                            default:
                                throw new IllegalArgumentException(
                                        "Unexpected value: " + hospitalStateCell.getCachedFormulaResultType());
                        }
                    }
                }
            }

            if (dataRow.getCell(hospitalCityColumnIndex) != null) {
                Cell hospitalCityCell = dataRow.getCell(hospitalCityColumnIndex);
                if (hospitalCityCell.getCellType() == CellType.NUMERIC) {
                    hospitalCity = String.valueOf(hospitalCityCell.getNumericCellValue()).trim();
                    validateDto.setHospitalCityStatus(false);
                    validateDto.setHospitalCity(hospitalCity);
                } else if (hospitalCityCell.getCellType() == CellType.STRING) {
                    hospitalCity = hospitalCityCell.getStringCellValue().trim();
                    validateDto.setHospitalCityStatus(true);
                    validateDto.setHospitalCity(hospitalCity);
                } else if (hospitalCityCell.getCellType() == CellType._NONE) {
//                    hospitalCityColumnIndexFlag = true;
                    validateDto.setHospitalCityStatus(true);
//                    validateDto.setHospitalCityErrorMessage("HospitalCity None :: ");
                } else if (hospitalCityCell.getCellType() == CellType.BLANK) {
//                    hospitalCityColumnIndexFlag = true;
                    validateDto.setHospitalCityStatus(true);
//                    validateDto.setHospitalCityErrorMessage("HospitalCity Blank :: ");
                } else if (hospitalCityCell.getCellType() == CellType.ERROR) {
                    byte errorCellValue = hospitalCityCell.getErrorCellValue();
                    validateDto.setHospitalCity(String.valueOf(errorCellValue).trim());
                    validateDto.setHospitalCityStatus(true);
//                    validateDto.setHospitalCityErrorMessage("HospitalCity Error :: ");
                } else if (hospitalCityCell.getCellType() == CellType.BOOLEAN) {
                    boolean booleanCellValue = hospitalCityCell.getBooleanCellValue();
                    validateDto.setHospitalCity(String.valueOf(booleanCellValue).trim());
                    validateDto.setHospitalCityStatus(true);
//                    validateDto.setHospitalCityErrorMessage("HospitalCity Boolean :: ");
                } else if (hospitalCityCell.getCellType() == CellType.FORMULA) {
                    switch (hospitalCityCell.getCellType()) {
                        case NUMERIC: {
                            hospitalCity = String.valueOf(hospitalCityCell.getNumericCellValue()).trim();
                            validateDto.setHospitalCityStatus(true);
                            validateDto.setHospitalCity(hospitalCity);
                            break;
                        }
                        case STRING: {
                            hospitalCity = hospitalCityCell.getStringCellValue().trim();
                            validateDto.setHospitalCityStatus(true);
                            validateDto.setHospitalCity(hospitalCity);
                            break;
                        }
                        case BOOLEAN: {
                            boolean booleanCellValue = hospitalCityCell.getBooleanCellValue();
                            validateDto.setHospitalCity(String.valueOf(booleanCellValue).trim());
                            validateDto.setHospitalCityStatus(true);
//                            validateDto.setHospitalCityErrorMessage("HospitalCity Boolean Formula :: ");
                            break;
                        }
                        case ERROR: {
                            byte errorCellValue = hospitalCityCell.getErrorCellValue();
                            validateDto.setHospitalCity(String.valueOf(errorCellValue).trim());
                            validateDto.setHospitalCityStatus(true);
//                            validateDto.setHospitalCityErrorMessage("HospitalCity Error Formula :: ");
                            break;
                        }
                        case _NONE: {
//                            hospitalCityColumnIndexFlag = true;
                            validateDto.setHospitalCityStatus(true);
//                            validateDto.setHospitalCityErrorMessage("HospitalCity None Formula :: ");
                            break;
                        }
                        case BLANK: {
//                            hospitalCityColumnIndexFlag = true;
                            validateDto.setHospitalCityStatus(true);
//                            validateDto.setHospitalCityErrorMessage("HospitalCity Blank Formula :: ");
                            break;
                        }
                        default:
                            throw new IllegalArgumentException(
                                    "Unexpected value: " + hospitalCityCell.getCachedFormulaResultType());
                    }
                }
            }

            if (tpaName.equals("MD India")) {
                validateDto.setNetworkTypeStatus(true);
            } else if (tpaName.equals("ICICI")) {
                validateDto.setAgeStatus(true);
                validateDto.setGenderStatus(true);
                validateDto.setNetworkTypeStatus(true);
                validateDto.setPolicyStartDateStatus(true);
                validateDto.setPolicyEndDateStatus(true);
                validateDto.setHospitalStateStatus(true);
                validateDto.setHospitalCityStatus(true);
            } else if (tpaName.equals("RCare")) {
                validateDto.setNetworkTypeStatus(true);
            } else if (tpaName.equals("Medseva")) {
                validateDto.setNetworkTypeStatus(true);
                validateDto.setSumInsuredStatus(true);
            } else if (tpaName.equals("MediAssist")) {
                validateDto.setNetworkTypeStatus(true);
                validateDto.setHospitalStateStatus(true);
            } else if (tpaName.equals("GHPL")) {
                validateDto.setNetworkTypeStatus(true);
                validateDto.setHospitalStateStatus(true);
            }

            if (!validateDto.isPolicyNumberStatus()) {
                validateDto.setRemarks("No Proper Policy Number");
            }
            if (!validateDto.isClaimsNumberStatus()) {
                validateDto.setRemarks("No Proper ClaimsNumber");
            }
            if (!validateDto.isEmployeeIdStatus()) {
                validateDto.setRemarks("No Proper EmployeeId");
            }
            if (!validateDto.isEmployeeNameStatus()) {
                validateDto.setRemarks("No Proper EmployeeName");
            }
            if (!validateDto.isAgeStatus()) {
                validateDto.setRemarks("No Proper Age");
            }
            if (!validateDto.isGenderStatus()) {
                validateDto.setRemarks("No Proper Gender");
            }
            if (!validateDto.isPatientNameStatus()) {
                validateDto.setRemarks("No Proper PatientName");
            }
            if (!validateDto.isRelationshipStatus()) {
                validateDto.setRemarks("No Proper Relationship");
            }
            if (!validateDto.isClaimStatus()) {
                validateDto.setRemarks("No Proper claim status");
            }
            if (!validateDto.isDateOfClaimStatus()) {
                validateDto.setRemarks("No Proper DateOfClaim");
            }
            if (!validateDto.isClaimTypeStatus()) {
                validateDto.setRemarks("No Proper ClaimType");
            }
            if (!validateDto.isAdmissionDateStatus()) {
                validateDto.setRemarks("No Proper AdmitDate");
            }
            if (!validateDto.isDischargeDateStatus()) {
                validateDto.setRemarks("No Proper DischargeDate");
            }
            if (!validateDto.isMemberCodeStatus()) {
                validateDto.setRemarks("No Proper MemberCode");
            }

//            if (!validateDto.isDiseaseStatus()) {
//                validateDto.setRemarks("No Proper Disease");
//            }

            if (!validateDto.isSumInsuredStatus()) {
                validateDto.setSumInsured("0");
                validateDto.setSumInsuredStatus(true);
            }

            if (!validateDto.isClaimedAmountStatus()) {
                validateDto.setClaimedAmount("0");
                validateDto.setClaimedAmountStatus(true);
            }

            if (!validateDto.isPaidAmountStatus()) {
                validateDto.setPaidAmount("0");
                validateDto.setPaidAmountStatus(true);
            }
            if (!validateDto.isOutstandingAmountStatus()) {
                validateDto.setOutstandingAmount("0");
                validateDto.setOutstandingAmountStatus(true);
            }

            if (validateDto.isPolicyNumberStatus() && validateDto.isClaimsNumberStatus()
                    && validateDto.isEmployeeIdStatus() && validateDto.isEmployeeNameStatus()
                    && validateDto.isGenderStatus() && validateDto.isRelationshipStatus()
                    && validateDto.isPatientNameStatus() && validateDto.isAgeStatus() && validateDto.isDiseaseStatus()
                    && validateDto.isDateOfClaimStatus() && validateDto.isSumInsuredStatus()
                    && validateDto.isClaimedAmountStatus() && validateDto.isPaidAmountStatus()
                    && validateDto.isOutstandingAmountStatus() && validateDto.isClaimTypeStatus()
                    && validateDto.isNetworkTypeStatus() && validateDto.isHospitalNameStatus()
                    && validateDto.isMemberCodeStatus() && validateDto.isPolicyStartDateStatus()
                    && validateDto.isPolicyEndDateStatus() && validateDto.isHospitalStateStatus()
                    && validateDto.isHospitalCityStatus() && validateDto.isAdmissionDateStatus()
                    && validateDto.isDischargeDateStatus() && validateDto.isClaimStatus()) {

                validateDto.setStatus(true);
            }

            if (policyNumberColumnIndexFlag && claimsNumberColumnIndexFlag && employeeIdColumnIndexFlag
                    && employeeNameColumnIndexFlag && relationshipColumnIndexFlag && genderColumnIndexFlag
                    && ageColumnIndexFlag && patientNameColumnIndexFlag && sumInsuredColumnIndexFlag
                    && claimedAmountColumnIndexFlag && paidAmountColumnIndexFlag && outstandingColumnIndexFlag
                    && claimStatusColumnIndexFlag && dateOfClaimColumnIndexFlag && claimTypeColumnIndexFlag
                    && networkTypeColumnIndexFlag && hospitalNameColumnIndexFlag && admissionDateColumnIndexFlag
                    && dischargeDateColumnIndexFlag && diseaseColumnIndexFlag && memberCodeColumnIndexFlag
                    && policyStartDateColumnIndexFlag && policyEndDateColumnIndexFlag && hospitalStateColumnIndexFlag
                    && hospitalCityColumnIndexFlag) {
                log.info("Blank Row");
            } else {
                claimsMisValidateData.add(validateDto);
            }

        }
    }

    public String uploadFileCoverage(ClientDetailsClaimsMisUploadDto coverageUploadDto, Long clientlistId, Long productId) {

        ClientDetailsClaimsMis clientDetailsClaimsMis = new ClientDetailsClaimsMis();

        log.info("product id is : {} ", productId , " clientid is : {}  ", clientlistId);
        // ClientDetailsClaimsMis uploadEntity = new ClientDetailsClaimsMis();
        String fileName = coverageUploadDto.getFile().getOriginalFilename().replace(" ", "");


        if (coverageUploadDto.getFileType().equals("ClaimsMis")) {



            List<ClientDetailsClaimsMis> claimsMisData = excelUtils.storeClaimsMisANDfile1(coverageUploadDto.getFile(),
                    coverageUploadDto.getFileType(), coverageUploadDto.getTpaName());
            for (ClientDetailsClaimsMis clientDetailsClaimsMis1 : claimsMisData) {
                if (clientlistId != null) {
                    try {
                        ClientList clientList = clientListRepository.findById(clientlistId)
                                .orElseThrow(() -> new InvalidClientList("ClientList is not Found"));
                        clientDetailsClaimsMis1.setClientList(clientList);
                        clientDetailsClaimsMis1.setRfqId(clientList.getRfqId());
                    } catch (InvalidClientList e) {
//                errorMessages.append("ClientList is not Found with Id : ").append(clientListId).append(" . ");
                    }
                }
                if (productId != null) {
                    try {
                        Product product = productRepository.findById(productId)
                                .orElseThrow(() -> new InvalidProduct("Product is not Found"));
                        clientDetailsClaimsMis1.setProduct(product);
                    } catch (InvalidProduct e) {
//                errorMessages.append("Product is not Found with Id : ").append(productId).append(" . ");
                    }
                }

            }

            log.error("	@Slf4j :{}", claimsMisData);
            List<ClientDetailsClaimsMis> saveAll = clientDetailsClaimsMisRepository.saveAll(claimsMisData);
            List<ClientDetailsClaimsMis> findByRfqId = clientDetailsClaimsMisRepository.findByRfqId(saveAll.stream().map(ClientDetailsClaimsMis::getRfqId).distinct().toString());
//            if (!findByRfqId.isEmpty()) {
//                for (ClientDetailsClaimsMis claimsMisEntity : findByRfqId) {
//                    //claimsMisRepo.hardDeleteByRfqId(claimsMisEntity.getRfqId());
//                }
//            }

//			System.out.println("------  ClaimsMis ----------");
            File folder = new File(mainpath);
            File ClaimsMisDest = new File(folder.getAbsolutePath(),
                    "ClaimsMis" + RandomStringUtils.random(10, true, false) + fileName);
            if (!coverageUploadDto.getFile().isEmpty() && !ClaimsMisDest.exists()) {
                System.out.println("------  file Upload ----------");
                try {
                    coverageUploadDto.getFile().transferTo(ClaimsMisDest);
                    // Create a FileInputStream to read the file
                    FileInputStream fileInputStream = new FileInputStream(ClaimsMisDest.getAbsolutePath());

                    // Create a ByteArrayOutputStream to store the bytes
                    ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

                    // Read data from the file and write it to the ByteArrayOutputStream
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                        byteArrayOutputStream.write(buffer, 0, bytesRead);
                    }

                    // Close the streams
                    fileInputStream.close();
                    byteArrayOutputStream.close();

                    // Get the byte array
                    byte[] byteArray = byteArrayOutputStream.toByteArray();


                    return ClaimsMisDest.getAbsolutePath();
                } catch (IllegalStateException | IOException e) {
                    e.printStackTrace();
                }

            } else {
                System.out.println("------  file not Upload  ----------");
                log.info(coverageUploadDto.getFile().getOriginalFilename() + " already exists !!");
            }
        }


        return null;

    }

}