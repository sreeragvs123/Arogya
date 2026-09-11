package com.Grp._8.backend.repositories.users;

import com.Grp._8.backend.entities.users.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface PatientRepository extends JpaRepository<Patient, Long> {
    Optional<Patient> findByUserData_Id(Long userId);

    @Query("SELECT p FROM Patient p JOIN FETCH p.userData WHERE p.id = :patientId")
    Optional<Patient> findByIdWithUser(@Param("patientId") Long patientId);
}
