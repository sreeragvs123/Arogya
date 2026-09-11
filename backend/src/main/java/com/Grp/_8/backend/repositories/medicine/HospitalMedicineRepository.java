package com.Grp._8.backend.repositories.medicine;

import com.Grp._8.backend.entities.medicine.HospitalMedicine;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface HospitalMedicineRepository extends JpaRepository<HospitalMedicine, Long> {

    // Search only medicines available in a specific hospital
    @Query("""
        SELECT hm FROM HospitalMedicine hm
        JOIN FETCH hm.drug d
        WHERE hm.hospital.id = :hospitalId
        AND hm.isActive = true
        AND hm.stockQuantity > 0
        AND (
            LOWER(d.name) LIKE LOWER(CONCAT('%', :query, '%'))
            OR LOWER(d.genericName) LIKE LOWER(CONCAT('%', :query, '%'))
        )
        ORDER BY d.name ASC
        """)
    List<HospitalMedicine> searchByHospital(
            @Param("hospitalId") Long hospitalId,
            @Param("query") String query,
            Pageable pageable
    );



    Optional<HospitalMedicine> findByHospitalIdAndDrugId(Long hospitalId, Long drugId);
}