package com.Grp._8.backend.repositories.users;

import com.Grp._8.backend.entities.users.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface PaitentRepository extends JpaRepository<Patient, Long> {
    Optional<Patient> findByUserData_Id(Long userId);
}
