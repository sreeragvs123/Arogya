package com.Grp._8.backend.services.prescription;

import com.Grp._8.backend.dto.prescription.VitalsUpdateRequestDto;
import com.Grp._8.backend.entities.appointment.Appointment;
import com.Grp._8.backend.entities.enums.RecordedBy;
import com.Grp._8.backend.entities.enums.VitalStatus;
import com.Grp._8.backend.entities.enums.VitalType;
import com.Grp._8.backend.entities.histories.BloodPressureReading;
import com.Grp._8.backend.entities.histories.VitalReading;
import com.Grp._8.backend.entities.prescription.Prescription;
import com.Grp._8.backend.entities.users.Patient;
import com.Grp._8.backend.entities.users.UserPrincipal;
import com.Grp._8.backend.exceptions.AppointmentNotFoundException;
import com.Grp._8.backend.exceptions.PrescriptionNotFoundException;
import com.Grp._8.backend.repositories.appointment.AppointmentRepository;
import com.Grp._8.backend.repositories.medical_history.BloodPressureReadingRepository;
import com.Grp._8.backend.repositories.medical_history.VitalReadingRepository;
import com.Grp._8.backend.repositories.prescription.PrescriptionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class VitalsService {

    private final AppointmentRepository appointmentRepository;
    private final PrescriptionRepository prescriptionRepository;
    private final BloodPressureReadingRepository bloodPressureReadingRepository;
    private final VitalReadingRepository vitalReadingRepository;

    @PreAuthorize("hasRole('DOCTOR')")
    @Transactional
    public void updateVitals(Long appointmentId, VitalsUpdateRequestDto dto) {
        UserPrincipal principal = (UserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long doctorId = principal.getProfileId();

        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new AppointmentNotFoundException("Appointment not found"));

        if (!appointment.getDoctor().getId().equals(doctorId)) {
            throw new AccessDeniedException("This appointment is not assigned to you");
        }

        Prescription prescription = prescriptionRepository.findByAppointmentId(appointmentId)
                .orElseThrow(() -> new PrescriptionNotFoundException("Prescription not found for this appointment"));

        Patient patient = prescription.getPatient();

        // 1. Update the consultation snapshot (only fields actually sent)
        if (dto.getHeartRate() != null) prescription.setHeartRate(dto.getHeartRate());
        if (dto.getBloodPressure() != null) prescription.setBloodPressure(dto.getBloodPressure());
        if (dto.getBodyTemp() != null) prescription.setBodyTemp(dto.getBodyTemp());
        if (dto.getBloodSugar() != null) prescription.setBloodSugar(dto.getBloodSugar());
        if (dto.getWeight() != null) prescription.setWeight(dto.getWeight());
        if (dto.getHeight() != null) prescription.setHeight(dto.getHeight());
        prescriptionRepository.save(prescription);

        // 2. Fan out into trend-history tables — same visit, same values, same transaction
        if (dto.getBloodPressure() != null) {
            String[] parts = dto.getBloodPressure().split("/");
            if (parts.length != 2) {
                throw new IllegalArgumentException("Blood pressure must be in 'systolic/diastolic' format");
            }
            int systolic = Integer.parseInt(parts[0].trim());
            int diastolic = Integer.parseInt(parts[1].trim());

            bloodPressureReadingRepository.save(BloodPressureReading.builder()
                    .patient(patient)
                    .systolic(systolic)
                    .diastolic(diastolic)
                    .status(classifyBloodPressure(systolic, diastolic))
                    .recordedBy(RecordedBy.DOCTOR)
                    .build());
        }
        if (dto.getHeartRate() != null) {
            saveVitalReading(patient, appointment, VitalType.HEART_RATE, dto.getHeartRate(), "BPM");
        }
        if (dto.getBodyTemp() != null) {
            saveVitalReading(patient, appointment, VitalType.BODY_TEMP, dto.getBodyTemp(), "°F");
        }
        if (dto.getBloodSugar() != null) {
            saveVitalReading(patient, appointment, VitalType.BLOOD_SUGAR, dto.getBloodSugar(), "mg/dL");
        }
        if (dto.getWeight() != null) {
            saveVitalReading(patient, appointment, VitalType.WEIGHT, dto.getWeight(), "kg");
        }
        if (dto.getHeight() != null) {
            saveVitalReading(patient, appointment, VitalType.HEIGHT, dto.getHeight(), "cm");
        }
    }

    private void saveVitalReading(Patient patient, Appointment appointment, VitalType type, Double value, String unit) {
        vitalReadingRepository.save(VitalReading.builder()
                .patient(patient)
                .appointment(appointment)
                .type(type)
                .value(value)
                .unit(unit)
                .recordedBy(RecordedBy.DOCTOR)
                .build());
    }

    private VitalStatus classifyBloodPressure(int systolic, int diastolic) {
        if (systolic >= 180 || diastolic >= 120) return VitalStatus.CRITICAL;
        if (systolic >= 140 || diastolic >= 90) return VitalStatus.HIGH;
        if (systolic < 90 || diastolic < 60) return VitalStatus.LOW;
        return VitalStatus.NORMAL;
    }
}