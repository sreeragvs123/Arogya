package com.Grp._8.backend.controllers.appointment;


import com.Grp._8.backend.dto.appointment.AppointmentRequestDto;
import com.Grp._8.backend.dto.appointment.AppointmentResponseDto;
import com.Grp._8.backend.services.appointment.PatientAppointmentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RequestMapping("/patient/appointment")
@PreAuthorize("hasRole('PATIENT')")
@RestController
@Slf4j
public class PatientAppointmentController {

    private final PatientAppointmentService patientAppointmentService;


    @PostMapping
    public ResponseEntity<AppointmentResponseDto> createAppointment(@Valid @RequestBody AppointmentRequestDto dto) {
        return ResponseEntity.ok(patientAppointmentService.createAppointment(dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> cancelAppointment(@PathVariable Long id) {
        patientAppointmentService.cancelAppointment(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/mine")
    public ResponseEntity<List<AppointmentResponseDto>> getMyAppointments() {
        return ResponseEntity.ok(patientAppointmentService.getPatientAppointments());
    }




}
