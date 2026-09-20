package com.Grp._8.backend.services.dashboard.impl;

import com.Grp._8.backend.dto.dashboard.doctor.DoctorDashboardSummaryDto;
import com.Grp._8.backend.dto.dashboard.doctor.MorningOverviewDto;
import com.Grp._8.backend.dto.dashboard.doctor.WeeklySummaryDto;
import com.Grp._8.backend.entities.dashboard.doctor.DoctorDashboardSettings;
import com.Grp._8.backend.entities.enums.AlertSeverity;
import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.entities.enums.ReportReviewStatus;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.exceptions.DoctorNotFoundException;
import com.Grp._8.backend.exceptions.ResourceNotFoundException;
import com.Grp._8.backend.repositories.appointment.AppointmentRepository;
import com.Grp._8.backend.repositories.dashboard.doctor.CriticalAlertRepository;
import com.Grp._8.backend.repositories.dashboard.doctor.DiagnosticReportRepository;
import com.Grp._8.backend.repositories.dashboard.doctor.DoctorDashboardSettingsRepository;
import com.Grp._8.backend.repositories.users.DoctorRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Slf4j
public class DoctorDashBoardServiceImpl {

    private static final int DEFAULT_DAILY_CAPACITY = 12;

    private final AppointmentRepository appointmentRepository;
    private final DiagnosticReportRepository diagnosticReportRepository;
    private final CriticalAlertRepository criticalAlertRepository;
    private final DoctorDashboardSettingsRepository settingsRepository;
    private final DoctorRepository doctorRepository;
    private final Clock clock;

    @Transactional(readOnly = true)//IN this transcation the databasese inside the method will only be red
    public DoctorDashboardSummaryDto getSummary(Long doctorId) {

        Doctor doctor = doctorRepository.findById( doctorId).orElseThrow(
                ()->new DoctorNotFoundException("Doctor not found with id " + doctorId)
        );

        LocalDate today = LocalDate.now(clock);
        LocalDateTime todayStart = today.atStartOfDay();
        LocalDateTime tomorrowStart = today.plusDays(1).atStartOfDay();


        log.info("Calculating Doctors daily Capacity....");
        Long consultationsToday = appointmentRepository
                .countByDoctorIdAndAppointmentAtGreaterThanEqualAndAppointmentAtLessThanAndStatusNot(
                        doctor.getId(), todayStart, tomorrowStart, AppointmentStatus.CANCELLED);


        DoctorDashboardSettings settings = settingsRepository.findByDoctorId(doctor.getId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Dashboard settings not found for this doctor"
                ));

        int dailyCapacity = settings.getDailyCapacity();

        double capacityPercent = round((consultationsToday * 100.0) / dailyCapacity);
        log.info("Capacity Calculated Successfully....");




        log.info("Finding Report Status");
        long pendingReports = diagnosticReportRepository.countByReviewingDoctorIdAndReviewStatus(
                doctor.getId(), ReportReviewStatus.PENDING_REVIEW);

        long newReports = diagnosticReportRepository
                .countByReviewingDoctorIdAndReviewStatusAndCreatedAtGreaterThanEqual(
                        doctor.getId(), ReportReviewStatus.PENDING_REVIEW, LocalDateTime.now(clock).minusHours(24));

        long criticalAlerts = criticalAlertRepository.countByDoctorIdAndSeverityAndAcknowledgedFalse(
                doctor.getId(), AlertSeverity.CRITICAL);

        log.info("Report status found successfully");




        log.info("Finding the Doctors Efficency.....");
        LocalDateTime currentWindowStart = today.minusDays(6).atStartOfDay();
        LocalDateTime currentWindowEnd = tomorrowStart;
        LocalDateTime previousWindowStart = currentWindowStart.minusDays(7);

        long currentScheduled = scheduledCount(doctor.getId(), currentWindowStart, currentWindowEnd);
        long currentCompleted = completedCount(doctor.getId(), currentWindowStart, currentWindowEnd);
        long previousScheduled = scheduledCount(doctor.getId(), previousWindowStart, currentWindowStart);
        long previousCompleted = completedCount(doctor.getId(), previousWindowStart, currentWindowStart);

        double currentEfficiency = ratio(currentCompleted, currentScheduled);
        double previousEfficiency = ratio(previousCompleted, previousScheduled);


        double efficiencyDelta = previousScheduled == 0 ? 0.0
                : round(((currentEfficiency - previousEfficiency) / previousEfficiency) * 100.0);
        if (previousScheduled > 0 && previousEfficiency == 0.0) {
            efficiencyDelta = currentEfficiency == 0.0 ? 0.0 : 100.0;
        }

        double progress = Math.min(1.0, ratio(currentCompleted, (long) dailyCapacity * 7));
        log.info("Successfully Calculated Doctors Daily Capacity and Efficency....");

        return new DoctorDashboardSummaryDto(
                new MorningOverviewDto(consultationsToday, capacityPercent),
                pendingReports,
                newReports,
                criticalAlerts,
                new WeeklySummaryDto(efficiencyDelta, round(progress), currentCompleted, currentScheduled)
        );
    }


    private long scheduledCount(Long doctorId, LocalDateTime from, LocalDateTime until) {
        return appointmentRepository.countByDoctorIdAndAppointmentAtGreaterThanEqualAndAppointmentAtLessThanAndStatusNot(
                doctorId, from, until, AppointmentStatus.CANCELLED);
    }

    private long completedCount(Long doctorId, LocalDateTime from, LocalDateTime until) {
        return appointmentRepository.countByDoctorIdAndAppointmentAtGreaterThanEqualAndAppointmentAtLessThanAndStatus(
                doctorId, from, until, AppointmentStatus.COMPLETED);
    }

    private double ratio(long numerator, long denominator) {
        return denominator == 0 ? 0.0 : numerator / (double) denominator;
    }

    private double round(double value) {
        return Math.round(value * 100.0) / 100.0;
    }
}
