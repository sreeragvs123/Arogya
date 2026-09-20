package com.Grp._8.backend.services.prescription;


import com.Grp._8.backend.dto.prescription.ObservationUpdateRequestDto;
import com.Grp._8.backend.entities.appointment.Appointment;
import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.entities.prescription.Prescription;
import com.Grp._8.backend.entities.users.UserPrincipal;
import com.Grp._8.backend.exceptions.AppointmentNotFoundException;
import com.Grp._8.backend.exceptions.PrescriptionNotFoundException;
import com.Grp._8.backend.repositories.appointment.AppointmentRepository;
import com.Grp._8.backend.repositories.prescription.PrescriptionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ObservationsService {

    private final AppointmentRepository appointmentRepository;
    private final PrescriptionRepository prescriptionRepository;

    @PreAuthorize("hasRole('DOCTOR')")
    @Transactional
    public void updateObservations(Long appointmentId, ObservationUpdateRequestDto dto) {
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

        Prescription prescription = prescriptionRepository.findByAppointmentId(appointmentId)
                .orElseThrow(() -> new PrescriptionNotFoundException("Prescription not found for this appointment"));

        if (dto.getSymptoms() != null) {
            List<String> cleaned = dto.getSymptoms().stream()
                    .filter(s -> s != null && !s.isBlank())
                    .map(String::trim)
                    .toList();
            prescription.setSymptoms(cleaned);
        }

        if (dto.getNote() != null && !dto.getNote().isBlank()) {
            String existing = prescription.getClinicalObservations();
            String updated = (existing == null || existing.isBlank())
                    ? dto.getNote().trim()
                    : existing + "\n" + dto.getNote().trim();
            prescription.setClinicalObservations(updated);
        }

        prescriptionRepository.save(prescription);
    }
}