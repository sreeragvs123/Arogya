package com.Grp._8.backend.repositories.medical_history;

import com.Grp._8.backend.entities.enums.VitalType;
import com.Grp._8.backend.entities.vital_history.VitalReading;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface VitalReadingRepository extends JpaRepository<VitalReading,Long> {
    Optional<VitalReading> findTop1ByPatientIdAndTypeOrderByRecordedAtDesc(Long id , VitalType type);

}
