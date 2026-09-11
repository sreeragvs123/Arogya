package com.Grp._8.backend.dto.auth;

import com.Grp._8.backend.entities.enums.Designation;
import com.Grp._8.backend.entities.enums.DoctorStatus;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Builder
@Data
public class DoctorCreateResponseDto {
    private Long doctorId;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String licenseNumber;
    private String specialization;
    private Designation designation;
    private DoctorStatus status;
    private Boolean prescriptionAuthority;
    private Boolean labImagingOrdering;
    private Boolean dischargeSignoffAuthority;
    private String temporaryPin;
    private LocalDateTime assignedAt;
}