package com.insure.rfq.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.insure.rfq.login.entity.Location;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Entity
@AllArgsConstructor
@NoArgsConstructor
public class ClientList {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long cid;

    @Column(name = "clientName")
    private String clientName;

    @ManyToOne
    @JoinColumn(referencedColumnName = "locationId")
    private Location locationId;

    @ManyToOne
    @JoinColumn(referencedColumnName = "insurerId")
    private InsureList insureCompanyId;

    private String wellness;

    private String status;

    @Column(name = "POLICYTYPE")
    private String policyType;

    @ManyToOne
    @JoinColumn(referencedColumnName = "tpa_id")
    private Tpa tpaId;

    @OneToMany(mappedBy = "clientList")
    @JsonManagedReference
    private List<ClientListUser> clientListUser;

    @ManyToMany(mappedBy = "clientList")
    @JsonBackReference
    private List<Product> product;

    @Column(name = "RfqId")
    private String rfqId;
    
    private LocalDateTime createdDate;

    private LocalDateTime updatedDate;
    

}