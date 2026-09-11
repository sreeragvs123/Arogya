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
        String[] tokens = doctorAuthService.signIn(siginRequest);

        String accessToken = tokens[0];
        String refreshToken = tokens[1];

        Cookie cookie = new Cookie("refresh_token",tokens[1]);
        cookie.setHttpOnly(true);
        response.addCookie(cookie);

        return ResponseEntity.ok(new DoctorSignInResponseDto(accessToken));
    }

    @PostMapping("/create/{hospitalId}")
    public ResponseEntity<DoctorCreateResponseDto> createHospital(@Valid @RequestBody DoctorCreateRequestDto request, @PathVariable Long hospitalId){
        DoctorCreateResponseDto response = doctorAuthService.createDoctor(request,hospitalId);
        return ResponseEntity.ok(response);
    }



}
