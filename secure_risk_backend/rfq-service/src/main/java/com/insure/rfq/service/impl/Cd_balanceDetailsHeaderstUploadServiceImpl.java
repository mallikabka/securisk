package com.insure.rfq.service.impl;

import com.insure.rfq.dto.Cd_balanceDetailsHeadersDto;
import com.insure.rfq.dto.Cd_balanceDisplayDto;
import com.insure.rfq.dto.Cd_balanceHeaderMappingDto;
import com.insure.rfq.dto.Cd_balanceHeaderStatusDto;
import com.insure.rfq.entity.*;
import com.insure.rfq.exception.InvalidClientList;
import com.insure.rfq.exception.InvalidProduct;
import com.insure.rfq.repository.Cd_balanceDetailsHeadersRepository;
import com.insure.rfq.repository.Cd_balanceEntityRepository;
import com.insure.rfq.repository.ClientListRepository;
import com.insure.rfq.repository.ProductRepository;
import com.insure.rfq.service.Cd_balanceHeaderUploadService;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class Cd_balanceDetailsHeaderstUploadServiceImpl implements Cd_balanceHeaderUploadService {

    @Autowired
    private Cd_balanceDetailsHeadersRepository cd_balanceDetailsHeadersDtoRepository;
    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private ClientListRepository clientListRepository;

    @Autowired
    private Cd_balanceEntityRepository entityRepository;

    @Override
    public Cd_balanceHeaderMappingDto uploadEnrollement(Cd_balanceHeaderMappingDto cd_balanceHeaderMappingDto) {
        if (cd_balanceHeaderMappingDto != null && cd_balanceHeaderMappingDto.getHeaders() != null) {
            List<Cd_balanceDetailsHeadersDto> headersDtoList = cd_balanceHeaderMappingDto.getHeaders();
            List<Cd_balanceDetailsHeadersDto> savedDtos = new ArrayList<>();

            for (Cd_balanceDetailsHeadersDto headerDto : headersDtoList) {
                Cd_balanceHeadersMappingEntity mappingEntity = new Cd_balanceHeadersMappingEntity();
                mappingEntity.setHeaderAliasName(headerDto.getHeaderAliasName());
                mappingEntity.setHeaderName(headerDto.getHeaderName());
                mappingEntity.setSheetName(headerDto.getSheetName());
                mappingEntity.setSheetId(cd_balanceHeaderMappingDto.getSheetId());
                Cd_balanceHeadersMappingEntity savedEntity = cd_balanceDetailsHeadersDtoRepository.save(mappingEntity);

                Cd_balanceDetailsHeadersDto savedDto = new Cd_balanceDetailsHeadersDto();
                savedDto.setHeaderAliasName(savedEntity.getHeaderAliasName());
                savedDto.setHeaderName(savedEntity.getHeaderName());
                savedDto.setSheetName(savedEntity.getSheetName());

                savedDtos.add(savedDto);
            }

            return new Cd_balanceHeaderMappingDto(cd_balanceHeaderMappingDto.getSheetId(), savedDtos);
        }

        return null;
    }

    @Override
    public Cd_balanceHeaderStatusDto validateHeaders(MultipartFile multipartFile) {
        try {
            Workbook workbook = WorkbookFactory.create(multipartFile.getInputStream());
            Cd_balanceHeaderStatusDto cdBalanceHeaderStatusDto = new Cd_balanceHeaderStatusDto();

            Sheet sheet = workbook.getSheetAt(0); // Assuming the first sheet
            Iterator<Row> rowIterator = sheet.iterator();
            // Assuming the first row contains the column names
            Row headerRow = rowIterator.next();

            // Logging headers and their indexes
            log.info("Headers from Excel:");
            List<String> headerList = new ArrayList<>();
            for (int index = 0; index < headerRow.getPhysicalNumberOfCells(); index++) {
                Cell cell = headerRow.getCell(index);
                // Check if the cell is null (empty)
                if (cell == null) {
                    log.info("Skipped empty cell at index: {}", index);
                    continue;
                }
                // Check if the cell is part of a merged region
                if (isMergedCell(sheet, cell)) {
                    log.info("Skipped merged cell at index: {}", index);
                    continue;
                }
                String columnName = cell.getStringCellValue().trim(); // Convert to lowercase for case-insensitive matching
                headerList.add(columnName);
                log.info("Index: {}, Header: {}", index, columnName);
            }

            // Populate Cd_balanceHeaderStatusDto based on the headers found
            for (String header : headerList) {
                switch (header) {
                    case "Policy Number":
                    case "Policy/End No":
                        cdBalanceHeaderStatusDto.setPolicyNumber(true);
                        break;
                    case "Transaction Type":
                        cdBalanceHeaderStatusDto.setTransactionType(true);
                        break;
                    case "Payment Date":
                        cdBalanceHeaderStatusDto.setPaymentDate(true);
                        break;
                    case "Amount":
                        cdBalanceHeaderStatusDto.setAmount(true);
                        break;
                    case "CR/DB/CD":
                    case "Cr":
                    case "Dr":
                    case "DB/CD":
                        cdBalanceHeaderStatusDto.setCR_DB_CD(true);
                        break;
                    case "Balance":
                        cdBalanceHeaderStatusDto.setBalance(true);
                        break;
                    default:
                }
            }

            return cdBalanceHeaderStatusDto;
        } catch (IOException e) {
            log.error("Error occurred while processing the file: {}", e.getMessage());
        }

        return null;
    }

    private Workbook getWorkbook(MultipartFile file) throws IOException {
        String fileName = file.getOriginalFilename();

        if (fileName != null && (fileName.endsWith(".xlsx") || fileName.endsWith(".XLSX") || fileName.endsWith(".xlsb")
                || fileName.endsWith(".XLSB"))) {
            // Handle XLSX
            return new XSSFWorkbook(file.getInputStream());
        } else if (fileName != null && (fileName.endsWith(".xls") || fileName.endsWith(".XLS"))) {

            // Handle XLS
            return new HSSFWorkbook(file.getInputStream());
        } else {
            // Throw an exception or handle the unsupported file format
            throw new IllegalArgumentException("Unsupported file format: " + fileName);
        }
    }

    private boolean isMergedCell(Sheet sheet, Cell cell) {
        for (int i = 0; i < sheet.getNumMergedRegions(); i++) {
            CellRangeAddress mergedRegion = sheet.getMergedRegion(i);
            if (mergedRegion.isInRange(cell.getRowIndex(), cell.getColumnIndex())) {
                return true;
            }
        }
        return false;
    }

    private boolean containsMergedCells(Sheet sheet, Row row) {
        for (int colIndex = row.getFirstCellNum(); colIndex < row.getLastCellNum(); colIndex++) {
            Cell cell = row.getCell(colIndex);
            if (cell != null && isMergedCell(sheet, cell)) {
                return true; // Row contains merged cells
            }
        }
        return false; // Row does not contain merged cells
    }

    private String getCellValueAsString(Cell cell) {
        if (cell == null) {
            return ""; // Return empty string for null cells
        }

        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                // Check if the cell contains a date value
                if (DateUtil.isCellDateFormatted(cell)) {
                    // Format date value and return as string
                    return cell.getDateCellValue().toString();
                } else {
                    // Format numeric value and return as string
                    return String.valueOf(cell.getNumericCellValue());
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                // Evaluate formula cell and return the calculated value as string
                return String.valueOf(cell.getNumericCellValue()); // For simplicity, assuming formula results in a numeric value
            default:
                return ""; // Return empty string for unsupported cell types
        }
    }

    private boolean isRowEmpty(Row row) {
        if (row == null) {
            return true;
        }
        for (Cell cell : row) {
            if (cell != null && cell.getCellType() != CellType.BLANK) {
                return false; // If any cell is not empty, return false
            }
        }
        return true; // All cells are empty
    }


    @Override
    public List<Cd_balanceDisplayDto> getDataformFile(Long clientID, Long productId) {
        return entityRepository.findAll().stream()
                .map(entity -> new Cd_balanceDisplayDto(
                        entity.getPolicyNumber(),
                        entity.getTransactionType(),
                        entity.getPaymentDate(),
                        entity.getAmount(),
                        entity.getCR_DB_CD(),
                        entity.getBalance()
                ))
                .collect(Collectors.toList());
    }

    public String saveData(MultipartFile file, Long clientID, Long productId) {
        List<Cd_balanceEntitytable> dataList = new ArrayList<>();

        String message = "";
        try {
            Workbook workbook = getWorkbook(file);
            Sheet sheet = workbook.getSheetAt(0);
            Row headerRow = sheet.getRow(0);
            List<String> validHeaders = cd_balanceDetailsHeadersDtoRepository.findAll()
                    .stream().map(i -> i.getHeaderAliasName()).toList();


            for (int index = 0; index < headerRow.getPhysicalNumberOfCells(); index++) {
                Cell cell = headerRow.getCell(index);
                if (cell == null) {
                    continue;
                }
                String headerName = cell.getStringCellValue().trim();
                if (validHeaders.contains(headerName)) {
                    // Loop through each row to read data
                    for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
                        Row dataRow = sheet.getRow(rowIndex);
                        if (dataRow == null) {
                            continue;
                        }

                        Cd_balanceEntitytable entity = new Cd_balanceEntitytable();
                        if (productId != null) {
                            Product product = productRepository.findById(productId)
                                    .orElseThrow(() -> new InvalidProduct("Product is Not Found"));
                            entity.setProductId(product);

                        }
                        if (clientID != null) {
                            ClientList clientList = clientListRepository.findById(clientID)
                                    .orElseThrow(() -> new InvalidClientList("ClientList is Not Found"));
                            entity.setClientListId(clientList);
                            entity.setRfqId(clientList.getRfqId());

                        }
                        entity.setRecordStatus("ACTIVE");
                        entity.setCreatedDate(new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new Date()));
                        for (int cellIndex = 0; cellIndex < headerRow.getPhysicalNumberOfCells(); cellIndex++) {
                            Cell dataCell = dataRow.getCell(cellIndex);
                            if (dataCell == null) {
                                continue;
                            }
                            String value = "";
                            switch (dataCell.getCellType()) {
                                case NUMERIC:
                                    if (DateUtil.isCellDateFormatted(dataCell)) {
                                        value = dataCell.getDateCellValue().toString();
                                    } else {
                                        value = String.valueOf(dataCell.getNumericCellValue());
                                    }
                                    break;
                                case STRING:
                                    value = dataCell.getStringCellValue();
                                    break;
                                default:
                                    value = "N/A";
                            }

                            String currentHeaderName = headerRow.getCell(cellIndex).getStringCellValue().trim();
                            switch (currentHeaderName) {
                                case "Policy No":
                                case "Policy/End No":
                                case "PolicyNo":
                                case "Account no":
                                    entity.setPolicyNumber(value != null ? value : "N/A");
                                    break;
                                case "Trans Type":
                                case "Transaction Type":
                                    entity.setTransactionType(value);
                                    break;
                                case "Payment Date":
                                case "Trans Date":
                                case "TransactionDate":
                                    entity.setPaymentDate(value);
                                    break;
                                case "Credit Amount":
                                case "Amount":
                                    entity.setAmount(Double.valueOf(value));
                                    break;
                                case "Closing Balance":
                                case "Balance":
                                case "Available Balance":
                                    entity.setBalance(Double.valueOf(value));
                                    break;
                                case "Cr":
                                case "CR / DR":
                                case "Dr Cr":
                                    entity.setCR_DB_CD(value);
                                    break;
                                default:
                                    // Handle additional headers if needed
                            }
                        }
                        // Set other entity properties like rfqId, createdDate, updatedDate, recordStatus
                        // Save the entity to the database
                        entityRepository.save(entity);


                        message = "File is saved successfully";
                    }
                }
            }
        } catch (IOException e) {
            log.error("Error occurred while processing the file: {}", e.getMessage());
            message = "Error occurred while processing the file: " + e.getMessage();
        }

        return message;
    }

    public byte[] generateExcelFromData(Long clientListId, Long productId) {
        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("CD_balance");

            String[] headers = {"Policy Number",
                    "Transaction Type",
                    "Payment Date",
                    "Amount",
                    "Balance"};
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                headerRow.createCell(i).setCellValue(headers[i]);
            }
/*
  stream().filter(filter -> filter.getRecordStatus().equalsIgnoreCase("ACTIVE"))
                .filter(client -> clientListId != null && client.
                        getClientListId().getCid() == clientListId)
                .filter(c -> productId != null && c.getProductId().getProductId().equals(productId)).toList();
 */
            List<Cd_balanceEntitytable> active = entityRepository.findAll().stream()
                    .filter(entity -> entity.getRecordStatus().equalsIgnoreCase("ACTIVE"))
                    .filter(client -> clientListId != null && client.
                            getClientListId().getCid() == clientListId)
                    .filter(c -> productId != null && c.getProductId().getProductId().equals(productId)).toList();
log.info("The list"+active);
            int rowNum = 1;
            for (Cd_balanceEntitytable entity : active) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(entity.getPolicyNumber());
                row.createCell(1).setCellValue(entity.getTransactionType());
                row.createCell(2).setCellValue(entity.getPaymentDate());
                row.createCell(3).setCellValue(entity.getAmount());
                row.createCell(4).setCellValue(entity.getCR_DB_CD());
                row.createCell(5).setCellValue(entity.getBalance());
            }

            workbook.write(out);
            return out.toByteArray();
        } catch (IOException e) {
            e.printStackTrace();
            return new byte[0];
        }
    }

}


