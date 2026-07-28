package com.Grp._8.backend.entities.prescription;

import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.entities.users.Hospital;
import com.Grp._8.backend.entities.users.Patient;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
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

    @Column(columnDefinition = "TEXT")
    private String symptomsDescription;

    private String pdfUrl;


    @OneToMany(mappedBy = "perscription", cascade = CascadeType.ALL)
    private List<PrescriptionItem> prescriptionItems = new ArrayList<>();

    @CreationTimestamp
    private LocalDateTime createdAt;

}
