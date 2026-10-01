package com.Grp._8.backend.repositories.users;

import com.Grp._8.backend.entities.users.Staff;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository
public interface StaffRepository extends JpaRepository<Staff, Long> {
    Optional<Staff> findByUserData_Id(Long userId);

    Optional<Long> findIdByUserData_Username(String username);

    @Query("select s.hospital.id from Staff s where s.userData.username = :username")
    Optional<Long> findHospitalIdByUsername(@Param("username") String username);

    @Query(
            value = "SELECT s FROM Staff s JOIN FETCH s.userData WHERE s.hospital.id = :hospitalId",
            countQuery = "SELECT COUNT(s) FROM Staff s WHERE s.hospital.id = :hospitalId"
    )
    Page<Staff> findAllStaff(@Param("hospitalId") Long hospitalId, Pageable pageable);


    @EntityGraph(attributePaths = "userData")
    @Query("select s from Staff s where s.hospital.id = :hospitalId and s.isActive = true")
    Page<Staff> findActiveDuty(@Param("hospitalId") Long hospitalId, Pageable pageable);

    @EntityGraph(attributePaths = "userData")
    @Query("select s from Staff s where s.hospital.id = :hospitalId and s.isActive = true and s.onCall = true")
    Page<Staff> findOnCall(@Param("hospitalId") Long hospitalId, Pageable pageable);

    @EntityGraph(attributePaths = "userData")
    @Query("select s from Staff s where s.hospital.id = :hospitalId and (s.isActive = false or s.isActive is null)")
    Page<Staff> findProvisioning(@Param("hospitalId") Long hospitalId, Pageable pageable);
}

