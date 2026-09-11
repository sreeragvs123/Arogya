package com.Grp._8.backend.controllers.profile;

import com.Grp._8.backend.dto.profile.PatientProfileCardDto;
import com.Grp._8.backend.services.profile.PatientProfileCardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/patients")
@Slf4j
public class PatientProfileController {

    private final PatientProfileCardService profileCardService;

    @GetMapping("/{patientId}/card")
    public ResponseEntity<PatientProfileCardDto> getProfileCard(@PathVariable Long patientId) {
        log.info("Fetching profile card for patientId={}", patientId);
        PatientProfileCardDto card = profileCardService.getProfileCard(patientId);
        return ResponseEntity.ok(card);
    }
}