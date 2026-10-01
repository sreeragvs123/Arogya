package com.Grp._8.backend.controllers.auth;


import com.Grp._8.backend.dto.auth.*;
import com.Grp._8.backend.services.auth.DoctorAuthService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RequestMapping("/auth/doctor")
@RestController
@Slf4j
public class DoctorAuthController {
    private final DoctorAuthService doctorAuthService;

    @PostMapping("/signIn")
    public ResponseEntity<DoctorSignInResponseDto> signIn(@RequestBody DoctorSignInRequestDto siginRequest, HttpServletResponse response) {
        Object[] data = doctorAuthService.signIn(siginRequest);

        DoctorSignInResponseDto responseDto  = (DoctorSignInResponseDto) data[0];
        String refreshToken = (String) data[1];

        Cookie cookie = new Cookie("refresh_token",refreshToken);
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
        cookie.setSecure(true);      // HTTPS only; set false for local http testing
        cookie.setPath("/");         // or the refresh endpoint path, e.g. "/auth/refresh"
        cookie.setMaxAge(7 * 24 * 60 * 60);

        return ResponseEntity.ok(responseDto);
    }



}
