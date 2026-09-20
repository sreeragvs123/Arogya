package com.Grp._8.backend.controllers.appointment;

import com.Grp._8.backend.dto.appointment.AppointmentRejectDto;
import com.Grp._8.backend.dto.appointment.AppointmentResponseDto;
import com.Grp._8.backend.dto.appointment.PatientPortalAccessRequestDto;
import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.entities.enums.Department;
import com.Grp._8.backend.services.appointment.StaffAppointmentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@PreAuthorize("hasRole('STAFF')")
@RequestMapping("/staff/appointment")
@RestController
@Slf4j
public class StaffAppointmentController {

    private final StaffAppointmentService staffAppointmentService;

    @GetMapping("/pending")
    public ResponseEntity<List<AppointmentResponseDto>> pending() {
        return ResponseEntity.ok(staffAppointmentService.getPendingAppointmentsForDepartment());
    }

    @PatchMapping("/{appointmentId}/{hospitalId}/accept")
    public ResponseEntity<AppointmentResponseDto> accept(
            @PathVariable Long appointmentId, @PathVariable Long hospitalId) {
        return ResponseEntity.ok(staffAppointmentService.acceptAppointment(appointmentId, hospitalId));
    }

    @PatchMapping("/{appointmentId}/{hospitalId}/reject")
    public ResponseEntity<AppointmentResponseDto> reject(
            @PathVariable Long appointmentId,
            @PathVariable Long hospitalId,
            @RequestBody(required = false) AppointmentRejectDto dto) {
        return ResponseEntity.ok(staffAppointmentService.rejectAppointment(appointmentId, hospitalId, dto));
    }

}
