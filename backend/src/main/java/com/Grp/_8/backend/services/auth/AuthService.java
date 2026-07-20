package com.Grp._8.backend.services.auth;

import com.Grp._8.backend.dto.auth.LoginRequestDTO;
import com.Grp._8.backend.dto.auth.SignUpResponseDto;
import com.Grp._8.backend.dto.auth.UserSignUpDTO;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.entities.users.Hospital;
import com.Grp._8.backend.entities.users.Patient;
import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.repositories.users.DoctorRepository;
import com.Grp._8.backend.repositories.users.HospitalRepository;
import com.Grp._8.backend.repositories.users.PaitentRepository;
import com.Grp._8.backend.repositories.users.UserRepository;
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
public class AuthService{

    private final UserRepository userRepository;
    private final PaitentRepository paitentRepository ;
    private final DoctorRepository doctorRepository;
    private final HospitalRepository hospitalRepository;
    private final ModelMapper modelMapper;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;


    @Transactional
    public SignUpResponseDto signUp(UserSignUpDTO user) {

        Optional<Users> existingPaitent = userRepository.findByUsernameAndRole(user.getUsername(), user.getRole());
        if (existingPaitent.isPresent()) {
            throw new BadCredentialsException("Username already exists: " + user.getUsername());
        }


        Users newUser = modelMapper.map(user, Users.class);
        newUser.setPassword(passwordEncoder.encode(newUser.getPassword()));
        Users savedUser = userRepository.save(newUser);

        createRoleProfile(savedUser);


        return modelMapper.map(savedUser, SignUpResponseDto.class);

    }

    private void createRoleProfile(Users savedUser) {
        switch (savedUser.getRole()){
            case PATIENT ->  {
                Patient newPatient = new Patient();
                newPatient.setUserData(savedUser);
                newPatient.setIsActive(true);
                paitentRepository.save(newPatient);
            }
            case DOCTOR -> {
                Doctor newDoctor = new Doctor();
                newDoctor.setUserData(savedUser);
                newDoctor.setIsAvailable(true);
                doctorRepository.save(newDoctor);
            }
            case HOSPITAL -> {
                Hospital newHospital = new Hospital();
                newHospital.setUserData(savedUser);
                hospitalRepository.save(newHospital);
            }
        }
    }

    public String[] login(LoginRequestDTO request) {
        String compositeKey = request.getUsername() + ":" + request.getRole();
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(compositeKey, request.getPassword())
        );

        Users validUser = (Users) authentication.getPrincipal();

        String accessToken = jwtService.generateAccessToken(validUser);
        String refreshToken = jwtService.generateRefreshToken(validUser);
        String[] tokens = {accessToken,refreshToken};

        return  tokens;
    }

    public String generateAccessTokenFromRefreshToken(String refreshToken) {
        String accessToken = jwtService.generateAcessTokenFromRefreshToken(refreshToken);
        return accessToken;

    }



}
