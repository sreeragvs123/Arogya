package com.Grp._8.backend.services.appointment;


import com.Grp._8.backend.dto.appointment.AppointmentResponseDto;
import com.Grp._8.backend.dto.appointment.AppointmentsNumberResponseDto;
import com.Grp._8.backend.entities.appointment.Appointment;
import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.entities.users.Hospital;
import com.Grp._8.backend.entities.users.Patient;
import com.Grp._8.backend.entities.users.UserPrincipal;
import com.Grp._8.backend.exceptions.AppointmentNotFoundException;
import com.Grp._8.backend.exceptions.DoctorNotFoundException;
import com.Grp._8.backend.exceptions.HospitalNotFoundException;
import com.Grp._8.backend.repositories.appointment.AppointmentRepository;
import com.Grp._8.backend.repositories.users.DoctorRepository;
import com.Grp._8.backend.repositories.users.HospitalRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.YearMonth;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DoctorAppointmentService {
    private final AppointmentRepository appointmentRepository;
    private final DoctorRepository doctorRepository;
    private final HospitalRepository hospitalRepository;
    private final PasswordEncoder passwordEncoder;


    public AppointmentsNumberResponseDto getDoctorAppointmentsCount(Long doctorId, Long hospitalId) {

        Doctor doctor = doctorRepository.findById(doctorId).orElseThrow(
                ()-> new DoctorNotFoundException("Doctor not found with id: " + doctorId)
        );

        Hospital hospital = hospitalRepository.findById(hospitalId).orElseThrow( ()-> new HospitalNotFoundException(
                "Hospital not found with id: " + hospitalId
        ));

        List<Patient> allPatients = appointmentRepository.findDistinctPatientsByDoctorId(doctorId);
        int totalPatients = allPatients.size();

        // New patients this month (first-ever appointment with this doctor falls in current month)
        LocalDateTime start = YearMonth.now().atDay(1).atStartOfDay();
        LocalDateTime end = YearMonth.now().atEndOfMonth().atTime(LocalTime.MAX);
        List<Patient> newPatientsThisMonth = appointmentRepository.findNewPatientsInRange(doctorId, start, end);
        int newThisMonthCount = newPatientsThisMonth.size();

        return AppointmentsNumberResponseDto.builder()
                .totalPatients(totalPatients)
                .newPatientsThisMonth(newThisMonthCount)
                .build();

    }

    public Page<AppointmentResponseDto> getTodaysAppointments(Long doctorId, int page, int size) {
        validateDoctorExists(doctorId);

        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);

        Pageable pageable = PageRequest.of(page, size, Sort.by("appointmentAt").ascending());

        return appointmentRepository
                .findByDoctor_IdAndAppointmentAtBetween(doctorId, startOfDay, endOfDay, pageable)
                .map(appointment -> AppointmentResponseDto.builder()
                        .appointmentAt(appointment.getAppointmentAt())
                        .id(appointment.getId())
                        .consultationType(appointment.getConsultationType())
                        .status(appointment.getStatus())
                        .build());
    }


    @Transactional(readOnly = true)
    public List<AppointmentResponseDto> getDoctorAppointments(AppointmentStatus status) {
        UserPrincipal principal = (UserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long doctorId = principal.getProfileId();
        AppointmentStatus effective = status != null ? status : AppointmentStatus.CONFIRMED;

        return appointmentRepository.findByDoctorIdAndStatus(doctorId, effective)
                .stream()
                .map(appointment -> AppointmentResponseDto.builder()
                        .id(appointment.getId())
                        .appointmentAt(appointment.getAppointmentAt())
                        .consultationType(appointment.getConsultationType())
                        .status(appointment.getStatus())
                        .build())
                .toList();
    }




    @Transactional
    public boolean unlockPatientPortal(Long appointmentId, String rawPassword) {
        UserPrincipal principal = (UserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long doctorId = principal.getProfileId();

        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new AppointmentNotFoundException("Appointment not found"));

        if (!appointment.getDoctor().getId().equals(doctorId)) {
            throw new AccessDeniedException("This appointment is not assigned to you");
        }
        return false;
    }

    public Page<AppointmentResponseDto> getUpcomingAppointments(Long doctorId, int page, int size) {
        validateDoctorExists(doctorId);

        LocalDateTime endOfToday = LocalDate.now().atTime(LocalTime.MAX);

        Pageable pageable = PageRequest.of(page, size, Sort.by("appointmentAt").ascending());

        return appointmentRepository
                .findByDoctor_IdAndAppointmentAtAfter(doctorId, endOfToday, pageable)
                .map(appointment -> AppointmentResponseDto.builder()
                        .appointmentAt(appointment.getAppointmentAt())
                        .id(appointment.getId())
                        .consultationType(appointment.getConsultationType())
                        .status(appointment.getStatus())
                        .build());
    }

    private void validateDoctorExists(Long doctorId) {
        doctorRepository.findById(doctorId).orElseThrow(
                () -> new DoctorNotFoundException("Doctor not found with id: " + doctorId)
        );
    }
}
