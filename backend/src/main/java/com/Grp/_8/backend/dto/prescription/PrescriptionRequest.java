package com.Grp._8.backend.dto.prescription;


import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class PrescriptionRequest {
    private Long patientId;
    private Long hospitalId;
    private LocalDate startData;
    private LocalDate endData;
    private String notes;
    private List<PrescriptionItemRequest> items;
}
