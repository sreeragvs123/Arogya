package com.Grp._8.backend.controllers.prescription.patient;


import com.Grp._8.backend.dto.prescription.PrescriptionSummaryResponseDto;
import com.Grp._8.backend.services.prescription.PatientPrescriptionService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@PreAuthorize("hasRole('PATIENT')")
@RequestMapping("/patient/appointment")
@RestController
public class PatientPrescriptionController {

    private final PatientPrescriptionService patientPrescriptionService;

    @GetMapping("/{appointmentId}/prescription")
    public PrescriptionSummaryResponseDto getPrescription(@PathVariable Long appointmentId) {
        return patientPrescriptionService.getPrescription(appointmentId);
    }
}