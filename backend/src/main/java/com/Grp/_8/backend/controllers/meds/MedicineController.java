package com.Grp._8.backend.controllers.meds;


import com.Grp._8.backend.dto.medicine.DrugDetailResponseDto;
import com.Grp._8.backend.dto.medicine.DrugSearchResultDto;
import com.Grp._8.backend.services.medicine.MedicineService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/medicines")
public class MedicineController {

    private MedicineService medicineService;


    @GetMapping("/search")
    public ResponseEntity<List<DrugSearchResultDto>> search(
            @RequestParam Long hospitalId,
            @RequestParam String query
    ) {
        return ResponseEntity.ok(medicineService.searchMedicines(hospitalId, query));
    }

    // Full detail — called when doctor selects a medicine
    @GetMapping("/{drugId}/detail")
    public ResponseEntity<DrugDetailResponseDto> getDetail(
            @PathVariable Long drugId,
            @RequestParam Long hospitalId
    ) {
        return ResponseEntity.ok(medicineService.getDrugDetail(drugId, hospitalId));
    }
}