package com.Grp._8.backend.controllers.dashboard.hospital;


import com.Grp._8.backend.dto.dashboard.hosptial.HospitalDashBoardDoctorSearchResponseDto;
import com.Grp._8.backend.dto.dashboard.hosptial.HospitalDashboardMetricsDto;
import com.Grp._8.backend.entities.enums.DoctorStaffSection;
import com.Grp._8.backend.services.dashboard.impl.HospitalDashboardServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/hospital/dashboard")
@RequiredArgsConstructor
public class HospitalDashBoardController {

    private final HospitalDashboardServiceImpl hospitalDashboardService;


    @GetMapping("/{hospitalId}/doctors")
    public ResponseEntity<Page<HospitalDashBoardDoctorSearchResponseDto>> getDoctorsBySection(
            @PathVariable Long hospitalId,
            @RequestParam DoctorStaffSection section,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        return ResponseEntity.ok(
                hospitalDashboardService.getDoctorsBySection(
                        hospitalId, section, page, size
                )
        );
    }

    @GetMapping("/{hospitalId}/doctors/search")
    public ResponseEntity<Page<HospitalDashBoardDoctorSearchResponseDto>> searchDoctorsByQuery(
            @PathVariable Long hospitalId,
            @RequestParam DoctorStaffSection section,
            @RequestParam String query,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        return ResponseEntity.ok(
                hospitalDashboardService.searchDoctorsByQuery(
                        hospitalId, section, query, page, size
                )
        );
    }

    @GetMapping("/{hospitalId}/doctors/specializations")
    public ResponseEntity<List<String>> getSpecializations(
            @PathVariable Long hospitalId
    ) {
        return ResponseEntity.ok(
                hospitalDashboardService.getSpecializations(hospitalId)
        );
    }


    @GetMapping("/{hospitalId}/doctors/filter-specialization")
    public ResponseEntity<Page<HospitalDashBoardDoctorSearchResponseDto>> filterDoctorsBySpecialization(
            @PathVariable Long hospitalId,
            @RequestParam DoctorStaffSection section,
            @RequestParam String specialization,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        return ResponseEntity.ok(
                hospitalDashboardService.filterDoctorsBySpecialization(
                        hospitalId, section, specialization, page, size
                )
        );
    }


    @GetMapping("/{hospitalId}/metrics")
    public ResponseEntity<HospitalDashboardMetricsDto> getMetrics(@PathVariable Long hospitalId){
        HospitalDashboardMetricsDto metricsDto = hospitalDashboardService.getMetrics(hospitalId);
        return ResponseEntity.ok(metricsDto);
    }


}
