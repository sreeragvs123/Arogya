package com.Grp._8.backend.dto.prescription;

import com.Grp._8.backend.entities.enums.ReportStatus;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PrescriptionDraftResponseDto {
    private Long prescriptionId; // NOTE : These id is for the frontend to route subsequent tab calls
    private String referenceNumber;
    private ReportStatus status;
}
