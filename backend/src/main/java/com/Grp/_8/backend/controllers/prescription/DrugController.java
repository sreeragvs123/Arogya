package com.Grp._8.backend.controllers.prescription;


import com.Grp._8.backend.dto.search.DrugSearchResponseDto;
import com.Grp._8.backend.services.prescription.DrugService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RequiredArgsConstructor
@PreAuthorize("hasRole('DOCTOR')")
@RequestMapping("/doctor/medicine")
@RestController
public class DrugController {

    private final DrugService drugService;

    @GetMapping("/search")
    public List<DrugSearchResponseDto> search(@RequestParam String query) {
        return drugService.searchDrugs(query);
    }
}