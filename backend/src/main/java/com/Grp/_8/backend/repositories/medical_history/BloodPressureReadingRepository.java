package com.Grp._8.backend.repositories.medical_history;


import com.Grp._8.backend.entities.histories.BloodPressureReading;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface BloodPressureReadingRepository extends JpaRepository<BloodPressureReading,Long> {
    Optional<BloodPressureReading> findTop1ByPatientIdOrderByRecordedAtDesc(Long id);
}
