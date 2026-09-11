package com.Grp._8.backend.services.profile;

import com.Grp._8.backend.dto.profile.PatientProfileCardDto;
import com.Grp._8.backend.entities.enums.VitalType;
import com.Grp._8.backend.entities.histories.VitalReading;
import com.Grp._8.backend.entities.users.Patient;
import com.Grp._8.backend.repositories.medical_history.VitalReadingRepository;
import com.Grp._8.backend.repositories.users.PatientRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.Period;

@Service
@RequiredArgsConstructor
@Slf4j
public class PatientProfileCardService {

    private final PatientRepository patientRepository;
    private final VitalReadingRepository vitalReadingRepository;

    public PatientProfileCardDto getProfileCard(Long patientId) {

        Patient patient = patientRepository.findByIdWithUser(patientId)
                .orElseThrow(() -> new EntityNotFoundException("Patient not found: " + patientId));

        Double weightKg = vitalReadingRepository
                .findTop1ByPatientIdAndTypeOrderByRecordedAtDesc(patientId, VitalType.WEIGHT)
                .map(VitalReading::getValue)
                .orElse(null);

        return new PatientProfileCardDto(
                formatDisplayId(patient.getId()),
                patient.getUserData().getName(),
                calculateAge(patient.getDateOfBirth()),
                patient.getSex(),
                patient.getBloodType(),
                patient.getHeightCm(),
                weightKg,
                patient.getUserData().getProfileImageUrl()
        );
    }

    private String formatDisplayId(Long id) {
        // Placeholder scheme — adjust to whatever ID convention you settle on.
        // "AR-9920-X" style: prefix + padded id + a fixed/checksum suffix char.
        return String.format("AR-%04d-X", id);
    }

    private Integer calculateAge(LocalDate dateOfBirth) {
        if (dateOfBirth == null) return null;
        return Period.between(dateOfBirth, LocalDate.now()).getYears();
    }
}