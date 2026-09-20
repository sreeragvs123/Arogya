package com.Grp._8.backend.entities.prescription;

import com.Grp._8.backend.entities.dashboard.doctor.DiagnosticReport;
import com.Grp._8.backend.entities.enums.ReportStatus;
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
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Getter @Setter
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

    // What the patient came in with — shown under Clinical Observations
    @ElementCollection
    @CollectionTable(name = "prescription_symptoms", joinColumns = @JoinColumn(name = "prescription_id"))
    @Column(name = "symptom")
    private List<String> symptoms = new ArrayList<>();

    // Doctor's treatment notes — also shown in PDF
    @Column(columnDefinition = "TEXT")
    private String clinicalObservations;

    @Enumerated(EnumType.STRING)
    private ReportStatus status = ReportStatus.DRAFT;   // DRAFT -> PENDING_SIGNATURE -> SIGNED -> SENT

    private String referenceNumber;   // "CSR-2023-0892" - generate server-side on creation

    private String signatureImageUrl; // doctor's signature asset, set on "Add Digital Signature"
    private LocalDateTime signedAt;

    private Integer sessionDurationSeconds;

    // Vitals recorded at time of visit
    private String bloodPressure;     // "118/79"
    private Double bloodSugar;        // 142.0
    private Double weight;            // 82.0
    private Double height;            // 178.0
    private Double heartRate;         // 72.0
    private Double bodyTemp;          // 98.4

    private String pdfUrl;

    @OneToMany(mappedBy = "prescription", cascade = CascadeType.ALL)
    private List<PrescriptionItem> prescriptionItems = new ArrayList<>();


    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "prescription_diagnostic_reports",
            joinColumns = @JoinColumn(name = "prescription_id"),
            inverseJoinColumns = @JoinColumn(name = "diagnostic_report_id")
    )
    private Set<DiagnosticReport> diagnosticReports = new HashSet<>();

    @CreationTimestamp
    private LocalDateTime createdAt;
}