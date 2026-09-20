package com.Grp._8.backend.dto.dashboard.doctor;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PatientDirectoryMetricsDto {

    private long totalPatients;
    private long newPatientsThisMonth;
    private long followUpsDue;
}