package com.Grp._8.backend.dto.vitals;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class VitalsResponseDto {
    private Long prescriptionId;
    private String bloodPressure;
    private Double bloodSugar;
    private Double weight;
    private Double height;
    private Double heartRate;
    private Double bodyTemp;
}