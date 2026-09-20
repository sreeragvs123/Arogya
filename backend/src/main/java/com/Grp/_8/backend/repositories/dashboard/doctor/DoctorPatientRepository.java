package com.Grp._8.backend.repositories.dashboard.doctor;

import com.Grp._8.backend.entities.users.DoctorPatient;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;

public interface DoctorPatientRepository extends JpaRepository<DoctorPatient, Long> {
    @Query("""
            select dp from DoctorPatient dp
            join dp.patient p join p.userData u
            where dp.doctor.id = :doctorId and dp.active = true
              and (:query = ''
                   or lower(u.name) like lower(concat('%', :query, '%'))
                   or lower(coalesce(dp.primaryDiagnosis, '')) like lower(concat('%', :query, '%'))
                   or (:patientId is not null and p.id = :patientId))
            """)
    Page<DoctorPatient> searchDirectory(
            @Param("doctorId") Long doctorId,
            @Param("query") String query,
            @Param("patientId") Long patientId,
            Pageable pageable);

    long countByDoctorIdAndActiveTrue(Long doctorId);
    long countByDoctorIdAndActiveTrueAndAssignedAtGreaterThanEqual(Long doctorId, LocalDateTime from);
    long countByDoctorIdAndActiveTrueAndFollowUpDueOnLessThanEqual(Long doctorId, LocalDate date);
}
