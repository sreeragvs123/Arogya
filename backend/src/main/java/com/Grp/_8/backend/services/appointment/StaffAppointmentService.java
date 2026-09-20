package com.Grp._8.backend.services.appointment;

import com.Grp._8.backend.dto.appointment.AppointmentRejectDto;
import com.Grp._8.backend.dto.appointment.AppointmentResponseDto;
import com.Grp._8.backend.entities.appointment.Appointment;
import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.entities.users.Staff;
import com.Grp._8.backend.entities.users.UserPrincipal;
import com.Grp._8.backend.exceptions.AppointmentNotFoundException;
import com.Grp._8.backend.exceptions.StaffNotFoundException;
import com.Grp._8.backend.repositories.appointment.AppointmentRepository;
import com.Grp._8.backend.repositories.users.DoctorRepository;
import com.Grp._8.backend.repositories.users.PatientRepository;
import com.Grp._8.backend.repositories.users.StaffRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Service
@RequiredArgsConstructor
public class StaffAppointmentService {
    private final AppointmentRepository appointmentRepository;
    private final DoctorRepository doctorRepository;
    private final PatientRepository patientRepository;
    private final StaffRepository staffRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;



    @Transactional(readOnly = true)
    public List<AppointmentResponseDto> getPendingAppointmentsForDepartment() {
        UserPrincipal principal = (UserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long staffId = principal.getProfileId();

        Staff staff = staffRepository.findById(staffId)
                .orElseThrow(() -> new StaffNotFoundException("Staff not found"));

        return appointmentRepository.findByHospitalIdAndDoctorDepartmentAndStatus(
                        staff.getHospital().getId(), staff.getDepartment(), AppointmentStatus.PENDING)
                .stream()
                .map(appointment -> AppointmentResponseDto.builder()
                        .id(appointment.getId())
                        .appointmentAt(appointment.getAppointmentAt())
                        .consultationType(appointment.getConsultationType())
                        .status(appointment.getStatus())
                        .doctorId(appointment.getDoctor().getId())
                        .doctorName(appointment.getDoctor().getUserData().getName())
                        .patientName(appointment.getPatient().getUserData().getName())
                        .build())
                .toList();
    }

    @Transactional
    public AppointmentResponseDto acceptAppointment(Long appointmentId, Long hospitalId) {
        UserPrincipal principal = (UserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Staff staff = staffRepository.findById(principal.getProfileId())
                .orElseThrow(() -> new StaffNotFoundException("Staff not found"));

        if (!staff.getHospital().getId().equals(hospitalId)) {
            throw new IllegalArgumentException("Hospital mismatch — please refresh and try again");
        }

        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new AppointmentNotFoundException("Appointment not found"));

        if (!appointment.getHospital().getId().equals(staff.getHospital().getId())
                || appointment.getDoctor().getDepartment() != staff.getDepartment()) {
            throw new AccessDeniedException("This appointment is not in your department");
        }
        if (appointment.getStatus() != AppointmentStatus.PENDING) {
            throw new IllegalStateException("Only pending appointments can be accepted");
        }

        appointment.setStatus(AppointmentStatus.CONFIRMED);
        Appointment saved = appointmentRepository.save(appointment);

        return AppointmentResponseDto.builder()
                .id(saved.getId())
                .appointmentAt(saved.getAppointmentAt())
                .consultationType(saved.getConsultationType())
                .status(saved.getStatus())
                .build();
    }


    @Transactional
    public AppointmentResponseDto rejectAppointment(Long appointmentId, Long hospitalId, AppointmentRejectDto dto) {
        UserPrincipal principal = (UserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Staff staff = staffRepository.findById(principal.getProfileId())
                .orElseThrow(() -> new StaffNotFoundException("Staff not found"));

        if (!staff.getHospital().getId().equals(hospitalId)) {
            throw new IllegalArgumentException("Hospital mismatch — please refresh and try again");
        }

        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new AppointmentNotFoundException("Appointment not found"));

        if (!appointment.getHospital().getId().equals(staff.getHospital().getId())
                || appointment.getDoctor().getDepartment() != staff.getDepartment()) {
            throw new AccessDeniedException("This appointment is not in your department");
        }
        if (appointment.getStatus() != AppointmentStatus.PENDING) {
            throw new IllegalStateException("Only pending appointments can be rejected");
        }

        appointment.setStatus(AppointmentStatus.REJECTED);
        if (dto != null) {
            appointment.setRejectionReason(dto.getReason());
        }
        Appointment saved = appointmentRepository.save(appointment);

        return AppointmentResponseDto.builder()
                .id(saved.getId())
                .appointmentAt(saved.getAppointmentAt())
                .consultationType(saved.getConsultationType())
                .status(saved.getStatus())
                .rejectionReason(saved.getRejectionReason())
                .build();
    }


}
