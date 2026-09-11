package com.Grp._8.backend.services.prescription;

import com.Grp._8.backend.dto.prescription.PrescriptionItemRequestDto;
import com.Grp._8.backend.dto.prescription.PrescriptionItemResponseDto;
import com.Grp._8.backend.entities.medicine.Drug;
import com.Grp._8.backend.entities.prescription.Prescription;
import com.Grp._8.backend.entities.prescription.PrescriptionItem;
import com.Grp._8.backend.exceptions.ResourceNotFoundException;
import com.Grp._8.backend.repositories.medicine.DrugRepository;
import com.Grp._8.backend.repositories.prescription.PrescriptionItemRepository;
import com.Grp._8.backend.repositories.prescription.PrescriptionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashSet;

@Service
@RequiredArgsConstructor
public class PrescriptionItemService {

    private final PrescriptionRepository prescriptionRepository;
    private final DrugRepository drugRepository;

    @Transactional
    public PrescriptionItemResponseDto addItem(Long prescriptionId, PrescriptionItemRequestDto dto) {
        Prescription prescription = prescriptionRepository.findById(prescriptionId)
                .orElseThrow(() -> new ResourceNotFoundException("Prescription not found: " + prescriptionId));

        Drug drug = drugRepository.findById(dto.getDrugId())
                .orElseThrow(() -> new ResourceNotFoundException("Drug not found: " + dto.getDrugId()));

        PrescriptionItem item = new PrescriptionItem();
        item.setPrescription(prescription);
        item.setMedicine(drug);
        item.setDosage(dto.getDosage());
        item.setMorning(dto.getMorning());
        item.setAfternoon(dto.getAfternoon());
        item.setEvening(dto.getEvening());
        item.setWeeklyDays(dto.getWeeklyDays() != null ? dto.getWeeklyDays() : new HashSet<>());
        item.setFrequency(dto.getFrequency());
        item.setDoseTiming(dto.getDoseTiming());
        item.setStartDate(dto.getStartDate() != null ? dto.getStartDate() : LocalDate.now());
        item.setDurationDays(dto.getDurationDays());
        item.setInstructions(dto.getInstructions());

        prescription.getPrescriptionItems().add(item);
        prescriptionRepository.save(prescription);

        return toResponseDto(item, drug);
    }

    @Transactional
    public void removeItem(Long prescriptionId, Long itemId) {
        Prescription prescription = prescriptionRepository.findById(prescriptionId)
                .orElseThrow(() -> new ResourceNotFoundException("Prescription not found: " + prescriptionId));

        boolean removed = prescription.getPrescriptionItems().removeIf(i -> i.getId().equals(itemId));
        if (!removed) {
            throw new ResourceNotFoundException("Item not found: " + itemId);
        }
        prescriptionRepository.save(prescription);
    }

    private PrescriptionItemResponseDto toResponseDto(PrescriptionItem item, Drug drug) {
        return PrescriptionItemResponseDto.builder()
                .itemId(item.getId())
                .medicineName(drug.getName())
                .dosage(item.getDosage())
                .morning(item.getMorning())
                .afternoon(item.getAfternoon())
                .evening(item.getEvening())
                .weeklyDays(item.getWeeklyDays())
                .frequency(item.getFrequency())
                .doseTiming(item.getDoseTiming())
                .startDate(item.getStartDate())
                .durationDays(item.getDurationDays())
                .instructions(item.getInstructions())
                .build();
    }
}
