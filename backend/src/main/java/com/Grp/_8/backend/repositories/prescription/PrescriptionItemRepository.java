package com.Grp._8.backend.repositories.prescription;

import com.Grp._8.backend.entities.prescription.PrescriptionItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PrescriptionItemRepository extends JpaRepository<PrescriptionItem, Long> {
    Optional<PrescriptionItem> findById(Long prescriptionId);
}
