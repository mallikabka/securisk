package com.insure.rfq.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.insure.rfq.entity.ClientList;

@Repository
public interface ClientListRepository extends JpaRepository<ClientList, Long> {

//  @Query(value = "SELECT SUM(CASE WHEN status LIKE %:status% THEN 1 ELSE 0 END) AS count FROM client_list", nativeQuery = true)
//  Long countApplicationsByStatus(@Param("status") String status);

	@Query(value = "SELECT status, COUNT(*) FROM client_list GROUP BY status", nativeQuery = true)
	List<Object[]> countApplicationsByStatus();

//  @Modifying
//  @Query("UPDATE ClientList cl " + "SET cl.product = "
//        + "(SELECT p FROM Product p WHERE p.productId = :newProductId) " + "WHERE cl.cid = :clientListId AND "
//        + "(SELECT COUNT(p) FROM cl.product p WHERE p.productId = :oldProductId) > 0")
//  void updateProductRelationship(@Param("newProductId") Long newProductId, @Param("clientListId") Long clientListId,
//        @Param("oldProductId") Long oldProductId);

//  @Query(value="UPDATE product_clientlist cl " + "SET cl.productid = "
//        + "(SELECT p.productid FROM product p WHERE p.productid = :newProductId) " + "WHERE cl.cid = :clientListId AND "
//        + "(SELECT COUNT(p) FROM cl p WHERE p.productid = :oldProductId) > 0",nativeQuery = true)
//  void updateProductRelationship(@Param("newProductId") Long newProductId, @Param("clientListId") Long clientListId, @Param("oldProductId") Long oldProductId);
//
	Optional<ClientList> findByRfqId(String rfqId);
	
	@Modifying
	@Query(value = "UPDATE product_clientlist SET productid = :newproductid WHERE cid = :cid AND productid = :oldproductid", nativeQuery = true)
	void updateProductRelationship(@Param("newproductid") Long newProductId, @Param("cid") Long clientListId,
								   @Param("oldproductid") Long oldProductId);
	@Modifying
	@Query(value = "DELETE FROM product_clientlist WHERE  productid =:productid AND cid =:cid", nativeQuery = true)
	void deleteProductRelationShip(@Param("productid") Long productid, @Param("cid") Long cid);

}