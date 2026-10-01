    package com.Grp._8.backend.controllers.dashboard.hospital;

    import com.Grp._8.backend.controllers.auth.HospitalAuthController;
    import com.Grp._8.backend.dto.auth.DoctorCreateRequestDto;
    import com.Grp._8.backend.dto.auth.DoctorCreateResponseDto;
    import com.Grp._8.backend.dto.dashboard.hosptial.DoctorDetailResponseDto;
    import com.Grp._8.backend.security.HospitalAuthContext;
    import com.Grp._8.backend.services.auth.DoctorAuthService;
    import com.Grp._8.backend.services.auth.HospitalAuthService;
    import com.Grp._8.backend.services.dashboard.HospitalDashboardService;
    import jakarta.validation.Valid;
    import lombok.RequiredArgsConstructor;
    import org.springframework.http.ResponseEntity;
    import org.springframework.security.access.prepost.PreAuthorize;
    import org.springframework.web.bind.annotation.*;

    @RestController
    @RequestMapping("/hospital/dashboard/doctor")
    @RequiredArgsConstructor
    @PreAuthorize("hasRole('HOSPITAL')")
    public class HospitalDashBoardDoctorController {

        private final HospitalDashboardService hospitalDashboardService;
        private final DoctorAuthService doctorAuthService;
        private final HospitalAuthContext hospitalAuthContext;


        @GetMapping("/{doctorId}")
        public ResponseEntity<DoctorDetailResponseDto> getDoctorDetail(@PathVariable Long doctorId) {
            Long hospitalId = hospitalAuthContext.requireHospitalId();
            return ResponseEntity.ok(hospitalDashboardService.getDoctorDetail(hospitalId, doctorId));
        }

        @PostMapping("/create")
        public ResponseEntity<?> createDoctor(@RequestBody DoctorCreateRequestDto dto) {
            Long hospitalId = hospitalAuthContext.requireHospitalId();
            return ResponseEntity.ok(doctorAuthService.createDoctor(dto, hospitalId));
        }

    }
