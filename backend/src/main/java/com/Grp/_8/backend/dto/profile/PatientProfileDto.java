package com.Grp._8.backend.dto.profile;


import com.Grp._8.backend.entities.enums.BloodType;
import com.Grp._8.backend.entities.enums.Sex;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class PatientProfileDto {

    private Long patientId;

    private String name;

    private LocalDate dateOfBirth;

    private Double heightCm;

    private BloodType bloodType;

    private Sex sex;

    private String phoneNumber;

    private String address;

    private Double latestWeightKg;

    private Double latestBloodSugar;

    private Double latestBodyFatPercent;

    private Integer latestSystolicBp;

    private Integer latestDiastolicBp;

    private LocalDateTime lastUpdated;
}