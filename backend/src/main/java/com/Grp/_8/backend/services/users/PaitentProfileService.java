package com.Grp._8.backend.services.users;


import com.Grp._8.backend.dto.profile.PatientProfileDto;
import com.Grp._8.backend.dto.profile.ProfileUpdateRequestDto;
import com.Grp._8.backend.entities.enums.VitalType;
import com.Grp._8.backend.entities.users.Patient;
import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.entities.vital_history.BloodPressureReading;
import com.Grp._8.backend.entities.vital_history.VitalReading;
import com.Grp._8.backend.exceptions.ResourceNotFoundException;
import com.Grp._8.backend.repositories.medical_history.BloodPressureReadingRepository;
import com.Grp._8.backend.repositories.users.PaitentRepository;
import com.Grp._8.backend.repositories.users.UserRepository;
import com.Grp._8.backend.repositories.medical_history.VitalReadingRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Slf4j
public class PaitentProfileService {

    private final PaitentRepository patientRepository;
    private final UserRepository userRepository;
    private final VitalReadingRepository vitalReadingRepository;
    private final BloodPressureReadingRepository bloodPressureReadingRepository;

    public PatientProfileDto updateProfile(ProfileUpdateRequestDto profileDto) {
        Users users = (Users) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long userId = users.getId();

        log.info("Fetching the corresponding Patient Entity");
        Patient patient = patientRepository.findByUserData_Id(userId).orElseThrow(
                ()-> new ResourceNotFoundException("Paitent with user-id : "+userId+" not Found")
        );

        //updating - Users Entity
        log.info("Updating Users Entity");
        if(profileDto.getName() != null){
            users.setName(profileDto.getName());
            userRepository.save(users);
        }

        //updating - Patient Entity
        log.info("Updating Patient Entity");
        if (profileDto.getDateOfBirth() != null) {
            patient.setDateOfBirth(profileDto.getDateOfBirth());
        }
        if (profileDto.getHeightCm() != null){
            patient.setHeightCm(profileDto.getHeightCm());
        }
        if (profileDto.getBloodType() != null) {
            patient.setBloodType(profileDto.getBloodType());
        }
        patientRepository.save(patient);


        //updating - VitalReading Entity
        log.info("Updating Vitals");
        addVitalsIfPresent(patient,VitalType.BLOOD_SUGAR, profileDto.getBloodSugar(), "mg/dL");
        addVitalsIfPresent(patient,VitalType.BODY_FAT, profileDto.getBodyFat(), "%");
        addVitalsIfPresent(patient,VitalType.WEIGHT, profileDto.getWeightKg(), "kg");


        //updaing - Bp Entity
        log.info("Updating Blood Pressure");
        if (profileDto.getSystolicBp() != null && profileDto.getDiastolicBp() != null) {
            BloodPressureReading bp = new BloodPressureReading();
            bp.setPatient(patient);
            bp.setSystolic(profileDto.getSystolicBp());
            bp.setDiastolic(profileDto.getDiastolicBp());
            bloodPressureReadingRepository.save(bp);
        }

        //building Response
        log.info("Building Response");
        return buildProfileDto(patient, users);


    }


    private void addVitalsIfPresent(Patient patient, VitalType type, Double value, String unit){
        if(value == null)return;
        VitalReading newReading = VitalReading.builder()
                .patient(patient)
                .type(type)
                .unit(unit)
                .value(value)
                .patient(patient)
                .build();
        vitalReadingRepository.save(newReading);
    }


    private PatientProfileDto buildProfileDto(Patient patient, Users users) {
        Double latestWeight = vitalReadingRepository
                .findTop1ByPatientIdAndTypeOrderByRecordedAtDesc(patient.getId(), VitalType.WEIGHT)
                .map(VitalReading::getValue).orElse(null);

        Double latestSugar = vitalReadingRepository
                .findTop1ByPatientIdAndTypeOrderByRecordedAtDesc(patient.getId(), VitalType.BLOOD_SUGAR)
                .map(VitalReading::getValue).orElse(null);

        Double latestBodyFat = vitalReadingRepository
                .findTop1ByPatientIdAndTypeOrderByRecordedAtDesc(patient.getId(), VitalType.BODY_FAT)
                .map(VitalReading::getValue).orElse(null);

        BloodPressureReading latestBp = bloodPressureReadingRepository
                .findTop1ByPatientIdOrderByRecordedAtDesc(patient.getId())
                .orElse(null);

        return PatientProfileDto.builder()
                .patientId(patient.getId())
                .name(users.getName())
                .dateOfBirth(patient.getDateOfBirth())
                .heightCm(patient.getHeightCm())
                .bloodType(patient.getBloodType())
                .sex(patient.getSex())
                .phoneNumber(patient.getPhoneNumber())
                .address(patient.getAddress())
                .latestWeightKg(latestWeight)
                .latestBloodSugar(latestSugar)
                .latestBodyFatPercent(latestBodyFat)
                .latestSystolicBp(latestBp != null ? latestBp.getSystolic() : null)
                .latestDiastolicBp(latestBp != null ? latestBp.getDiastolic() : null)
                .lastUpdated(LocalDateTime.now())
                .build();
    }

}
