package com.Grp._8.backend.controllers.appointment;


import com.Grp._8.backend.dto.appointment.AppointmentResponseDto;
import com.Grp._8.backend.dto.appointment.AppointmentsNumberResponseDto;
import com.Grp._8.backend.dto.appointment.PatientPortalAccessRequestDto;
import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.repositories.appointment.AppointmentRepository;
import com.Grp._8.backend.services.appointment.DoctorAppointmentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RequestMapping("/doctor/{doctorId}/{hospitalId}/appointments")
@RestController
@Slf4j
@PreAuthorize("hasRole('DOCTOR')")
public class DoctorAppointmentController {

    private final DoctorAppointmentService doctorAppointmentService;

    @GetMapping("/count")
    public ResponseEntity<AppointmentsNumberResponseDto> getDoctorAppointmentsCount(@PathVariable Long doctorId, @PathVariable Long hospitalId) {
            AppointmentsNumberResponseDto appointmentsNumberResponseDto = doctorAppointmentService.getDoctorAppointmentsCount(doctorId,hospitalId);
            return ResponseEntity.ok(appointmentsNumberResponseDto);
    }

    @GetMapping("/today")
    public ResponseEntity<Page<AppointmentResponseDto>> getTodaysAppointments(
            @PathVariable Long doctorId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        return ResponseEntity.ok(doctorAppointmentService.getTodaysAppointments(doctorId, page, size));
    }

    @GetMapping("/upcoming")
    public ResponseEntity<Page<AppointmentResponseDto>> getUpcomingAppointments(
            @PathVariable Long doctorId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        return ResponseEntity.ok(doctorAppointmentService.getUpcomingAppointments(doctorId, page, size));
    }



    @GetMapping("/doctor")
    public ResponseEntity<List<AppointmentResponseDto>> getDoctorAppointments(
            @RequestParam(required = false) AppointmentStatus status
            ) {

        return ResponseEntity.ok(doctorAppointmentService.getDoctorAppointments(status));
    }


    @PostMapping("/{appointmentId}/access")
    public ResponseEntity<?> unlockPatientPortal(
            @PathVariable Long appointmentId,
            @Valid @RequestBody PatientPortalAccessRequestDto dto
           ) {

        boolean unlocked = doctorAppointmentService.unlockPatientPortal(appointmentId, dto.getPassword());
        if (!unlocked) {
            return ResponseEntity.status(401).body("Invalid patient credentials");
        }
        return ResponseEntity.ok().build();

    }
}
