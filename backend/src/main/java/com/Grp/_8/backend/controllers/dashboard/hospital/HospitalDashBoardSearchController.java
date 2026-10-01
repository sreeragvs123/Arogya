package com.Grp._8.backend.controllers.dashboard.hospital;


import com.Grp._8.backend.dto.dashboard.hosptial.HospitalDashBoardDoctorSearchResponseDto;
import com.Grp._8.backend.dto.dashboard.hosptial.HospitalDashboardMetricsDto;
import com.Grp._8.backend.entities.enums.DoctorStaffSection;
import com.Grp._8.backend.security.HospitalAuthContext;
import com.Grp._8.backend.services.dashboard.HospitalDashboardService;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/hospital/dashboard/search")
@RequiredArgsConstructor
@PreAuthorize("hasRole('HOSPITAL')")
public class HospitalDashBoardSearchController {

    private final HospitalDashboardService hospitalDashboardService; // interface, not Impl
    private final HospitalAuthContext hospitalAuthContext;

    @GetMapping("/doctors")
    public ResponseEntity<Page<HospitalDashBoardDoctorSearchResponseDto>> getDoctorsBySection(
            @RequestParam DoctorStaffSection section,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(50) int size
    ) {
        Long hospitalId = hospitalAuthContext.requireHospitalId();
        return ResponseEntity.ok(
                hospitalDashboardService.getDoctorsBySection(hospitalId, section, page, size));
    }

    @GetMapping("/query")
    public ResponseEntity<Page<HospitalDashBoardDoctorSearchResponseDto>> searchDoctorsByQuery(
            @RequestParam DoctorStaffSection section,
            @RequestParam String query,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(50) int size
    ) {
        Long hospitalId = hospitalAuthContext.requireHospitalId();
        return ResponseEntity.ok(
                hospitalDashboardService.searchDoctorsByQuery(hospitalId, section, query, page, size));
    }

    @GetMapping("/doctors/specializations")
    public ResponseEntity<List<String>> getSpecializations() {
        Long hospitalId = hospitalAuthContext.requireHospitalId();
        return ResponseEntity.ok(hospitalDashboardService.getSpecializations(hospitalId));
    }

    @GetMapping("/doctors/filter-specialization")
    public ResponseEntity<Page<HospitalDashBoardDoctorSearchResponseDto>> filterDoctorsBySpecialization(
            @RequestParam DoctorStaffSection section,
            @RequestParam String specialization,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(50) int size
    ) {
        Long hospitalId = hospitalAuthContext.requireHospitalId();
        return ResponseEntity.ok(
                hospitalDashboardService.filterDoctorsBySpecialization(
                        hospitalId, section, specialization, page, size));
    }

    @GetMapping("/metrics")
    public ResponseEntity<HospitalDashboardMetricsDto> getMetrics() {
        Long hospitalId = hospitalAuthContext.requireHospitalId();
        return ResponseEntity.ok(hospitalDashboardService.getMetrics(hospitalId));
    }
}