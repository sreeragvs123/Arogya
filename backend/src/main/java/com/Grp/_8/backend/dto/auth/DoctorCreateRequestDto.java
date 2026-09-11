package com.Grp._8.backend.dto.auth;

import com.Grp._8.backend.entities.enums.Designation;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class DoctorCreateRequestDto {

    @NotBlank
    private String fullName;

    @NotBlank
    private String licenseNumber;
    @NotBlank
    private String temporaryPin;
    @NotBlank
    private String specialization; // Clinical Department

    @NotNull
    private Designation designation; // Designation / Rank

    @NotBlank
    @Email
    private String email;

    @NotBlank
    private String phoneNumber;

    private Boolean prescriptionAuthority = true;
    private Boolean labImagingOrdering = true;
    private Boolean dischargeSignoffAuthority = false;
}