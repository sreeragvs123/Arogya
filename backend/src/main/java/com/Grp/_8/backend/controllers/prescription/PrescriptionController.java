package com.Grp._8.backend.controllers.prescription;


import com.Grp._8.backend.dto.observations.ClinicalObservationsRequestDto;
import com.Grp._8.backend.dto.observations.ClinicalObservationsResponseDto;
import com.Grp._8.backend.dto.observations.SymptomRequestDto;
import com.Grp._8.backend.dto.observations.SymptomsResponseDto;
import com.Grp._8.backend.dto.prescription.*;
import com.Grp._8.backend.dto.vitals.VitalsResponseDto;
import com.Grp._8.backend.dto.vitals.VitalsUpdateRequestDto;
import com.Grp._8.backend.services.observations.ObservationsService;
import com.Grp._8.backend.services.prescription.PrescriptionItemService;
import com.Grp._8.backend.services.prescription.PrescriptionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequestMapping("/prescriptions")
@RequiredArgsConstructor
public class PrescriptionController {

    private final PrescriptionService prescriptionService;
    private final PrescriptionItemService prescriptionItemService;
    private final ObservationsService observationsService;

    @PostMapping("/{id}/generate")
    public ResponseEntity<PrescriptionResponseDto> generate(@PathVariable Long id) throws IOException {
        return ResponseEntity.ok(prescriptionService.generateAndSend(id));
    }

    @PostMapping
    public ResponseEntity<PrescriptionDraftResponseDto> createDraft(@RequestBody PrescriptionDraftRequestDto request) {
        PrescriptionDraftResponseDto prescription = prescriptionService.createDraft(request.getPatientId(), request.getDoctorId());//TODO : get the doctor id from securityContext
        return ResponseEntity.status(HttpStatus.CREATED).body(prescription);
    }


    @PatchMapping("/{id}/vitals")
    public ResponseEntity<VitalsResponseDto> updateVitals(@PathVariable Long id, @RequestBody VitalsUpdateRequestDto request) {
        VitalsResponseDto vitalsResponseDto = prescriptionService.updateVitals(id, request);
        return ResponseEntity.ok(vitalsResponseDto);
    }

    @PostMapping("/{id}/items")
    public ResponseEntity<PrescriptionItemResponseDto> addItem(@PathVariable Long id, @RequestBody PrescriptionItemRequestDto request) {
        PrescriptionItemResponseDto prescriptionItemResponseDto = prescriptionItemService.addItem(id, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(prescriptionItemResponseDto);
    }

    @DeleteMapping("/{id}/items/{itemId}")
    public ResponseEntity<Void> removeItem(@PathVariable Long id, @PathVariable Long itemId) {
        prescriptionItemService.removeItem(id, itemId);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/observations")
    public ResponseEntity<ClinicalObservationsResponseDto> updateObservations(@PathVariable Long id, @RequestBody ClinicalObservationsRequestDto request) {
        return ResponseEntity.ok(observationsService.updateObservations(id, request));
    }

    @PostMapping("/{id}/symptoms")
    public ResponseEntity<SymptomsResponseDto> addSymptom(@PathVariable Long id, @RequestBody SymptomRequestDto request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(observationsService.addSymptom(id, request));
    }

    @DeleteMapping("/{id}/symptoms/{symptom}")
    public ResponseEntity<SymptomsResponseDto> removeSymptom(@PathVariable Long id, @PathVariable String symptom) {
        return ResponseEntity.ok(observationsService.removeSymptom(id, symptom));
    }
}