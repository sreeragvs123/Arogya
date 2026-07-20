package com.Grp._8.backend.dto.profile;

import com.Grp._8.backend.entities.enums.BloodType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProfileUpdateRequestDto {
    private String name;
    private LocalDate dateOfBirth;
    private BloodType bloodType;
    private Double heightCm;
    private Double weightKg;
    private Double bloodSugar;
    private Double bodyFat;
    private Integer systolicBp;
    private Integer diastolicBp;
}
