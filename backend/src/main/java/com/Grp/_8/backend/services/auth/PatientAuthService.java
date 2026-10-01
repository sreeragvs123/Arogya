package com.Grp._8.backend.services.auth;

import com.Grp._8.backend.dto.auth.PatientLoginRequestDto;
import com.Grp._8.backend.dto.auth.PatientLoginResponseDto;
import com.Grp._8.backend.dto.auth.PatientSignUpResponseDto;
import com.Grp._8.backend.dto.auth.PatientSignUpRequestDto;
import com.Grp._8.backend.entities.enums.Role;
import com.Grp._8.backend.entities.users.Patient;
import com.Grp._8.backend.entities.users.UserPrincipal;
import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.exceptions.ResourceNotFoundException;
import com.Grp._8.backend.repositories.users.PatientRepository;
import com.Grp._8.backend.repositories.users.UserRepository;
import com.Grp._8.backend.security.JwtService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;


@Service
@Slf4j
@RequiredArgsConstructor
public class PatientAuthService {

    private final UserRepository userRepository;
    private final PatientRepository patientRepository ;
    private final ModelMapper modelMapper;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;


    @Transactional
    public PatientSignUpResponseDto signUp(PatientSignUpRequestDto user) {

        Optional<Users> existingPaitent = userRepository.findByUsernameAndRole(user.getUsername(), user.getRole());
        if (existingPaitent.isPresent()) {
            throw new BadCredentialsException("Username already exists: " + user.getUsername());
        }


        Users newUser = modelMapper.map(user, Users.class);
        newUser.setPassword(passwordEncoder.encode(newUser.getPassword()));
        Users savedUser = userRepository.save(newUser);

        Patient newPatient = new Patient();
        newPatient.setUserData(savedUser);
        newPatient.setIsActive(true);
        patientRepository.save(newPatient);

        return modelMapper.map(savedUser, PatientSignUpResponseDto.class);

    }


    public Object[] login(PatientLoginRequestDto request) {

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );

        UserPrincipal principal = (UserPrincipal) authentication.getPrincipal();

        if (principal.getRole() != Role.PATIENT || principal.getProfileId() == null) {
            throw new BadCredentialsException("Invalid credentials");
        }

        String accessToken = jwtService.generateAccessToken(principal);
        String refreshToken = jwtService.generateRefreshToken(principal);

        return new Object[]{new PatientLoginResponseDto(accessToken), refreshToken};
    }

    public String generateAccessTokenFromRefreshToken(String refreshToken) {
        String accessToken = jwtService.generateAcessTokenFromRefreshToken(refreshToken);
        return accessToken;
    }



}
