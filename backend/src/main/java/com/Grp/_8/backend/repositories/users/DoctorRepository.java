package com.Grp._8.backend.repositories.users;

import com.Grp._8.backend.dto.dashboard.hosptial.HospitalDashBoardDoctorSearchResponseDto;
import com.Grp._8.backend.entities.enums.DoctorStatus;
import com.Grp._8.backend.entities.enums.VerificationStatus;
import com.Grp._8.backend.entities.users.Doctor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DoctorRepository extends JpaRepository<Doctor, Long> {

    Boolean existsByLicenseNumber(String licenseNumber);

    Optional<Doctor> findByUserData_Id(Long id);

    Optional<Doctor> findById(Long id);

    Boolean existsByHospital_IdAndLicenseNumber(Long hospitalId, String licenseNumber);
    Optional<Long> findIdByUserData_Username(String username);

    @Query("SELECT d FROM Doctor d JOIN FETCH d.userData WHERE d.hospital.id = :hospitalId")
    List<Doctor> findAllByHospitalId(@Param("hospitalId") Long hospitalId);

        @Query("""
    SELECT d
    FROM Doctor d
    JOIN d.userData u
    WHERE d.hospital.id = :hospitalId
      AND (:department IS NULL OR :department = ''
           OR LOWER(d.specialization) = LOWER(:department))
      AND (:status IS NULL OR d.status = :status)
      AND (:query IS NULL OR :query = '' OR (
           LOWER(u.name) LIKE LOWER(CONCAT('%', :query, '%'))
           OR LOWER(d.licenseNumber) LIKE LOWER(CONCAT('%', :query, '%'))
           OR LOWER(d.specialization) LIKE LOWER(CONCAT('%', :query, '%'))
           OR LOWER(d.phoneNumber) LIKE LOWER(CONCAT('%', :query, '%'))
      ))
    """)
        Page<Doctor> findFilteredDoctors(
                @Param("hospitalId") Long hospitalId,
                @Param("department") String department,
                @Param("status") DoctorStatus status,
                @Param("query") String query,
                Pageable pageable
        );


        @Query("SELECT new com.Grp._8.backend.dto.dashboard.hosptial.HospitalDashBoardDoctorSearchResponseDto(" +
                "d.id, " +                              // doctorId
                "u.name, " +                            // doctorName
                "u.profileImageUrl, " +                 // profileImageUrl
                "d.designation, " +                     // designation
                "d.specialization, " +                  // specialization
                "d.licenseNumber, " +                   // licenseNumber
                "d.verificationStatus, " +              // verificationStatus
                "d.hospital.id, " +                     // hospitalId
                "d.hospital.userData.name, " +          // hospitalName
                "NULL, " +                              // wardOrDepartment
                "d.status, " +                          // status
                "u.email, " +                           // email
                "d.phoneNumber, " +                     // phoneNumber
                "d.prescriptionAuthority, " +           // prescriptionAuthority
                "d.labImagingOrdering, " +              // labImagingOrdering
                "d.dischargeSignoffAuthority) " +       // dischargeSignoffAuthority
                "FROM Doctor d JOIN d.userData u " +
                "WHERE d.hospital.id = :hospitalId " +
                "AND (:department IS NULL OR :department = '' OR LOWER(d.specialization) = LOWER(:department)) " +
                "AND (:status IS NULL OR d.status = :status) " +
                "AND (:query IS NULL OR :query = '' OR (" +
                "LOWER(u.name) LIKE LOWER(CONCAT('%', :query, '%')) " +
                "OR LOWER(d.licenseNumber) LIKE LOWER(CONCAT('%', :query, '%')) " +
                "OR LOWER(d.specialization) LIKE LOWER(CONCAT('%', :query, '%')) " +
                "OR LOWER(d.phoneNumber) LIKE LOWER(CONCAT('%', :query, '%'))))")
        Page<HospitalDashBoardDoctorSearchResponseDto> searchDoctors(
                @Param("hospitalId") Long hospitalId,
                @Param("department") String department,
                @Param("status") DoctorStatus status,
                @Param("query") String query,
                Pageable pageable
        );


    Long countByHospital_Id(Long hospitalId);

    Long countByHospital_IdAndStatus(Long hospitalId, DoctorStatus status);

    Long countByHospital_IdAndVerificationStatus(Long hospitalId, VerificationStatus verificationStatus);

    @Query("SELECT COUNT(DISTINCT d.specialization) FROM Doctor d WHERE d.hospital.id = :hospitalId")
    Long countDistinctSpecializationsByHospitalId(@Param("hospitalId") Long hospitalId);


        Page<Doctor> findByHospital_IdAndStatusIn(
                Long hospitalId,
                List<DoctorStatus> statuses,
                Pageable pageable
        );

        // 2. Search name, license, specialization, email, or phone within a section
        @Query("""
        SELECT d
        FROM Doctor d
        JOIN d.userData u
        WHERE d.hospital.id = :hospitalId
          AND d.status IN :statuses
          AND (
                LOWER(u.name) LIKE LOWER(CONCAT('%', :query, '%'))
                OR LOWER(u.email) LIKE LOWER(CONCAT('%', :query, '%'))
                OR LOWER(d.licenseNumber) LIKE LOWER(CONCAT('%', :query, '%'))
                OR LOWER(d.specialization) LIKE LOWER(CONCAT('%', :query, '%'))
                OR LOWER(d.phoneNumber) LIKE LOWER(CONCAT('%', :query, '%'))
          )
        """)
        Page<Doctor> searchDoctorsInSection(
                @Param("hospitalId") Long hospitalId,
                @Param("statuses") List<DoctorStatus> statuses,
                @Param("query") String query,
                Pageable pageable
        );

        // 3. Filter by specialization within a section
        Page<Doctor> findByHospital_IdAndStatusInAndSpecializationIgnoreCase(
                Long hospitalId,
                List<DoctorStatus> statuses,
                String specialization,
                Pageable pageable
        );


        @Query("""
        SELECT DISTINCT d.specialization
        FROM Doctor d
        WHERE d.hospital.id = :hospitalId
          AND d.specialization IS NOT NULL
          AND TRIM(d.specialization) <> ''
        ORDER BY d.specialization
        """)
        List<String> findDistinctSpecializationsByHospitalId(
                @Param("hospitalId") Long hospitalId
        );
    }