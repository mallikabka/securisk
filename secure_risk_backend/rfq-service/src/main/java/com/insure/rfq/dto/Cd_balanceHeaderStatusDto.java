package com.insure.rfq.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Cd_balanceHeaderStatusDto {

    private Boolean policyNumber;
    private Boolean transactionType;
    private Boolean paymentDate;
    private Boolean amount;
    private Boolean CR_DB_CD;
    private Boolean Balance;
}
