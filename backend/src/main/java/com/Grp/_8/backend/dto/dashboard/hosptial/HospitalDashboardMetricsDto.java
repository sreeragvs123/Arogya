package com.Grp._8.backend.dto.dashboard.hosptial;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class HospitalDashboardMetricsDto {
    private Long totalStaff;
    private Long activeOnDuty;
    private Long pendingReviews;
    private Long specialtyCount;
}