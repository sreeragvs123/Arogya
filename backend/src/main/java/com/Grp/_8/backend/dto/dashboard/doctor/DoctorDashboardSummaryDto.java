package com.Grp._8.backend.dto.dashboard.doctor;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DoctorDashboardSummaryDto {

    private MorningOverviewDto morningOverview;
    private long pendingReportsCount;
    private long newReportsCount;
    private long criticalAlertsCount;
    private WeeklySummaryDto weeklySummary;
}