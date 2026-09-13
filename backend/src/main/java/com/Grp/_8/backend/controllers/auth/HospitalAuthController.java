package com.Grp._8.backend.controllers.auth;

import com.Grp._8.backend.dto.auth.*;
import com.Grp._8.backend.services.auth.HospitalAuthService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RequestMapping("/auth/hospital")
@RestController
@Slf4j
public class HospitalAuthController {

    private final HospitalAuthService hospitalAuthService;

    @PostMapping("/create")
    public ResponseEntity<HospitalRegistrationResponseDto> createHospital(@Valid @RequestBody HospitalRegistrationRequestDto request){
        HospitalRegistrationResponseDto response = hospitalAuthService.createHospital(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/signIn")
    public ResponseEntity<HospitalSignInResponseDto> signIn(
            @RequestBody HospitalSignInRequestDto request,
            HttpServletResponse response
    ) {
        Object[] result = hospitalAuthService.signIn(request);
        HospitalSignInResponseDto body = (HospitalSignInResponseDto) result[0];
        String refreshToken = (String) result[1];

        Cookie cookie = new Cookie("refresh_token", refreshToken);
        cookie.setHttpOnly(true);
        response.addCookie(cookie);

        return ResponseEntity.ok(body);
    }
}
