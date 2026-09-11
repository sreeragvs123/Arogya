package com.Grp._8.backend.dto.vitals;

import lombok.Data;

@Data
public class VitalsUpdateRequestDto {
    private String bloodPressure;
    private Double bloodSugar;
    private Double weight;
    private Double height;
    private Double heartRate;
    private Double bodyTemp;
}
