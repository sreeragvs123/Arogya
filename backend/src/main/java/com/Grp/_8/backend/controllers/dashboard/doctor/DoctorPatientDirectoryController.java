package com.Grp._8.backend.controllers.dashboard.doctor;

import com.Grp._8.backend.advices.ApiResponse;
import com.Grp._8.backend.dto.dashboard.doctor.PatientDirectoryItemDto;
import com.Grp._8.backend.dto.dashboard.doctor.PatientDirectoryMetricsDto;
import com.Grp._8.backend.dto.dashboard.doctor.ScheduledConsultationDto;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.exceptions.ResourceNotFoundException;
import com.Grp._8.backend.repositories.users.DoctorRepository;
import com.Grp._8.backend.services.dashboard.impl.DoctorConsultationService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.List;

@RestController
@RequestMapping("/doctor")
@RequiredArgsConstructor
public class DoctorPatientDirectoryController {

    private final DoctorRepository doctorRepository;
    private final DoctorConsultationService.PatientDirectoryService patientDirectoryService;
    private final DoctorConsultationService consultationService;

    @GetMapping("/patients/search")
    public ResponseEntity<ApiResponse<Page<PatientDirectoryItemDto>>> searchPatients(
            @RequestParam(defaultValue = "") String q,
            @PageableDefault(size = 20, sort = "lastVisitedAt") Pageable pageable) {
        Page<PatientDirectoryItemDto> result = patientDirectoryService.search(currentDoctor(), q, pageable);
        return ResponseEntity.ok(new ApiResponse<>(result));
    }

    @GetMapping("/consultations/today")
    public ResponseEntity<ApiResponse<List<ScheduledConsultationDto>>> todayScheduled() {
        return ResponseEntity.ok(new ApiResponse<>(consultationService.todayScheduled(currentDoctor())));}

    @PatchMapping("/consultations/{appointmentId}/start")
    public ResponseEntity<ApiResponse<ScheduledConsultationDto>> startConsultation(
            @PathVariable Long appointmentId) {
        return ResponseEntity.ok(new ApiResponse<>(consultationService.start(appointmentId, currentDoctor())));}


    @GetMapping("/patients/metrics")
    public ResponseEntity<ApiResponse<PatientDirectoryMetricsDto>> metrics() {
                return ResponseEntity.ok(new ApiResponse<>(patientDirectoryService.metrics(currentDoctor())));}

        private Doctor currentDoctor() {
                Authentication auth = SecurityContextHolder.getContext().getAuthentication();
                  if (auth == null || !(auth.getPrincipal() instanceof Users user) || user.getId() == null) {
                           throw new ResourceNotFoundException("Authenticated doctor not found");
                       }
                  return doctorRepository.findByUserData_Id(user.getId())
                    .orElseThrow(() -> new ResourceNotFoundException("Doctor profile not found"));
        }
}
