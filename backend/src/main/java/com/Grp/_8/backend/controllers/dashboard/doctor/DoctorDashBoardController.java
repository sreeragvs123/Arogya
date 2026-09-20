package com.Grp._8.backend.controllers.dashboard.doctor;

import com.Grp._8.backend.dto.dashboard.doctor.DoctorDashboardSummaryDto;
import com.Grp._8.backend.services.dashboard.impl.DoctorDashBoardServiceImpl;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/doctor/{id}/dashboard")
@RequiredArgsConstructor
@Slf4j
public class DoctorDashBoardController {
    private final DoctorDashBoardServiceImpl dashboardService;

    @GetMapping("/summary")
    public ResponseEntity<DoctorDashboardSummaryDto> getSummary(@PathVariable Long id) {
        log.info("Request inside DoctorDashBoardController.getSummary");
        return ResponseEntity.ok(dashboardService.getSummary(id));
    }

}
