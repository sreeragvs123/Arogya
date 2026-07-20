package com.Grp._8.backend.controllers.profile;


import com.Grp._8.backend.dto.profile.PatientProfileDto;
import com.Grp._8.backend.dto.profile.ProfileUpdateRequestDto;
import com.Grp._8.backend.services.files.ProfileImageService;
import com.Grp._8.backend.services.users.PaitentProfileService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;


@RestController
@RequiredArgsConstructor
@RequestMapping("/profile")
@Slf4j
public class ProfileController {

    private final PaitentProfileService profileService;
    private final ProfileImageService profileImageService;

    @PatchMapping("/update")
    public ResponseEntity<PatientProfileDto> updatePatientProfile(@RequestBody ProfileUpdateRequestDto profileDto){
        log.info("Inside updateProfileController ---");
        PatientProfileDto updatedProfile = profileService.updateProfile(profileDto);
        log.info("Profile Successfully Updated ----");
        return ResponseEntity.ok(updatedProfile);
    }

    @PutMapping("/image/upload")
    public ResponseEntity<?> addProfileImage(@RequestParam("image")MultipartFile image){
        log.info("Inside the add ProfileImage Method ---");
        try{
            String ImageUrl = profileImageService.uploadImage(image);
            log.info("Profile Image Successfully Added ---");
            return ResponseEntity.ok(Map.of("image-Url",ImageUrl));
        }
        catch(Exception e){
            log.info("Error in Uploading Profile Image ---");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error","Upload Failed : "+e.getMessage()));
        }

    }

    @GetMapping("/image")
    public String fetchProfileImage(){
        return "HI HELLO"; //need to update this method later;
    }



}
