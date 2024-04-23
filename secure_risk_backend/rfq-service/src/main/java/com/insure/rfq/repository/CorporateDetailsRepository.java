package com.insure.rfq.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.insure.rfq.entity.CorporateDetailsEntity;

@Repository
public interface CorporateDetailsRepository extends JpaRepository<CorporateDetailsEntity, Long> {

	Optional<CorporateDetailsEntity> findByRfqId(String rfqId);
//	@Modifying
//	@Transactional
//	@Query(value = "UPDATE rfq_m SET application_status = 'SUBMITTED' WHERE rfq_id = :rId", nativeQuery = true)  //using native query
//	@Query("UPDATE RFQEntity SET appStatus = 'SUBMITTED' WHERE rfqId = :rId") //using HQL
//    void updateStatusFromPendingToSubmitted(@Param("rId") String rfqId);

	@Query("SELECT rfqId FROM CorporateDetailsEntity WHERE prodCategoryId = :prodCategoryId AND productId = :productId")
	List<String> getRFQIdBasedOnProductandProductCategory(@Param("prodCategoryId") Long prodCategoryId,
			@Param("productId") Long productId);

//	@Query(value = "SELECT SUM(CASE WHEN application_status LIKE %:status% THEN 1 ELSE 0 END) AS count FROM corporate_details", nativeQuery = true)
//	Long countApplicationsByStatus(@Param("status") String status);

	@Query(value = "SELECT COALESCE(status.status_name, 'Total') AS application_status, COALESCE(COUNT(corporate_details.application_status), 0) AS count FROM (SELECT 'Closed' AS status_name   UNION SELECT 'Pending'  UNION SELECT 'Processing' UNION SELECT 'Submitted') AS status LEFT JOIN corporate_details ON status.status_name = corporate_details.application_status GROUP BY GROUPING SETS ((status.status_name), ());", nativeQuery = true)
	List<Object[]> countApplicationsByStatus();

	@Query(value = "SELECT COALESCE(status.status_name, 'Total') AS application_status, COALESCE(COUNT(corporate_details.application_status), 0) AS count \n" +
			"FROM (\n" +
			"    SELECT 'Closed' AS status_name   \n" +
			"    UNION SELECT 'Pending'  \n" +
			"    UNION SELECT 'Processing' \n" +
			"    UNION SELECT 'Submitted'\n" +
			"    UNION SELECT 'Lost' \n" +
			") AS status \n" +
			"LEFT JOIN corporate_details ON status.status_name = corporate_details.application_status \n" +
			"GROUP BY GROUPING SETS ((status.status_name), ());", nativeQuery = true)
	List<Object[]> monthcountApplicationsByStatus();

}
