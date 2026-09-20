package com.Grp._8.backend.services.prescription;


import com.Grp._8.backend.dto.prescription.PrescriptionSummaryResponseDto;
import com.Grp._8.backend.entities.enums.ReportStatus;
import com.Grp._8.backend.entities.prescription.Prescription;
import com.Grp._8.backend.entities.prescription.PrescriptionItem;
import com.Grp._8.backend.entities.users.UserPrincipal;
import com.Grp._8.backend.exceptions.PrescriptionNotFoundException;
import com.Grp._8.backend.repositories.prescription.PrescriptionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class PatientPrescriptionService {

    private final PrescriptionRepository prescriptionRepository;

    @PreAuthorize("hasRole('PATIENT')")
    @Transactional(readOnly = true)
    public PrescriptionSummaryResponseDto getPrescription(Long appointmentId) {
        UserPrincipal principal = (UserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long patientId = principal.getProfileId();

        Prescription prescription = prescriptionRepository.findByAppointmentIdAndPatientId(appointmentId, patientId)
                .orElseThrow(() -> new PrescriptionNotFoundException("Prescription not found for this appointment"));

        if (prescription.getStatus() != ReportStatus.SENT) {
            throw new PrescriptionNotFoundException("Prescription is not yet available");
        }

        return PrescriptionSummaryResponseDto.builder()
                .pdfUrl(prescription.getPdfUrl())
                .doctorName(prescription.getDoctor().getUserData().getName())
                .hospitalName(prescription.getHospital().getUserData().getName())
                .referenceNumber(prescription.getReferenceNumber())
                .signedAt(prescription.getSignedAt())
                .symptoms(prescription.getSymptoms())
                .clinicalObservations(prescription.getClinicalObservations())
                .items(prescription.getPrescriptionItems().stream()
                        .map(this::toItemSummary)
                        .toList())
                .build();
    }

    private PrescriptionSummaryResponseDto.PrescriptionItemSummary toItemSummary(PrescriptionItem item) {
        return PrescriptionSummaryResponseDto.PrescriptionItemSummary.builder()
                .medicineName(item.getMedicine().getName())
                .dosage(item.getDosage())
                .frequency(formatFrequency(item))
                .durationDays(item.getDurationDays())
                .doseTiming(item.getDoseTiming() != null ? item.getDoseTiming().toString() : null)
                .build();
    }

    private String formatFrequency(PrescriptionItem item) {
        return (Boolean.TRUE.equals(item.getMorning()) ? "1" : "0") + "-"
                + (Boolean.TRUE.equals(item.getAfternoon()) ? "1" : "0") + "-"
                + (Boolean.TRUE.equals(item.getEvening()) ? "1" : "0");
    }
}