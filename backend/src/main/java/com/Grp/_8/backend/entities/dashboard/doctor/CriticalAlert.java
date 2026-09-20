package com.Grp._8.backend.entities.dashboard.doctor;

import com.Grp._8.backend.entities.enums.AlertSeverity;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.entities.users.Patient;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class CriticalAlert {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "doctor_id", nullable = false)
    private Doctor doctor;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AlertSeverity severity = AlertSeverity.WARNING;

    @Column(nullable = false)
    private boolean acknowledged = false;
}
