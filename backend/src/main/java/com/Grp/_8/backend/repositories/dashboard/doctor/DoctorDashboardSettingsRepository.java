package com.Grp._8.backend.repositories.dashboard.doctor;


import com.Grp._8.backend.entities.dashboard.doctor.DoctorDashboardSettings;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface DoctorDashboardSettingsRepository extends JpaRepository<DoctorDashboardSettings, Long> {
    Optional<DoctorDashboardSettings> findByDoctorId(Long doctorId);
}
