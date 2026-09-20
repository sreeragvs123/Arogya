package com.Grp._8.backend.services.prescription;


import com.Grp._8.backend.dto.search.DrugSearchResponseDto;
import com.Grp._8.backend.repositories.drug.DrugRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DrugService {

    private final DrugRepository drugRepository;

    public List<DrugSearchResponseDto> searchDrugs(String query) {
        Pageable pageable = PageRequest.of(0, 10);
        Page<DrugSearchResponseDto> page = drugRepository.searchByName(query, pageable);
        return page.getContent();
    }
}