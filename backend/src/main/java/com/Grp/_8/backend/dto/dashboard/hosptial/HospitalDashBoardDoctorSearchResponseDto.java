package com.Grp._8.backend.dto.dashboard.hosptial;


import com.Grp._8.backend.entities.enums.Designation;
import com.Grp._8.backend.entities.enums.DoctorStatus;
import com.Grp._8.backend.entities.enums.VerificationStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class HospitalDashBoardDoctorSearchResponseDto {
    private Long doctorId;

    // Hospital practitioner
    private String doctorName;
    private String profileImageUrl;
    private Designation designation;
    private String specialization;

    // License & council
    private String licenseNumber;
    private VerificationStatus verificationStatus;

    // Facility & ward
    private Long hospitalId;
    private String hospitalName;
    private String wardOrDepartment;

    // Status & caseload
    private DoctorStatus status;

    // Direct contact
    private String email;
    private String phoneNumber;

    // Permissions for the “Privileges” action
    private Boolean prescriptionAuthority;
    private Boolean labImagingOrdering;
    private Boolean dischargeSignoffAuthority;
}
