package com.Grp._8.backend.repositories.users;

import com.Grp._8.backend.entities.users.Doctor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DoctorRepository extends JpaRepository<Doctor, Long> {
}