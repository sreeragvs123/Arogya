package com.Grp._8.backend.entities.medicine;

import com.Grp._8.backend.entities.enums.MedicineForm;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "drugs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Drug {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;              // "Atorvastatin"

    private String genericName;       // "Atorvastatin Calcium"

    private String brandName;         // "Lipitor"

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private MedicineForm form;        // TABLET, SYRUP, INJECTION, CAPSULE

    private String strength;          // "10mg", "500mg"

    private String category;          // "Statin", "Antibiotic"

    @Column(columnDefinition = "TEXT")
    private String contents;          // "Each tablet contains Atorvastatin 10mg..."

    @Column(columnDefinition = "TEXT")
    private String uses;              // "Used to lower cholesterol and triglycerides..."

    @Column(columnDefinition = "TEXT")
    private String sideEffects;       // "Muscle pain, liver problems..."

    @Column(columnDefinition = "TEXT")
    private String warnings;          // "Avoid in pregnancy, liver disease..."

    private String manufacturer;

    @Column(nullable = false)
    private boolean isActive = true;
}