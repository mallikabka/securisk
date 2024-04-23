package com.insure.rfq.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.insure.rfq.entity.ClaimsDetails;
import com.insure.rfq.entity.ExpiryPolicyDetails;

@Repository
public interface ClaimsDetailsRepository extends JpaRepository<ClaimsDetails, Long> {

	Optional<ClaimsDetails> findByrfqId(String rfqId);

}
