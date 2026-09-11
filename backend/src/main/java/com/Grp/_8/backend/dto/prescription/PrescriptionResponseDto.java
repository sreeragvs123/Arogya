package com.Grp._8.backend.dto.prescription;

import com.Grp._8.backend.entities.enums.ReportStatus;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class PrescriptionResponseDto {

    private Long id;
    private String referenceNumber;
    private ReportStatus status;
    private String patientName;
    private String doctorName;
    private String hospitalName;
    private String pdfUrl;
    private String clinicalObservations;
    private LocalDateTime createdAt;
    private List<String> symptoms;
    // Signature details
    private String signatureImageUrl;
    private LocalDateTime signedAt;
    // Session details
    private Integer sessionDurationSeconds;
    // Vitals
    private String bloodPressure;
    private Double bloodSugar;
    private Double weight;
    private Double height;
    private Double heartRate;
    private Double bodyTemp;
    // Prescription medicines
    private List<PrescriptionItemResponseDto> items;
}
