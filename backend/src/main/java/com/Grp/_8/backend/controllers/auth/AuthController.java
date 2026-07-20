package com.Grp._8.backend.controllers.auth;

import com.Grp._8.backend.dto.auth.LoginRequestDTO;
import com.Grp._8.backend.dto.auth.LoginResponseDTO;
import com.Grp._8.backend.dto.auth.SignUpResponseDto;
import com.Grp._8.backend.dto.auth.UserSignUpDTO;
import com.Grp._8.backend.services.auth.AuthService;
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
@RequestMapping("/auth")
@RestController
@Slf4j
public class AuthController {


    private final AuthService authService;

    @PostMapping("/signUp")
    public ResponseEntity<SignUpResponseDto> UsersignUp(@RequestBody UserSignUpDTO user) {
        SignUpResponseDto savedPaitent = authService.signUp(user);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedPaitent);
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@RequestBody LoginRequestDTO loginRequest,HttpServletResponse response) {
        String[] tokens = authService.login(loginRequest);

        String accessToken = tokens[0];
        String refreshToken = tokens[1];

        Cookie cookie = new Cookie("refresh_token",tokens[1]);
        cookie.setHttpOnly(true);
        response.addCookie(cookie);

        return ResponseEntity.ok(new LoginResponseDTO(accessToken));
    }

    @PostMapping("/refresh")
    public ResponseEntity<LoginResponseDTO> generateAccessTokenFromRefreshToken(HttpServletRequest request){
        Cookie[] cookies = request.getCookies();
        String refreshToken = Arrays.stream(cookies)
                .filter(cookie -> "refresh_token".equals(cookie.getName()))
                .findFirst()
                .map(Cookie::getValue)
                .orElseThrow(()->new AuthenticationServiceException("Refresh Token not found inside the Cookie"));
        String accessToken = authService.generateAccessTokenFromRefreshToken(refreshToken);
        return ResponseEntity.ok(new LoginResponseDTO(accessToken));

    }

}