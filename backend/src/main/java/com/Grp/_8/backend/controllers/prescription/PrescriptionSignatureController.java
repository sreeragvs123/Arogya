package com.Grp._8.backend.controllers.prescription;


import com.Grp._8.backend.services.prescription.PrescriptionSignatureService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@RequiredArgsConstructor
@PreAuthorize("hasRole('DOCTOR')")
@RequestMapping("/doctor/appointment")
@RestController
public class PrescriptionSignatureController {

    private final PrescriptionSignatureService prescriptionSignatureService;

    // "Review Document" — returns a live-rendered PDF, nothing is saved.
    @GetMapping("/{appointmentId}/prescription/review")
    public ResponseEntity<byte[]> review(@PathVariable Long appointmentId) throws IOException {
        byte[] pdf = prescriptionSignatureService.reviewDocument(appointmentId);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=preview.pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(pdf);
    }

    // "Add Digital Signature" — uploads the signature, embeds it, finalizes and stores the PDF.
    @PatchMapping(value = "/{appointmentId}/prescription/sign", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, String>> sign(
            @PathVariable Long appointmentId,
            @RequestPart("signature") MultipartFile signature) throws IOException {
        String pdfUrl = prescriptionSignatureService.signAndFinalize(appointmentId, signature);
        return ResponseEntity.ok(Map.of("pdfUrl", pdfUrl));
    }

    @PatchMapping("/{appointmentId}/prescription/send")
    public ResponseEntity<Map<String, String>> send(@PathVariable Long appointmentId) {
        String pdfUrl = prescriptionSignatureService.sendPrescription(appointmentId);
        return ResponseEntity.ok(Map.of("pdfUrl", pdfUrl));
    }
}