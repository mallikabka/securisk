package com.insure.rfq.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.insure.rfq.entity.ClaimAnalysisReport;

public interface ClaimAnalysisReportRepository extends JpaRepository<ClaimAnalysisReport,Long>{
	

	
//	// Member wise Analysis Queries
//	@Query("SELECT COUNT(c.id)  FROM  ClaimAnalysisReport c  WHERE c.relationShip= :relation AND c.rfqId= :id ")
//	int getCountOfMemeberBasedOnRelation(@Param("relation") String relation, @Param("id") String id);
//	
//	@Query("SELECT COUNT(c.id)  FROM  ClaimAnalysisReport c  WHERE c.relationShip <> :relation AND  c.rfqId= :id")
//	int getCountOfMemeberTypeIsNotSelf(@Param("relation") String relation, @Param("id") String id);
//	
//	@Query("SELECT SUM(c.sumInsured)  FROM  ClaimAnalysisReport c  WHERE c.relationShip <> :relation  AND  c.rfqId= :id")
//	int getAmountDepent(@Param("relation") String relation, @Param("id") String id);
//	
//	@Query("SELECT SUM(c.sumInsured)  FROM  ClaimAnalysisReport c  WHERE c.relationShip = :relation  AND  c.rfqId= :id")
//	int getAmountOfMember(@Param("relation") String relation, @Param("id") String id);
//     @Query("SELECT c.relationShip FROM ClaimAnalysisReport c ")
//	  List<String>getAllRelation();
//     // Relation Wise Analysis
//     @Query("SELECT c.relationShip FROM ClaimAnalysisReport c ")
//     Set<String>getAllRelationData();
//
//	// Gender wise Claim Analysis Report Queries
//     @Query("SELECT c.gender FROM ClaimAnalysisReport c ")
//	   Set<String>getAllGenderDetails();
//	@Query("SELECT COUNT(c.id)  FROM  ClaimAnalysisReport c  WHERE c.gender=:gender AND c.rfqId= :id ")
//	int getCountOfGenderWise(@Param("gender")String gender ,@Param("id") String id);
//	
//	@Query("SELECT (COUNT(ci.id) * 100.0) / (SELECT COUNT(c.id) FROM ClaimAnalysisReport c) "
//		    + "FROM ClaimAnalysisReport ci "
//		    + "WHERE ci.gender = :gender AND ci.rfqId = :id")
//	double getPercentageOfGenderWiseCount(@Param("gender")String gender ,@Param("id") String id);
//	
//	@Query("SELECT SUM(c.sumInsured)   FROM  ClaimAnalysisReport c  WHERE c.gender= :gender  AND  c.rfqId= :id ")
//	double getGenderWiseAmountSum(@Param("gender")String gender ,@Param("id") String id);
//	
//	@Query("SELECT (SUM(ci.sumInsured) * 100.0) / (SELECT SUM(c.sumInsured) FROM ClaimAnalysisReport c) "
//		    + "FROM ClaimAnalysisReport ci "
//		    + "WHERE ci.gender = :gender AND ci.rfqId = :id")
//	double getPercentageOfGenderAmountPerct(@Param("gender")String gender ,@Param("id") String id);
//	@Query("SELECT SUM(c.sumInsured)   FROM  ClaimAnalysisReport c ")
//	double getTotalAmount(@Param("id") String id);
//	
//	@Query("SELECT COUNT(c.id)   FROM  ClaimAnalysisReport c ")
//	int getTotalCount(@Param("id") String id);
//	
//	// Age Wise Claim Analysis 
//	@Query("SELECT COUNT(c.id) FROM ClaimAnalysisReport c WHERE c.age BETWEEN :start AND :end AND  c.rfqId= :id")
//	int getCountOfMemberBasedOnAge(@Param("start")int start, @Param("end")int end ,@Param("id") String id);
//	@Query("SELECT COUNT(c.id) FROM ClaimAnalysisReport c WHERE c.age > 70 AND  c.rfqId= :id")
//	int getCountOfMemberBasedAgeMoreThan70( @Param("id") String id);
//	@Query("SELECT SUM(c.sumInsured) FROM ClaimAnalysisReport c WHERE c.age BETWEEN :start AND :end AND  c.rfqId= :id")
//	double getAmountOfMemberBasedOnAge(@Param("start")int start, @Param("end")int end ,@Param("id") String id);
//	@Query("SELECT SUM(c.sumInsured) FROM ClaimAnalysisReport c WHERE c.age>70 AND  c.rfqId= :id")
//	double getAmountOfMemberAgeMoreThan70(@Param("id") String id);
//	
//	//Claim Type Analysis 
//	@Query("SELECT c.claimType   FROM ClaimAnalysisReport c  WHERE c.rfqId= :id ")
//	Set<String>getAllClaimType(@Param("id")String id);
//	@Query("SELECT COUNT(c.id) FROM ClaimAnalysisReport c  WHERE c.rfqId= :id AND  c.claimType= :claimType")
//	int getCountBasedOnClaimType(@Param("claimType") String claimType,@Param("id")String id);
//	@Query("SELECT SUM(c.sumInsured) FROM ClaimAnalysisReport c  WHERE c.rfqId= :id AND  c.claimType= :claimType")
//	double getAmountBasedOnClaimType(@Param("claimType") String claimType,@Param("id")String id);
//	
//	// Incurred Claim report 
//	@Query("SELECT c.status FROM ClaimAnalysisReport c  WHERE c.rfqId= :id")
//	Set<String>getAllStatus(@Param("id")String id);
//	@Query("SELECT COUNT(c.id) FROM ClaimAnalysisReport c  WHERE c.rfqId= :id AND c.status=:status")
//	int getCountBasedOnStatus(@Param("status") String status,@Param("id")String id);
//	
//	@Query("SELECT SUM(c.sumInsured) FROM ClaimAnalysisReport c  WHERE c.rfqId= :id AND c.status=:status")
//	double getAmountBasedOnStatus(@Param("status") String status,@Param("id")String id);
//	
//	// Disease Wise Data 
//	
//	@Query("SELECT c.disease FROM ClaimAnalysisReport c  WHERE c.rfqId= :id")
//	Set<String>getAllDisease(@Param("id")String id);
//	
//	@Query("SELECT COUNT(c.id) FROM ClaimAnalysisReport c  WHERE c.rfqId= :id AND c.disease=:disease")
//	int getCountBasedOnDisease(@Param("disease") String status,@Param("id")String id);
//	
//	@Query("SELECT SUM(c.sumInsured) FROM ClaimAnalysisReport c  WHERE c.rfqId= :id AND c.disease=:disease")
//	double getAmountBasedOnDisease(@Param("disease") String disease,@Param("id")String id);
	
	
}

