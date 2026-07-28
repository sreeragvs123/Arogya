package com.Grp._8.backend.entities.histories;

import com.Grp._8.backend.entities.enums.VitalType;
import com.Grp._8.backend.entities.users.Patient;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "vital_readings",
        indexes = @Index(name = "idx_patient_type_time", columnList = "patient_id, type, recordedAt")
)
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class VitalReading {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Enumerated(EnumType.STRING)
    private VitalType type;

    private Double value;
    private String unit;      // "mg/dL", "kg", "%"

    @CreationTimestamp
    private LocalDateTime recordedAt;
}