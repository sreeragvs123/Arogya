package com.Grp._8.backend.repositories.dashboard.doctor;


import com.Grp._8.backend.entities.dashboard.doctor.CriticalAlert;
import com.Grp._8.backend.entities.enums.AlertSeverity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CriticalAlertRepository extends JpaRepository<CriticalAlert, Long> {
    long countByDoctorIdAndSeverityAndAcknowledgedFalse(Long doctorId, AlertSeverity severity);
}
