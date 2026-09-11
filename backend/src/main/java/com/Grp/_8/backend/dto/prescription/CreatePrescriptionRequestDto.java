package com.Grp._8.backend.dto.prescription;


import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class CreatePrescriptionRequestDto {
    @NotNull
    private Long patientId;
    @NotNull private Long doctorId;
    @NotNull private Long hospitalId;

    private String symptomsDescription;
    private String clinicalObservations;

    // Vitals recorded at visit
    private String bloodPressure;
    private Double bloodSugar;
    private Double heartRate;
    private Double bodyTemp;
    private Double weight;

    @NotEmpty
    private List<PrescriptionItemRequestDto> prescriptionItems;
}
