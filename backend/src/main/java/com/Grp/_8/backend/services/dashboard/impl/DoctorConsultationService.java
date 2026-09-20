package com.Grp._8.backend.services.dashboard.impl;

import com.Grp._8.backend.dto.dashboard.doctor.PatientDirectoryItemDto;
import com.Grp._8.backend.dto.dashboard.doctor.PatientDirectoryMetricsDto;
import com.Grp._8.backend.dto.dashboard.doctor.ScheduledConsultationDto;
import com.Grp._8.backend.entities.appointment.Appointment;
import com.Grp._8.backend.entities.users.DoctorPatient;
import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.exceptions.ResourceNotFoundException;
import com.Grp._8.backend.repositories.appointment.AppointmentRepository;
import com.Grp._8.backend.repositories.dashboard.doctor.DoctorPatientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class DoctorConsultationService {
    private final AppointmentRepository appointmentRepository;
    private final Clock clock;

    @Transactional(readOnly = true)
    public List<ScheduledConsultationDto> todayScheduled(Doctor doctor) {
        LocalDate today = LocalDate.now(clock);
        return appointmentRepository
                .findByDoctorIdAndAppointmentAtGreaterThanEqualAndAppointmentAtLessThanAndStatusInOrderByAppointmentAtAsc(
                        doctor.getId(), today.atStartOfDay(), today.plusDays(1).atStartOfDay(),
                        Set.of(AppointmentStatus.SCHEDULED, AppointmentStatus.CONFIRMED))
                .stream().map(this::toDto).toList();
    }

    @Transactional
    public ScheduledConsultationDto start(Long appointmentId, Doctor doctor) {
        Appointment appointment = appointmentRepository.findByIdAndDoctorId(appointmentId, doctor.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Scheduled consultation not found"));

        if (appointment.getStatus() != AppointmentStatus.SCHEDULED
                && appointment.getStatus() != AppointmentStatus.CONFIRMED) {
            throw new IllegalStateException("Only a scheduled consultation can be started");
        }

        appointment.setStatus(AppointmentStatus.IN_PROGRESS);
        return toDto(appointment);
    }

    private ScheduledConsultationDto toDto(Appointment appointment) {
        return new ScheduledConsultationDto(
                appointment.getId(),
                appointment.getPatient().getId(),
                appointment.getPatient().getUserData().getName(),
                appointment.getAppointmentAt(),
                appointment.getConsultationType().name(),
                appointment.getStatus().name()
        );
    }

    @Service
    @RequiredArgsConstructor
    public static class PatientDirectoryService {
        private final DoctorPatientRepository doctorPatientRepository;
        private final Clock clock;

        @Transactional(readOnly = true)
        public Page<PatientDirectoryItemDto> search(Doctor doctor, String rawQuery, Pageable pageable) {
            String query = rawQuery == null ? "" : rawQuery.trim();
            Long patientId = query.matches("\\d+") ? Long.valueOf(query) : null;
            return doctorPatientRepository.searchDirectory(doctor.getId(), query, patientId, pageable)
                    .map(this::toDirectoryItem);
        }

        @Transactional(readOnly = true)
        public PatientDirectoryMetricsDto metrics(Doctor doctor) {
            LocalDateTime startOfMonth = LocalDate.now(clock).withDayOfMonth(1).atStartOfDay();
            return new PatientDirectoryMetricsDto(
                    doctorPatientRepository.countByDoctorIdAndActiveTrue(doctor.getId()),
                    doctorPatientRepository.countByDoctorIdAndActiveTrueAndAssignedAtGreaterThanEqual(
                            doctor.getId(), startOfMonth),
                    doctorPatientRepository.countByDoctorIdAndActiveTrueAndFollowUpDueOnLessThanEqual(
                            doctor.getId(), LocalDate.now(clock))
            );
        }

        private PatientDirectoryItemDto toDirectoryItem(DoctorPatient assignment) {
            return new PatientDirectoryItemDto(
                    assignment.getPatient().getId(),
                    assignment.getPatient().getUserData().getName(),
                    assignment.getPrimaryDiagnosis(),
                    assignment.getLastVisitedAt(),
                    assignment.getFollowUpDueOn() != null && !assignment.getFollowUpDueOn().isAfter(LocalDate.now(clock))
                            ? "FOLLOW_UP_DUE" : "ACTIVE"
            );
        }
    }
}
