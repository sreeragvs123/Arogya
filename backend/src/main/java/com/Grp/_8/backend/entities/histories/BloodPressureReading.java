package com.Grp._8.backend.entities.histories;

import com.Grp._8.backend.entities.enums.RecordedBy;
import com.Grp._8.backend.entities.enums.VitalStatus;
import com.Grp._8.backend.entities.users.Patient;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "blood_pressure_readings",
        indexes = @Index(name = "idx_bp_patient_time", columnList = "patient_id, recordedAt")
)
@Getter @Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BloodPressureReading {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    private Integer systolic;
    private Integer diastolic;

    // Computed status — classified on save
    @Enumerated(EnumType.STRING)
    private VitalStatus status;   // NORMAL, HIGH, LOW, CRITICAL

    private String notes;

    @Enumerated(EnumType.STRING)
    private RecordedBy recordedBy;  // PATIENT_SELF, DOCTOR

    @CreationTimestamp
    private LocalDateTime recordedAt;
}