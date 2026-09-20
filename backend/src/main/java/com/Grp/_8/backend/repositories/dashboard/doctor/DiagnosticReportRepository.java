package com.Grp._8.backend.repositories.dashboard.doctor;

import com.Grp._8.backend.entities.dashboard.doctor.DiagnosticReport;
import com.Grp._8.backend.entities.enums.ReportReviewStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;

public interface DiagnosticReportRepository extends JpaRepository<DiagnosticReport, Long> {
    long countByReviewingDoctorIdAndReviewStatus(Long doctorId, ReportReviewStatus reviewStatus);

    long countByReviewingDoctorIdAndReviewStatusAndCreatedAtGreaterThanEqual(
            Long doctorId, ReportReviewStatus reviewStatus, LocalDateTime since);
}
