package com.Grp._8.backend.entities.histories;

import com.Grp._8.backend.entities.users.Patient;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "blood_pressure_readings")
@Getter
@Setter
public class BloodPressureReading {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    private Integer systolic;
    private Integer diastolic;

    @CreationTimestamp
    private LocalDateTime recordedAt;
}