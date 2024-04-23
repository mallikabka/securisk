package com.insure.rfq.repository;

import java.util.List;
import java.util.Map;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.insure.rfq.entity.ExcelReportHeadersMapping;

@Repository
public interface ExcelReportHeadersMappingRepository extends JpaRepository<ExcelReportHeadersMapping, Long> {
	List<ExcelReportHeadersMapping> findByAliasName(String aliasname);
	
//	@Query("SELECT e.aliasName as aliasName, e.reportHeaders as reportHeaders  FROM ExcelReportHeadersMapping e where e.reportHeaders.headerId=:id")
//	List<Map<String,Object>> getBasedOnHeaderId(@Param("id") Long id);
	
	@Query("SELECT e FROM ExcelReportHeadersMapping e where e.reportHeaders.headerId=:id")
	List<ExcelReportHeadersMapping> getBasedOnHeaderId(@Param("id") Long id);
}
