package com.Grp._8.backend.services.users;


import com.Grp._8.backend.dto.search.HospitalSearchResponseDto;
import com.Grp._8.backend.repositories.users.HospitalRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class HospitalService {


    private final HospitalRepository hospitalRepository;

    public List<HospitalSearchResponseDto> searchHospital(String hospitalName) {
        Pageable pageable = PageRequest.of(0,10);
        Page<HospitalSearchResponseDto> page = hospitalRepository.searchByName(hospitalName,pageable);
        return page.getContent();
    }





}
