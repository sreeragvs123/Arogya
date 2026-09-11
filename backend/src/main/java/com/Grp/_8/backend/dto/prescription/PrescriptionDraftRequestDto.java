package com.Grp._8.backend.dto.prescription;

import lombok.Data;

@Data
public class PrescriptionDraftRequestDto {
    private Long patientId;
    private Long doctorId;
}
