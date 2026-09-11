package com.Grp._8.backend.dto.auth;


import com.Grp._8.backend.entities.enums.HospitalType;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class HospitalRegistrationRequestDto {

    @NotBlank
    private String hospitalName;

    @NotNull
    private HospitalType facilityType;

    @NotBlank
    private String clinicalLicenseNumber;

    @NotBlank
    private String adminName;

    @Email
    @NotBlank
    private String officialEmail;

    @NotBlank
    private String contactPhone;

    @Size(min = 8)
    private String password;
}
