package com.Grp._8.backend.entities.medicine;


import com.Grp._8.backend.entities.users.Hospital;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;


@Entity
@AllArgsConstructor
@NoArgsConstructor
public class Medicine{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne
    @JoinColumn(name = "hospital_id",nullable = false)
    private Hospital hospital;

    @Column(nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private MedicineForm form;    // TABLET, SYRUP, INJECTION, etc.
    private String strength;   // "500mg"
    private Integer stockQuantity;
    private Boolean isActive = true;

}
