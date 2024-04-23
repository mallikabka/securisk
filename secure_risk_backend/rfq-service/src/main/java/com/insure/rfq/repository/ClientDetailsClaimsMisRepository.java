package com.insure.rfq.repository;

import com.insure.rfq.entity.ClaimsMisEntity;
import com.insure.rfq.entity.ClientDetailsClaimsMis;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ClientDetailsClaimsMisRepository extends JpaRepository<ClientDetailsClaimsMis,Long> {

    @Query
    List<ClientDetailsClaimsMis> findByRfqId( String rfqId);

    @Query("SELECT c FROM ClientDetailsClaimsMis c WHERE c.rfqId=:rfqId ")
    List<ClientDetailsClaimsMis> getClaimsDetailsAfterUpload(@Param("rfqId") String rfqId);
}
