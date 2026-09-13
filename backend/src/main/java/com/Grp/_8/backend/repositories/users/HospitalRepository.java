package com.Grp._8.backend.repositories.users;

import com.Grp._8.backend.dto.search.HospitalSearchResponseDto;
import com.Grp._8.backend.entities.enums.VerificationStatus;
import com.Grp._8.backend.entities.users.Hospital;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface HospitalRepository extends JpaRepository<Hospital, Long> {

    Optional<Hospital> findById(Long id);

    @Query("Select id from Hospital h where h.userData.id = : id")
    Long findByUserId(@Param("userId") Long id);

    @Query("""
    SELECT new com.Grp._8.backend.dto.search.HospitalSearchResponseDto(h.id,u.name)
        FROM Hospital h JOIN h.userData u 
            WHERE LOWER(u.name) LIKE LOWER(CONCAT('%', :query, '%'))
    """)
    Page<HospitalSearchResponseDto> searchByName(@Param("query") String query, Pageable pageable);


    Optional<Hospital> findByUserData_Id(Long userId);





}