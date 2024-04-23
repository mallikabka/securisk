package com.insure.rfq.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.insure.rfq.dto.TemplateDto;
import com.insure.rfq.entity.TemplateDetails;

public interface TemplateRepositry extends JpaRepository<TemplateDetails, Long> {

	List<TemplateDetails> findByTemplateType(String type);

	List<TemplateDetails> findByType(String type);

	 @Query("SELECT t FROM TemplateDetails t WHERE t.product.productId = :productId")
	    List<TemplateDetails> findByProductId(Long productId);

}
