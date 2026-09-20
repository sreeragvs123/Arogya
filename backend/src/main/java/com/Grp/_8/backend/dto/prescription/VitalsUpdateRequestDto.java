package com.Grp._8.backend.dto.prescription;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VitalsUpdateRequestDto {
    private Double heartRate;
    private String bloodPressure; // "120/80"
    private Double bodyTemp;
    private Double bloodSugar;
    private Double weight;
    private Double height;
}