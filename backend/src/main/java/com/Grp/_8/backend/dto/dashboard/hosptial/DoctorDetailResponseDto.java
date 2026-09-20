package com.Grp._8.backend.dto.dashboard.hosptial;


import com.Grp._8.backend.entities.enums.Designation;
import com.Grp._8.backend.entities.enums.DoctorStatus;
import com.Grp._8.backend.entities.enums.Sex;
import com.Grp._8.backend.entities.enums.VerificationStatus;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Builder
public class DoctorDetailResponseDto {
    private Long doctorId;
    private String fullName;
    private String email;
    private String profileImageUrl;
    private String phoneNumber;
    private String licenseNumber;
    private Designation designation;
    private String specialization;
    private Sex sex;
    private LocalDate dateOfBirth;
    private VerificationStatus verificationStatus;
    private DoctorStatus status;
    private Boolean prescriptionAuthority;
    private Boolean labImagingOrdering;
    private Boolean dischargeSignoffAuthority;
    private Long hospitalId;
    private String hospitalName;
    private LocalDateTime lastLoginAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}