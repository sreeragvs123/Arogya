package com.Grp._8.backend.repositories.drug;


import com.Grp._8.backend.dto.search.DrugSearchResponseDto;
import com.Grp._8.backend.entities.medicine.Drug;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DrugRepository extends JpaRepository<Drug, Long> {


    @Query("""
    SELECT new com.Grp._8.backend.dto.search.DrugSearchResponseDto(d.id, d.name, d.strength, CAST(d.form AS string))
        FROM Drug d
            WHERE d.isActive = true
                AND LOWER(d.name) LIKE LOWER(CONCAT('%', :query, '%'))
""")
    Page<DrugSearchResponseDto> searchByName(@Param("query") String query, Pageable pageable);
}