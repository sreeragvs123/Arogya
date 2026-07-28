package com.Grp._8.backend.repositories.medicine;

import com.Grp._8.backend.entities.medicine.Medicine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MedicineRepository extends JpaRepository<Medicine, Long> {
    List<Medicine> findByHospitalIdAndIsActiveTrue(Long hospitalId);
    Optional<Medicine> findByIdAndHospitalId(Long id, Long hospitalId);
}