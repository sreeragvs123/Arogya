package com.Grp._8.backend.services.prescription;

import com.Grp._8.backend.entities.appointment.Appointment;
import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.entities.enums.ReportStatus;
import com.Grp._8.backend.entities.prescription.Prescription;
import com.Grp._8.backend.entities.users.UserPrincipal;
import com.Grp._8.backend.exceptions.AppointmentNotFoundException;
import com.Grp._8.backend.exceptions.PrescriptionNotFoundException;
import com.Grp._8.backend.repositories.appointment.AppointmentRepository;
import com.Grp._8.backend.repositories.prescription.PrescriptionRepository;
import com.Grp._8.backend.services.files.PrescriptionPdfService;
import com.Grp._8.backend.services.files.StorageService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class PrescriptionSignatureService {

    private final AppointmentRepository appointmentRepository;
    private final PrescriptionRepository prescriptionRepository;
    private final PrescriptionPdfService prescriptionPdfService;
    private final StorageService storageService;

    @PreAuthorize("hasRole('DOCTOR')")
    public byte[] reviewDocument(Long appointmentId) throws IOException {
        Prescription prescription = loadAndAuthorize(appointmentId);
        return prescriptionPdfService.renderPreview(prescription);
    }

    @PreAuthorize("hasRole('DOCTOR')")
    @Transactional
    public String signAndFinalize(Long appointmentId, MultipartFile signatureImage) throws IOException {
        Prescription prescription = loadAndAuthorize(appointmentId);

        if (prescription.getStatus() != ReportStatus.PENDING_SIGNATURE) {
            throw new IllegalStateException("Prescription is not ready for signature");
        }

        String signatureUrl = storageService.upload(
                signatureImage.getBytes(),
                "SIG-" + prescription.getId() + "-" + System.currentTimeMillis());

        prescription.setSignatureImageUrl(signatureUrl);
        prescription.setSignedAt(LocalDateTime.now());
        prescription.setStatus(ReportStatus.SIGNED);

        String pdfUrl = prescriptionPdfService.generateAndStore(prescription);
        prescription.setPdfUrl(pdfUrl);

        prescriptionRepository.save(prescription);
        return pdfUrl;
    }



    @PreAuthorize("hasRole('DOCTOR')")
    @Transactional
    public String sendPrescription(Long appointmentId) {
        Prescription prescription = loadAndAuthorize(appointmentId);

        if (prescription.getStatus() != ReportStatus.SIGNED) {
            throw new IllegalStateException("Prescription must be signed before it can be sent");
        }

        if (prescription.getPdfUrl() == null) {
            String pdfUrl = prescriptionPdfService.generateAndStore(prescription);
            prescription.setPdfUrl(pdfUrl);
        }

        prescription.setStatus(ReportStatus.SENT);
        prescriptionRepository.save(prescription);

        Appointment appointment = prescription.getAppointment();
        appointment.setStatus(AppointmentStatus.COMPLETED);
        appointmentRepository.save(appointment);

        return prescription.getPdfUrl();
    }
    private Prescription loadAndAuthorize(Long appointmentId) {
        UserPrincipal principal = (UserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long doctorId = principal.getProfileId();

        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new AppointmentNotFoundException("Appointment not found"));

        if (!appointment.getDoctor().getId().equals(doctorId)) {
            throw new AccessDeniedException("This appointment is not assigned to you");
        }
        if (appointment.getStatus() != AppointmentStatus.IN_PROGRESS) {
            throw new IllegalStateException("Consultation has not started");
        }

        return prescriptionRepository.findByAppointmentId(appointmentId)
                .orElseThrow(() -> new PrescriptionNotFoundException("Prescription not found for this appointment"));
    }
}