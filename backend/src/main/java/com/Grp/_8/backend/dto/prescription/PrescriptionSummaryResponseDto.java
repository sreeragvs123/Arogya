package com.Grp._8.backend.dto.prescription;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PrescriptionSummaryResponseDto {
    private String pdfUrl;
    private String doctorName;
    private String hospitalName;
    private String referenceNumber;
    private LocalDateTime signedAt;
    private List<String> symptoms;
    private String clinicalObservations;
    private List<PrescriptionItemSummary> items;

    @Getter
    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    public static class PrescriptionItemSummary {
        private String medicineName;
        private String dosage;
        private String frequency;
        private Integer durationDays;
        private String doseTiming;
    }
}