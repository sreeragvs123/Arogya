package com.Grp._8.backend.dto.dashboard.doctor;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class WeeklySummaryDto {

    private double efficiencyPercentDelta;
    private double progress;
    private long completedConsultations;
    private long scheduledConsultations;

}