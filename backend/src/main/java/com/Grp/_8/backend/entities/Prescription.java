package com.Grp._8.backend.entities;

import jakarta.persistence.*;
import java.util.List;

@Entity
public class Prescription {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "doctor_id", nullable = false)
    private Doctor doctor;

    @ManyToOne
    @JoinColumn(name = "hospital_id", nullable = false)
    private Hospital hospital;

    @OneToMany(fetch = FetchType.LAZY)
    private List<PerscriptionItem> prescriptionItems;


}
