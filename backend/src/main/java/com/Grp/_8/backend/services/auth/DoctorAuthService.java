package com.Grp._8.backend.services.auth;


import com.Grp._8.backend.dto.auth.DoctorSignInRequestDto;
import com.Grp._8.backend.entities.enums.DoctorStatus;
import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.repositories.users.DoctorRepository;
import com.Grp._8.backend.repositories.users.HospitalRepository;
import com.Grp._8.backend.repositories.users.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.Grp._8.backend.dto.auth.DoctorCreateRequestDto;
import com.Grp._8.backend.dto.auth.DoctorCreateResponseDto;
import com.Grp._8.backend.entities.enums.Role;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.entities.users.Hospital;
import com.Grp._8.backend.exceptions.DoctorAlreadyExistsException;
import com.Grp._8.backend.exceptions.HospitalNotFoundException;
import jakarta.validation.Valid;
import org.springframework.dao.DataIntegrityViolationException;


@Service
@RequiredArgsConstructor
public class DoctorAuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final UserRepository userRepository;
    private final DoctorRepository doctorRepository;
    private final HospitalRepository hospitalRepository;
    private final PasswordEncoder passwordEncoder;



    public String[] signIn(DoctorSignInRequestDto request) {
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


    @Transactional
    public DoctorCreateResponseDto createDoctor(@Valid DoctorCreateRequestDto request, Long hospitalId) {

        Hospital hospital = hospitalRepository.findById(hospitalId)
                .orElseThrow(() -> new HospitalNotFoundException("Hospital not found"));

        if (doctorRepository.existsByHospital_IdAndLicenseNumber(hospital.getId(), request.getLicenseNumber())) {
            throw new DoctorAlreadyExistsException("Doctor already exists in this hospital");
        }

        Users userData = new Users();
        userData.setPassword(passwordEncoder.encode(request.getTemporaryPin()));
        userData.setRole(Role.DOCTOR);
        userData.setUsername(request.getLicenseNumber());
        userData.setName(request.getFullName());
        userData.setEmail(request.getEmail());

        Users savedUser;
        try {
            savedUser = userRepository.save(userData);
        } catch (DataIntegrityViolationException e) {
            throw new DoctorAlreadyExistsException("Doctor already exists");
        }

        Doctor newDoctor = new Doctor();
        newDoctor.setUserData(savedUser);
        newDoctor.setHospital(hospital);
        newDoctor.setLicenseNumber(request.getLicenseNumber());
        newDoctor.setDesignation(request.getDesignation());
        newDoctor.setSpecialization(request.getSpecialization());
        newDoctor.setPhoneNumber(request.getPhoneNumber());
        newDoctor.setPrescriptionAuthority(request.getPrescriptionAuthority());
        newDoctor.setLabImagingOrdering(request.getLabImagingOrdering());
        newDoctor.setDischargeSignoffAuthority(request.getDischargeSignoffAuthority());
        newDoctor.setStatus(DoctorStatus.PENDING_FIRST_LOGIN);

        Doctor savedDoctor;
        try {
            savedDoctor = doctorRepository.save(newDoctor);
        } catch (DataIntegrityViolationException e) {
            throw new DoctorAlreadyExistsException("Doctor already exists");
        }

        return DoctorCreateResponseDto.builder()
                .doctorId(savedDoctor.getId())
                .fullName(savedDoctor.getUserData().getName())
                .email(savedDoctor.getUserData().getEmail())
                .phoneNumber(savedDoctor.getPhoneNumber())
                .licenseNumber(savedDoctor.getLicenseNumber())
                .specialization(savedDoctor.getSpecialization())
                .designation(savedDoctor.getDesignation())
                .status(savedDoctor.getStatus())
                .prescriptionAuthority(savedDoctor.getPrescriptionAuthority())
                .labImagingOrdering(savedDoctor.getLabImagingOrdering())
                .dischargeSignoffAuthority(savedDoctor.getDischargeSignoffAuthority())
                .temporaryPin(request.getTemporaryPin())
                .assignedAt(savedDoctor.getCreatedAt())
                .build();
    }

}
