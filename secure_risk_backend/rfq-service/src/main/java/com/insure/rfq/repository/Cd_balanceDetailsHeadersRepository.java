package com.insure.rfq.repository;

import com.insure.rfq.entity.Cd_balanceHeadersMappingEntity;
import com.insure.rfq.entity.ClientListEnrollementHeadersMappingEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface Cd_balanceDetailsHeadersRepository extends JpaRepository<Cd_balanceHeadersMappingEntity,Long> {



}