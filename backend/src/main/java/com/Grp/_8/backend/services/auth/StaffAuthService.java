package com.Grp._8.backend.services.auth;

import com.Grp._8.backend.dto.auth.StaffCreateRequestDto;
import com.Grp._8.backend.dto.auth.StaffCreateResponseDto;
import com.Grp._8.backend.dto.auth.StaffSignInRequestDto;
import com.Grp._8.backend.dto.auth.StaffSignInResponseDto;
import com.Grp._8.backend.entities.enums.Role;
import com.Grp._8.backend.entities.users.Hospital;
import com.Grp._8.backend.entities.users.Staff;
import com.Grp._8.backend.entities.users.UserPrincipal;
import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.exceptions.*;
import com.Grp._8.backend.repositories.users.HospitalRepository;
import com.Grp._8.backend.repositories.users.StaffRepository;
import com.Grp._8.backend.repositories.users.UserRepository;
import com.Grp._8.backend.security.JwtService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class StaffAuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final UserRepository userRepository;
    private final StaffRepository staffRepository;
    private final HospitalRepository hospitalRepository;
    private final PasswordEncoder passwordEncoder;

    public Object[] signIn(StaffSignInRequestDto request) {

        Hospital hospital = hospitalRepository.findById(request.getHospitalId()).orElseThrow(
                () -> new HospitalNotFoundException("Hospital Not Found with Id :" + request.getHospitalId())
        );

        String compositeKey = request.getUsername() + ":" + Role.STAFF;
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(compositeKey, request.getPassword())
        );

        UserPrincipal principal = (UserPrincipal) authentication.getPrincipal();

        Staff staff = staffRepository.findByUserData_Id(principal.getUserId()).orElseThrow(
                () -> new StaffNotFoundException("Staff Not Found with Id : " + principal.getUserId())
        );

        if (!staff.getHospital().getId().equals(hospital.getId())) {
            throw new StaffHospitalMismatchException("Staff doesn't Belong to this Hospital");
        }

        if (!staff.getDepartment().equals(request.getDepartment())) {
            throw new StaffDepartmentMismatchException("Staff doesn't belong to this Department");
        }

        staff.setLastLoginAt(LocalDateTime.now());
        staffRepository.save(staff);

        String accessToken = jwtService.generateAccessToken(principal);
        String refreshToken = jwtService.generateRefreshToken(principal);

        StaffSignInResponseDto responseDto = StaffSignInResponseDto.builder()
                .staffId(staff.getId())
                .staffName(staff.getUserData().getName())
                .role(principal.getRole())
                .department(staff.getDepartment())
                .hospitalId(hospital.getId())
                .accessToken(accessToken)
                .build();

        return new Object[]{responseDto, refreshToken};
    }

    @Transactional
    public StaffCreateResponseDto createStaff(@Valid StaffCreateRequestDto request, Long hospitalId) {

        Hospital hospital = hospitalRepository.findById(hospitalId)
                .orElseThrow(() -> new HospitalNotFoundException("Hospital not found"));

        Users userData = new Users();
        userData.setPassword(passwordEncoder.encode(request.getTemporaryPin()));
        userData.setRole(Role.STAFF);
        userData.setUsername(request.getEmployeeId());
        userData.setName(request.getFullName());
        userData.setEmail(request.getEmail());

        Users savedUser;
        try {
            savedUser = userRepository.save(userData);
        } catch (DataIntegrityViolationException e) {
            throw new StaffAlreadyExistsException("Staff already exists");
        }

        Staff newStaff = new Staff();
        newStaff.setUserData(savedUser);
        newStaff.setHospital(hospital);
        newStaff.setSex(request.getSex());
        newStaff.setPhoneNumber(request.getPhoneNumber());
        newStaff.setAddress(request.getAddress());
        newStaff.setDateOfBirth(request.getDateOfBirth());
        newStaff.setDepartment(request.getDepartment());
        newStaff.setIsActive(true);

        Staff savedStaff;
        try {
            savedStaff = staffRepository.save(newStaff);
        } catch (DataIntegrityViolationException e) {
            throw new StaffAlreadyExistsException("Staff already exists");
        }

        return StaffCreateResponseDto.builder()
                .staffId(savedStaff.getId())
                .fullName(savedStaff.getUserData().getName())
                .email(savedStaff.getUserData().getEmail())
                .employeeId(savedStaff.getUserData().getUsername())
                .phoneNumber(savedStaff.getPhoneNumber())
                .department(savedStaff.getDepartment())
                .temporaryPin(request.getTemporaryPin())
                .assignedAt(savedStaff.getCreatedAt())
                .build();
    }
}