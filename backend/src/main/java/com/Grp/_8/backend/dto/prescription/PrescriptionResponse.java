package com.Grp._8.backend.dto.prescription;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class PrescriptionResponse {
    private Long id;
    private String patientName;
    private String doctorName;
    private String hospitalName;
    private LocalDate startDate;
    private LocalDate endDate;
    private LocalDateTime createdAt;
    private String notes;
    private List<PrescriptionItemResponse> items;
}
