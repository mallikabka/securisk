package com.insure.rfq.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.insure.rfq.entity.PolicyType;

public interface PolicyTypeRepository extends JpaRepository<PolicyType, Integer> {

	
}
