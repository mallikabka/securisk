package com.insure.rfq.controller;

import com.insure.rfq.dto.*;
import com.insure.rfq.service.InsurerBankDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/clientlist/insurerBankDetails")
@CrossOrigin(origins = "*")
public class InsurerBankDetailsController {

    @Autowired
    private InsurerBankDetailsService insurerBankDetailsService;

    @PostMapping("/createInsurer")
    public ResponseEntity<?> createInsurer(@RequestBody InsurerBankDetailsDto insurerBankDetailsDto,@RequestParam("clientListId") Long clientListId, @RequestParam("productId") Long productId){
        try{
            ResponseDto responseDto=insurerBankDetailsService.createInsurerBank(insurerBankDetailsDto,clientListId,productId);
            return new ResponseEntity<>(responseDto, HttpStatus.CREATED);

        }catch (Exception e){
            ResponseDto responseDto1 = new ResponseDto(e.getMessage());
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body(e.getMessage());
        }
    }
    @GetMapping("/getAllInsurer")
    @ResponseStatus(HttpStatus.OK)

    public ResponseEntity<?> getAllEndorsements(
            @RequestParam("clientListId") Long clientListId,
            @RequestParam("productId") Long productId) {

        try {
            List<DisplayAllInsurerDetails> allInsurerDetails = insurerBankDetailsService.getAllInsurerDetails(clientListId, productId);
            return ResponseEntity.ok(allInsurerDetails);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body( e.getMessage());
        }
    }


    @DeleteMapping("/deleteInsurer/{insurerId}")
    @ResponseStatus(HttpStatus.OK)
    public String deleteInsurerBank(@PathVariable Long insurerId) {
        return insurerBankDetailsService.deleteInsurer(insurerId);
    }


@GetMapping("/insurerBankDetailsExport")
@ResponseStatus(HttpStatus.OK)
    public ResponseEntity<byte[]> getAllMembersDetailsByExcelFormatByClientListProduct(

            @RequestParam Long clientListId, @RequestParam Long productId) {

        byte[] excelData = insurerBankDetailsService.generateExcelFromData(clientListId, productId);

        HttpHeaders headers = new HttpHeaders();

        headers.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));

        headers.setContentDispositionFormData("attachment", "Insurer_Bank_Details.xlsx");

        return new ResponseEntity<>(excelData, headers, HttpStatus.OK);

    }


    @GetMapping("/getByIdInsurer")
    @ResponseStatus(HttpStatus.OK)
    public DisplayAllInsurerDetails getById(@RequestParam Long insurerId){
        return insurerBankDetailsService.getById(insurerId);

    }

    @PutMapping("/updateInsurer/{insurerId}")
    @ResponseStatus(HttpStatus.OK)
    public String updateEndorsement(@RequestBody UpdateInsurerBankDetailsDto dto, @PathVariable Long insurerId) {
        System.out.println(insurerId);
        return insurerBankDetailsService.updateInsurerById(dto, insurerId);

    }

}
