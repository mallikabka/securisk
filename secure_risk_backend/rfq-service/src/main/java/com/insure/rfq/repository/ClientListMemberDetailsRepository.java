    package com.insure.rfq.repository;

    import com.insure.rfq.entity.ClientListMemberDetails;
    import org.springframework.data.jpa.repository.JpaRepository;
    import org.springframework.data.jpa.repository.Query;
    import org.springframework.data.repository.query.Param;

    import java.util.Date;
    import java.util.List;

    public interface ClientListMemberDetailsRepository extends JpaRepository<ClientListMemberDetails,Long> {

//        @Query("SELECT c FROM ClientListMemberDetails c WHERE c.createdDate >= :timeThreshold")
//        List<ClientListMemberDetails> findFreshRecords(@Param("timeThreshold") Date timeThreshold);
    }
