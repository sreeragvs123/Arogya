package com.Grp._8.backend.services.appointment;

import com.Grp._8.backend.dto.appointment.AppointmentRequestDto;
import com.Grp._8.backend.dto.appointment.AppointmentResponseDto;
import com.Grp._8.backend.entities.appointment.Appointment;
import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.entities.users.*;
import com.Grp._8.backend.exceptions.AppointmentNotFoundException;
import com.Grp._8.backend.exceptions.DoctorNotFoundException;
import com.Grp._8.backend.exceptions.HospitalNotFoundException;
import com.Grp._8.backend.exceptions.PatientNotFoundException;
import com.Grp._8.backend.repositories.users.HospitalRepository;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;



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

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PatientAppointmentService {

    private final AppointmentRepository appointmentRepository;
    private final PatientRepository patientRepository;
    private final DoctorRepository doctorRepository;
    private final HospitalRepository hospitalRepository;
    private final AuthenticationManager authenticationManager;

    @Transactional(readOnly = true)
    public List<AppointmentResponseDto> getPatientAppointments() {

        UserPrincipal userPrincipal = (UserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long patientId = userPrincipal.getProfileId();

        return appointmentRepository.findByPatientIdWithDetails(patientId)
                .stream().map((appointment)->  AppointmentResponseDto.builder()
                        .appointmentAt(appointment.getAppointmentAt())
                        .id(appointment.getId())
                        .consultationType(appointment.getConsultationType())
                        .status(appointment.getStatus())
                        .build()).collect(Collectors.toList());
    }


    @Transactional
    public AppointmentResponseDto createAppointment(AppointmentRequestDto dto) {

        UserPrincipal userPatient = (UserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long patientId = userPatient.getProfileId();


        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new PatientNotFoundException("Patient not found"));
        Doctor doctor = doctorRepository.findById(dto.getDoctorId())
                .orElseThrow(() -> new DoctorNotFoundException("Doctor not found"));
        Hospital hospital = hospitalRepository.findById(dto.getHospitalId())
                .orElseThrow(()-> new HospitalNotFoundException("Hospital not found"));


        if (!doctor.getHospital().getId().equals(hospital.getId())) {
            throw new IllegalStateException("Doctor is not affiliated with the selected hospital");
        }


        Appointment appointment = new Appointment();
        appointment.setPatient(patient);
        appointment.setDoctor(doctor);
        appointment.setHospital(hospital);
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
    public void cancelAppointment(Long appointmentId) {
        UserPrincipal principal = (UserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long patientId = principal.getProfileId();

        Appointment appointment = appointmentRepository.findByIdAndPatientId(appointmentId, patientId)
                .orElseThrow(() -> new AppointmentNotFoundException("Appointment not found"));

        if (appointment.getStatus() == AppointmentStatus.COMPLETED
                || appointment.getStatus() == AppointmentStatus.CANCELLED) {
            throw new IllegalStateException("Cannot cancel an appointment that is already " + appointment.getStatus());
        }

        if (appointment.getAppointmentAt().isBefore(LocalDateTime.now())) {
            throw new IllegalStateException("Cannot cancel a past appointment");
        }

        appointment.setStatus(AppointmentStatus.CANCELLED);
        appointmentRepository.save(appointment);
    }
}
