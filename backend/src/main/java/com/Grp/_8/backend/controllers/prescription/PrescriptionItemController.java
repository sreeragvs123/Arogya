package com.Grp._8.backend.controllers.prescription;

import com.Grp._8.backend.dto.prescription.PrescriptionItemsUpdateRequestDto;
import com.Grp._8.backend.services.prescription.PrescriptionItemService;
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
public class PrescriptionItemController {

    private final PrescriptionItemService prescriptionItemService;

    @PatchMapping("/{appointmentId}/prescription-items")
    public ResponseEntity<Void> updatePrescriptionItems(
            @PathVariable Long appointmentId,
            @RequestBody PrescriptionItemsUpdateRequestDto dto) {
        prescriptionItemService.updatePrescriptionItems(appointmentId, dto);
        return ResponseEntity.noContent().build();
    }
}