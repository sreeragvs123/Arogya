package com.Grp._8.backend.services.medicine;

import com.Grp._8.backend.dto.medicine.DrugDetailResponseDto;
import com.Grp._8.backend.dto.medicine.DrugSearchResultDto;
import com.Grp._8.backend.entities.medicine.Drug;
import com.Grp._8.backend.entities.medicine.HospitalMedicine;
import com.Grp._8.backend.exceptions.ResourceNotFoundException;
import com.Grp._8.backend.repositories.medicine.DrugRepository;
import com.Grp._8.backend.repositories.medicine.HospitalMedicineRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MedicineService {

    private HospitalMedicineRepository hospitalMedicineRepository;
    private DrugRepository drugRepository;

    // Called on every keystroke in the search bar
    public List<DrugSearchResultDto> searchMedicines(Long hospitalId, String query) {
        if (query == null || query.trim().length() < 2) return List.of();

        List<HospitalMedicine> results = hospitalMedicineRepository
                .searchByHospital(hospitalId, query.trim(),
                        PageRequest.of(0, 10)); // max 10 results in dropdown

        return results.stream()
                .map(hm -> new DrugSearchResultDto(
                        hm.getDrug().getId(),
                        hm.getDrug().getName(),
                        hm.getDrug().getGenericName(),
                        hm.getDrug().getStrength(),
                        hm.getDrug().getForm(),
                        hm.getStockQuantity()
                ))
                .toList();
    }


    public DrugDetailResponseDto getDrugDetail(Long drugId, Long hospitalId) {


        Drug d = drugRepository.findById(drugId)
                .orElseThrow(() -> new ResourceNotFoundException("Drug not found"));

        Optional<HospitalMedicine> hospitalMedicine = hospitalMedicineRepository
                .findByHospitalIdAndDrugId(hospitalId, drugId);


        Integer stockQuantity = null;
        boolean availableInHospital = false;

        if (hospitalMedicine.isPresent()) {
            stockQuantity = hospitalMedicine.get().getStockQuantity();
            availableInHospital = hospitalMedicine.get().getStockQuantity() > 0;
        }

        return new DrugDetailResponseDto(
                d.getId(),
                d.getName(),
                d.getGenericName(),
                d.getBrandName(),
                d.getStrength(),
                d.getForm(),
                d.getCategory(),
                d.getContents(),
                d.getUses(),
                d.getSideEffects(),
                d.getWarnings(),
                d.getManufacturer(),
                stockQuantity,          // null if not in hospital
                availableInHospital     // false if not in hospital
        );
    }
}