package com.Grp._8.backend.controllers.users;

import com.Grp._8.backend.dto.search.HospitalSearchResponseDto;
import com.Grp._8.backend.services.users.DoctorService;
import com.Grp._8.backend.services.users.HospitalService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RequestMapping("/hospital")
@RestController
@Slf4j
public class HospitalController {

    private final HospitalService hospitalService;
    private final DoctorService doctorService;

    @GetMapping("/search")
    public ResponseEntity<List<HospitalSearchResponseDto>> searchHospital(@RequestParam String query){
        List<HospitalSearchResponseDto> response = hospitalService.searchHospital(query);
        return ResponseEntity.ok(response);
    }


}