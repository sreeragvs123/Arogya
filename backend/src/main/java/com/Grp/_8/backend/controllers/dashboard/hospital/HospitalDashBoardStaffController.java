package com.Grp._8.backend.controllers.dashboard.hospital;

import com.Grp._8.backend.dto.auth.StaffCreateRequestDto;
import com.Grp._8.backend.dto.auth.StaffCreateResponseDto;
import com.Grp._8.backend.dto.dashboard.hosptial.HospitalDashBoardStaffSummaryDto;
import com.Grp._8.backend.entities.enums.DoctorStaffSection;
import com.Grp._8.backend.security.HospitalAuthContext;
import com.Grp._8.backend.services.auth.StaffAuthService;
import com.Grp._8.backend.services.dashboard.HospitalDashboardService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/hospital/dashboard/staff")
@RequiredArgsConstructor
@PreAuthorize("hasRole('HOSPITAL_ADMIN')")
public class HospitalDashBoardStaffController {

    private final StaffAuthService staffAuthService;
    private final HospitalDashboardService hospitalDashboardService;
    private final HospitalAuthContext hospitalAuthContext;

    @PostMapping
    public ResponseEntity<StaffCreateResponseDto> createStaff(
            @Valid @RequestBody StaffCreateRequestDto request) {
        Long hospitalId = hospitalAuthContext.requireHospitalId();
        return ResponseEntity.ok(staffAuthService.createStaff(request, hospitalId));
    }



    @GetMapping
    public ResponseEntity<Page<HospitalDashBoardStaffSummaryDto>> getAllStaff(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Long hospitalId = hospitalAuthContext.requireHospitalId();
        return ResponseEntity.ok(hospitalDashboardService.getAllStaff(hospitalId, page, size));
    }
}