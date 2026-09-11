package com.Grp._8.backend.services.observations;


import com.Grp._8.backend.dto.observations.ClinicalObservationsRequestDto;
import com.Grp._8.backend.dto.observations.ClinicalObservationsResponseDto;
import com.Grp._8.backend.dto.observations.SymptomRequestDto;
import com.Grp._8.backend.dto.observations.SymptomsResponseDto;
import com.Grp._8.backend.entities.prescription.Prescription;
import com.Grp._8.backend.exceptions.ResourceNotFoundException;
import com.Grp._8.backend.repositories.prescription.PrescriptionRepository;
import com.Grp._8.backend.services.prescription.PrescriptionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ObservationsService {

    private final PrescriptionRepository prescriptionRepository;


    @Transactional
    public ClinicalObservationsResponseDto updateObservations(Long prescriptionId, ClinicalObservationsRequestDto dto) {
        Prescription prescription = prescriptionRepository.findById(prescriptionId)
                .orElseThrow(() -> new ResourceNotFoundException("Prescription not found: " + prescriptionId));

        prescription.setClinicalObservations(dto.getClinicalObservations());
        Prescription saved = prescriptionRepository.save(prescription);

        return ClinicalObservationsResponseDto.builder()
                .prescriptionId(saved.getId())
                .clinicalObservations(saved.getClinicalObservations())
                .build();
    }

    @Transactional
    public SymptomsResponseDto addSymptom(Long prescriptionId, SymptomRequestDto dto) {
        Prescription prescription = prescriptionRepository.findById(prescriptionId)
                .orElseThrow(() -> new ResourceNotFoundException("Prescription not found: " + prescriptionId));

        String symptom = dto.getSymptom() == null ? null : dto.getSymptom().trim();
        if (symptom == null || symptom.isEmpty()) {
            throw new IllegalArgumentException("Symptom cannot be empty");
        }
        if (!prescription.getSymptoms().contains(symptom)) {
            prescription.getSymptoms().add(symptom);
        }

        Prescription saved = prescriptionRepository.save(prescription);
        return SymptomsResponseDto.builder()
                .prescriptionId(saved.getId())
                .symptoms(saved.getSymptoms())
                .build();
    }

    @Transactional
    public SymptomsResponseDto removeSymptom(Long prescriptionId, String symptom) {
        Prescription prescription = prescriptionRepository.findById(prescriptionId)
                .orElseThrow(() -> new ResourceNotFoundException("Prescription not found: " + prescriptionId));

        prescription.getSymptoms().remove(symptom);
        Prescription saved = prescriptionRepository.save(prescription);

        return SymptomsResponseDto.builder()
                .prescriptionId(saved.getId())
                .symptoms(saved.getSymptoms())
                .build();
    }
}
