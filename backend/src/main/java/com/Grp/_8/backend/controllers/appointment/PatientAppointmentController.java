package com.Grp._8.backend.controllers.appointment;


import com.Grp._8.backend.dto.appointment.AppointmentRejectDto;
import com.Grp._8.backend.dto.appointment.AppointmentRequestDto;
import com.Grp._8.backend.dto.appointment.AppointmentResponseDto;
import com.Grp._8.backend.dto.appointment.PatientPortalAccessRequestDto;
import com.Grp._8.backend.services.appointment.StaffAppointmentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.Grp._8.backend.entities.enums.AppointmentStatus;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RequestMapping("/appointments")
@RestController
@Slf4j
public class PatientAppointmentController {

    private final StaffAppointmentService appointmentService;

    // --- Patient: create an appointment request ---------------------------
    // patientId is pulled from the authenticated principal, never trusted from the body.
    // Swap resolvePatientId(auth) for however your JWT/session principal actually
    // exposes the patient's id.
    @PostMapping
    public ResponseEntity<AppointmentResponseDto> createAppointment(
            @Valid @RequestBody AppointmentRequestDto dto,
            Authentication authentication) {
        Long patientId = resolvePatientId(authentication);
        return ResponseEntity.ok(appointmentService.createAppointment(patientId, dto));
    }

    // --- Patient: check status of own appointments -------------------------
    @GetMapping("/mine")
    public ResponseEntity<List<AppointmentResponseDto>> getMyAppointments(Authentication authentication) {
        Long patientId = resolvePatientId(authentication);
        return ResponseEntity.ok(appointmentService.getPatientAppointments(patientId));
    }

    // --- Hospital: incoming requests queue + accept/reject ------------------
    @PatchMapping("/{appointmentId}/accept")
    public ResponseEntity<AppointmentResponseDto> accept(
            @PathVariable Long appointmentId,
            Authentication authentication) {
        Long hospitalId = resolveHospitalId(authentication);
        return ResponseEntity.ok(appointmentService.acceptAppointment(appointmentId, hospitalId));
    }

    @PatchMapping("/{appointmentId}/reject")
    public ResponseEntity<AppointmentResponseDto> reject(
            @PathVariable Long appointmentId,
            @RequestBody(required = false) AppointmentRejectDto dto,
            Authentication authentication) {
        Long hospitalId = resolveHospitalId(authentication);
        return ResponseEntity.ok(appointmentService.rejectAppointment(appointmentId, hospitalId, dto));
    }

    // --- Doctor: dashboard feed (defaults to CONFIRMED) ---------------------
    @GetMapping("/doctor")
    public ResponseEntity<List<AppointmentResponseDto>> getDoctorAppointments(
            @RequestParam(required = false) AppointmentStatus status,
            Authentication authentication) {
        Long doctorId = resolveDoctorId(authentication);
        return ResponseEntity.ok(appointmentService.getDoctorAppointments(doctorId, status));
    }

    // --- Doctor: unlock the patient portal for a confirmed appointment ------
    @PostMapping("/{appointmentId}/access")
    public ResponseEntity<?> unlockPatientPortal(
            @PathVariable Long appointmentId,
            @Valid @RequestBody PatientPortalAccessRequestDto dto,
            Authentication authentication) {
        Long doctorId = resolveDoctorId(authentication);
        boolean unlocked = appointmentService.unlockPatientPortal(doctorId, appointmentId, dto.getPassword());
        if (!unlocked) {
            return ResponseEntity.status(401).body("Invalid patient credentials");
        }
        return ResponseEntity.ok().build();
        // Once unlocked, hit your existing patient-record endpoints
        // (e.g. GET /api/patients/{id}/history) to actually render the portal.
    }

    // ------------------------------------------------------------------
    // Replace these three with real extraction from your Authentication/
    // JWT principal. Placeholder throws so it's obvious if left unwired.
    private Long resolvePatientId(Authentication authentication) {
        throw new UnsupportedOperationException("Wire this to your Patient principal");
    }

    private Long resolveDoctorId(Authentication authentication) {
        throw new UnsupportedOperationException("Wire this to your Doctor principal");
    }

    private Long resolveHospitalId(Authentication authentication) {
        throw new UnsupportedOperationException("Wire this to your Hospital principal");
    }

}
