package com.Grp._8.backend.controllers.prescription;

import com.Grp._8.backend.dto.prescription.VitalsUpdateRequestDto;
import com.Grp._8.backend.services.prescription.VitalsService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@PreAuthorize("hasRole('DOCTOR')")
@RequestMapping("/doctor/appointment")
@RestController
public class VitalsController {

    private final VitalsService vitalsService;

    @PatchMapping("/{appointmentId}/vitals")
    public ResponseEntity<Void> updateVitals(
            @PathVariable Long appointmentId,
            @RequestBody @Valid VitalsUpdateRequestDto dto) {
        vitalsService.updateVitals(appointmentId, dto);
        return ResponseEntity.noContent().build();
    }
}