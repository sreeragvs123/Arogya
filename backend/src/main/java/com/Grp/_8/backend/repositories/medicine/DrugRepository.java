package com.Grp._8.backend.repositories.medicine;


import com.Grp._8.backend.entities.medicine.Drug;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DrugRepository extends JpaRepository<Drug, Long> {


    @Query("""
        SELECT d FROM Drug d
        WHERE d.isActive = true
        AND (
            LOWER(d.name) LIKE LOWER(CONCAT('%', :query, '%'))
            OR LOWER(d.genericName) LIKE LOWER(CONCAT('%', :query, '%'))
            OR LOWER(d.brandName) LIKE LOWER(CONCAT('%', :query, '%'))
        )
        ORDER BY d.name ASC
        """)
    List<Drug> searchDrugs(@Param("query") String query, Pageable pageable);
}