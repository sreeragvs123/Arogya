package com.Grp._8.backend.controllers.dashboard.hospital;

import com.Grp._8.backend.dto.dashboard.hosptial.DoctorDetailResponseDto;
import com.Grp._8.backend.services.dashboard.HospitalDashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/hospital/dashboard/doctor")
@RequiredArgsConstructor
public class HospitalDashBoardDoctorController {

    private final HospitalDashboardService hospitalDashboardService;

    @GetMapping("/{hospitalId}/{doctorId}")
    public ResponseEntity<DoctorDetailResponseDto> getDoctorDetail(
            @PathVariable Long hospitalId,
            @PathVariable Long doctorId
    ) {
        return ResponseEntity.ok(
                hospitalDashboardService.getDoctorDetail(hospitalId, doctorId)
        );
    }

}
