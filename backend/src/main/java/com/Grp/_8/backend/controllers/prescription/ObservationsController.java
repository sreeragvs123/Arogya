package com.Grp._8.backend.controllers.prescription;


import com.Grp._8.backend.dto.prescription.ObservationUpdateRequestDto;
import com.Grp._8.backend.services.prescription.ObservationsService;
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
public class ObservationsController {

    private final ObservationsService observationsService;

    @PatchMapping("/{appointmentId}/observations")
    public ResponseEntity<Void> updateObservations(
            @PathVariable Long appointmentId,
            @RequestBody ObservationUpdateRequestDto dto) {
        observationsService.updateObservations(appointmentId, dto);
        return ResponseEntity.noContent().build();
    }
}