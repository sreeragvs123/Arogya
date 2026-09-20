package com.Grp._8.backend.entities.dashboard.doctor;

import com.Grp._8.backend.entities.enums.ReportReviewStatus;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.entities.users.Patient;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class DiagnosticReport {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "reviewing_doctor_id", nullable = false)
    private Doctor reviewingDoctor;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ReportReviewStatus reviewStatus = ReportReviewStatus.PENDING_REVIEW;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
