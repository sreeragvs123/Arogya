package com.Grp._8.backend.dto.dashboard.doctor;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PatientDirectoryItemDto {

    private Long patientId;
    private String patientName;
    private String primaryDiagnosis;
    private LocalDateTime lastVisitedAt;
    private String directoryStatus;
}