package com.Grp._8.backend.services.appointment;


import com.Grp._8.backend.dto.appointment.AppointmentResponseDto;
import com.Grp._8.backend.dto.appointment.AppointmentsNumberResponseDto;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.entities.users.Hospital;
import com.Grp._8.backend.entities.users.Patient;
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
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.YearMonth;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DoctorAppointmentService {
    private final AppointmentRepository appointmentRepository;
    private final DoctorRepository doctorRepository;
    private final HospitalRepository hospitalRepository;


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
