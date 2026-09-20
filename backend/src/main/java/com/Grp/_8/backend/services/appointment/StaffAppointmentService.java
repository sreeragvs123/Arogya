package com.Grp._8.backend.services.appointment;

import com.Grp._8.backend.dto.appointment.AppointmentRejectDto;
import com.Grp._8.backend.dto.appointment.AppointmentRequestDto;
import com.Grp._8.backend.dto.appointment.AppointmentResponseDto;
import com.Grp._8.backend.entities.appointment.Appointment;
import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.entities.users.Patient;
import com.Grp._8.backend.repositories.appointment.AppointmentRepository;
import com.Grp._8.backend.repositories.users.DoctorRepository;
import com.Grp._8.backend.repositories.users.PatientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StaffAppointmentService {
    private final AppointmentRepository appointmentRepository;
    private final DoctorRepository doctorRepository;
    private final PatientRepository patientRepository;
    private final PasswordEncoder passwordEncoder;



    @Transactional
    public AppointmentResponseDto createAppointment(Long patientId, AppointmentRequestDto dto) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new IllegalArgumentException("Patient not found"));
        Doctor doctor = doctorRepository.findById(dto.getDoctorId())
                .orElseThrow(() -> new IllegalArgumentException("Doctor not found"));

        Appointment appointment = new Appointment();
        appointment.setPatient(patient);
        appointment.setDoctor(doctor);
        appointment.setAppointmentAt(dto.getAppointmentAt());
        appointment.setConsultationType(dto.getConsultationType());
        appointment.setStatus(AppointmentStatus.PENDING);

        Appointment savedAppointment =  appointmentRepository.save(appointment);

        AppointmentResponseDto responseDto = AppointmentResponseDto.builder()
                .appointmentAt(appointment.getAppointmentAt())
                .id(savedAppointment.getId())
                .consultationType(savedAppointment.getConsultationType())
                .status(savedAppointment.getStatus())
                .patientName(patient.getUserData().getName())
                .doctorName(doctor.getUserData().getName())
                .doctorId(doctor.getId())
                .patientId(patient.getId())
                .build();
        return responseDto;
    }


    @Transactional
    public AppointmentResponseDto acceptAppointment(Long appointmentId, Long actingHospitalId) {
        Appointment appointment = getPendingOwnedByHospital(appointmentId, actingHospitalId);
        appointment.setStatus(AppointmentStatus.CONFIRMED);

        Appointment savedAppointment =  appointmentRepository.save(appointment);

        AppointmentResponseDto responseDto = AppointmentResponseDto.builder()
                .appointmentAt(appointment.getAppointmentAt())
                .id(savedAppointment.getId())
                .consultationType(savedAppointment.getConsultationType())
                .status(savedAppointment.getStatus())
                .build();
        return responseDto;
    }


    @Transactional
    public AppointmentResponseDto rejectAppointment(Long appointmentId, Long actingHospitalId, AppointmentRejectDto dto) {
        Appointment appointment = getPendingOwnedByHospital(appointmentId, actingHospitalId);
        appointment.setStatus(AppointmentStatus.REJECTED);
        appointment.setRejectionReason(dto != null ? dto.getReason() : null);
        Appointment savedAppointment =  appointmentRepository.save(appointment);

        AppointmentResponseDto responseDto = AppointmentResponseDto.builder()
                .appointmentAt(appointment.getAppointmentAt())
                .id(savedAppointment.getId())
                .consultationType(savedAppointment.getConsultationType())
                .status(savedAppointment.getStatus())
                .build();
        return responseDto;
    }

    private Appointment getPendingOwnedByHospital(Long appointmentId, Long actingHospitalId) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new IllegalArgumentException("Appointment not found"));

        if (!appointment.getDoctor().getHospital().getId().equals(actingHospitalId)) {
            throw new SecurityException("This appointment does not belong to your hospital");
        }
        if (appointment.getStatus() != AppointmentStatus.PENDING) {
            throw new IllegalStateException("Appointment already " + appointment.getStatus());
        }
        return appointment;
    }


    public List<AppointmentResponseDto> getDoctorAppointments(Long doctorId, AppointmentStatus status) {
        AppointmentStatus effective = status != null ? status : AppointmentStatus.CONFIRMED;

        List<AppointmentResponseDto> appointmentResponses =  appointmentRepository.findByDoctor_IdAndStatus(doctorId, effective)
                .stream().map((appointment)->  AppointmentResponseDto.builder()
                        .appointmentAt(appointment.getAppointmentAt())
                        .id(appointment.getId())
                        .consultationType(appointment.getConsultationType())
                        .status(appointment.getStatus())
                        .build()).collect(Collectors.toList());

        return appointmentResponses;
    }


    public List<AppointmentResponseDto> getPatientAppointments(Long patientId) {
        return appointmentRepository.findByPatient_IdOrderByAppointmentAtDesc(patientId)
                .stream().map((appointment)->  AppointmentResponseDto.builder()
                        .appointmentAt(appointment.getAppointmentAt())
                        .id(appointment.getId())
                        .consultationType(appointment.getConsultationType())
                        .status(appointment.getStatus())
                        .build()).collect(Collectors.toList());
    }


    @Transactional
    public boolean unlockPatientPortal(Long doctorId, Long appointmentId, String rawPassword) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new IllegalArgumentException("Appointment not found"));

        if (!appointment.getDoctor().getId().equals(doctorId)) {
            throw new SecurityException("This appointment is not assigned to you");
        }
        if (appointment.getStatus() != AppointmentStatus.CONFIRMED
                && appointment.getStatus() != AppointmentStatus.IN_PROGRESS) {
            throw new IllegalStateException("Appointment is not confirmed yet");
        }

        Patient patient = appointment.getPatient();
        boolean matches = passwordEncoder.matches(rawPassword, patient.getUserData().getPassword()); // adjust getter name

        if (matches) {
            appointment.setPatientPortalUnlocked(true);
            appointment.setStatus(AppointmentStatus.IN_PROGRESS);
            appointmentRepository.save(appointment);
        }
        return matches;
    }
}
