package com.Grp._8.backend.entities.appointment;

import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.entities.enums.ConsultationType;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.entities.users.Patient;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class Appointment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "doctor_id", nullable = false)
    private Doctor doctor;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(nullable = false)
    private LocalDateTime appointmentAt;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ConsultationType consultationType;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AppointmentStatus status = AppointmentStatus.SCHEDULED;

    // Reason the hospital gave when rejecting (optional, useful for the patient's app)
    private String rejectionReason;

    // Set true the moment a doctor unlocks this patient's portal for this appointment.
    // Lets you show "already accessed" on the dashboard and gate re-access.
    @Column(nullable = false)
    private boolean patientPortalUnlocked = false;
}
