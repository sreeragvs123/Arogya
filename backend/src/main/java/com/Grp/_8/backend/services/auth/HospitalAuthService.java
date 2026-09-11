package com.Grp._8.backend.services.auth;


import com.Grp._8.backend.dto.auth.HospitalSignInDataExchangeDto;
import com.Grp._8.backend.dto.auth.HospitalSignInRequestDto;
import com.Grp._8.backend.dto.auth.HospitalRegistrationRequestDto;
import com.Grp._8.backend.dto.auth.HospitalRegistrationResponseDto;
import com.Grp._8.backend.entities.enums.Role;
import com.Grp._8.backend.entities.users.Hospital;
import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.exceptions.HospitalAlreadyExistsException;
import com.Grp._8.backend.repositories.users.HospitalRepository;
import com.Grp._8.backend.repositories.users.UserRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class HospitalAuthService {

    private final ModelMapper modelMapper;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;
    private final HospitalRepository hospitalRepository;


    public HospitalSignInDataExchangeDto signIn(HospitalSignInRequestDto request) {
        String compositeKey = request.getUsername() + ":" + request.getRole();
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(compositeKey, request.getPassword())
        );

        Users validUser = (Users) authentication.getPrincipal();

        String accessToken = jwtService.generateAccessToken(validUser);
        String refreshToken = jwtService.generateRefreshToken(validUser);
        Long hospitalId = hospitalRepository.findByUserId(validUser.getId());
        HospitalSignInDataExchangeDto dto = new HospitalSignInDataExchangeDto(accessToken,refreshToken,validUser.getId(), validUser.getName(), validUser.getRole(),hospitalId);

        return dto;
    }

    public String generateAccessTokenFromRefreshToken(String refreshToken) {
        String accessToken = jwtService.generateAcessTokenFromRefreshToken(refreshToken);
        return accessToken;

    }


    @Transactional
    public HospitalRegistrationResponseDto createHospital(@Valid HospitalRegistrationRequestDto request) {
        Optional<Users> hospital = userRepository.findByUsernameAndRole(request.getClinicalLicenseNumber(), Role.HOSPITAL);
        if (hospital.isPresent()) {
            throw new HospitalAlreadyExistsException("Hospital already exists");
        }


        Users userData = new Users();
        userData.setPassword(passwordEncoder.encode(request.getPassword()));
        userData.setRole(Role.HOSPITAL);
        userData.setUsername(request.getClinicalLicenseNumber());
        userData.setName(request.getHospitalName());
        userData.setEmail(request.getOfficialEmail());

        Users savedUser;
        try {
            savedUser = userRepository.save(userData);
        } catch (DataIntegrityViolationException e) {
            throw new HospitalAlreadyExistsException("Hospital already exists");
        }

        Hospital newHospital = new Hospital();
        newHospital.setPhoneNumber(request.getContactPhone());
        newHospital.setHospitalType(request.getFacilityType());
        newHospital.setUserData(savedUser);
        newHospital.setHosptialDirector(request.getAdminName());

        Hospital savedHospital = hospitalRepository.save(newHospital);

        HospitalRegistrationResponseDto responseDto = HospitalRegistrationResponseDto.builder()
                .hospitalId(savedHospital.getId())
                .hospitalName(savedHospital.getUserData().getName())
                .build();

        return responseDto;
    }

}
