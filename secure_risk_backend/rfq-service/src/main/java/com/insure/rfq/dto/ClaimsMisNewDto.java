package com.insure.rfq.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.Column;
import lombok.Data;

import java.util.Date;

@Data
public class ClaimsMisNewDto {

    private String PolicyNumber;
    private String claimsNumber;
    private String employeeId;
    private String employeeName;
    private String relationship;
    private String gender;

    private int age;

    private String patientName;

    private double sumInsured;

    private double claimedAmount;

    private double paidAmount;

    private double outstandingAmount;

    private String claimStatus;

    private Date dateOfClaim;

    private String claimType;

    private String networkType;

    private String hospitalName;

    private Date admissionDate;

    private String disease;

    private Date dateOfDischarge;

    private String memberCode;

    private Date policyStartDate;

    private Date policyEndDate;

    private String hospitalState;

    private String hospitalCity;

    @JsonIgnore
    private Date createDate;

    @JsonIgnore
    private Date updateDate;

    @JsonIgnore
    private String recordStatus;


}

