package com.Grp._8.backend.controllers.auth;


import com.Grp._8.backend.dto.auth.PatientLoginRequestDto;
import com.Grp._8.backend.dto.auth.PatientLoginResponseDto;
import com.Grp._8.backend.dto.auth.PatientSignUpResponseDto;
import com.Grp._8.backend.dto.auth.PatientSignUpRequestDto;
import com.Grp._8.backend.services.auth.PatientAuthService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;

@RequiredArgsConstructor
@RequestMapping("/auth/patient")
@RestController
@Slf4j
public class PatientAuthController {


    private final PatientAuthService authService;

    @PostMapping("/signUp")
    public ResponseEntity<PatientSignUpResponseDto> signUp(@RequestBody PatientSignUpRequestDto user) {
        PatientSignUpResponseDto savedPaitent = authService.signUp(user);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedPaitent);
    }

    @PostMapping("/logIn")
    public ResponseEntity<PatientLoginResponseDto> login(@RequestBody PatientLoginRequestDto loginRequest, HttpServletResponse response) {
        String[] tokens = authService.login(loginRequest);

        String accessToken = tokens[0];
        String refreshToken = tokens[1];

        Cookie cookie = new Cookie("refresh_token",tokens[1]);
        cookie.setHttpOnly(true);
        response.addCookie(cookie);

        return ResponseEntity.ok(new PatientLoginResponseDto(accessToken));
    }


    @PostMapping("/refresh")
    public ResponseEntity<PatientLoginResponseDto> generateAccessTokenFromRefreshToken(HttpServletRequest request){
        Cookie[] cookies = request.getCookies();
        String refreshToken = Arrays.stream(cookies)
                .filter(cookie -> "refresh_token".equals(cookie.getName()))
                .findFirst()
                .map(Cookie::getValue)
                .orElseThrow(()->new AuthenticationServiceException("Refresh Token not found inside the Cookie"));
        String accessToken = authService.generateAccessTokenFromRefreshToken(refreshToken);
        return ResponseEntity.ok(new PatientLoginResponseDto(accessToken));

    }

}