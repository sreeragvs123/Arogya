package com.Grp._8.backend.dto.observations;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ClinicalObservationsResponseDto {
    private Long prescriptionId;
    private String clinicalObservations;
}