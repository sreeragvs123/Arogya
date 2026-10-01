package com.Grp._8.backend.security;

import com.Grp._8.backend.entities.users.UserPrincipal;
import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.exceptions.ResourceNotFoundException;
import com.Grp._8.backend.repositories.users.UserRepository;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;


@Service
@RequiredArgsConstructor
public class JwtService {

    private final UserRepository userRepository;
    private final UserService userService;

    @Value("${jwt.secret.key}")
    private String secretKey;

    @Value("#{${jwt.access-token.expiration-minutes} * 60 * 1000}")
    private Long accessTokenExpirationMs;

    @Value("#{${jwt.refresh-token.expiration-days} * 24 * 60 * 60 * 1000}")
    private Long refreshTokenExpirationMs;

    private SecretKey getSigningKey(){
        return Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));
    }

    public String generateAccessToken(UserPrincipal userPrincipal){
        return Jwts.builder()
                .subject(userPrincipal.getUserId().toString())
                .claim("username", userPrincipal.getUsername())
                .claim("role", userPrincipal.getRole().name())
                .claim("profileId", userPrincipal.getProfileId())
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis()+accessTokenExpirationMs))
                .signWith(getSigningKey())
                .compact();

    }

    public String generateRefreshToken(UserPrincipal userPrincipal){
        return Jwts.builder()
                .subject(userPrincipal.getUserId().toString())
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + refreshTokenExpirationMs))
                .signWith(getSigningKey())
                .compact();
    }

    public Claims parseClaims(String token) {
        return Jwts.parser()
                .verifyWith(getSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    public Long getUserIdFromToken(String token){

        Claims claim =  parseClaims(token);
        Long Id =  Long.valueOf(claim.getSubject());
        return Id;

    }

    public String generateAcessTokenFromRefreshToken(String refreshToken){

        Long userId = getUserIdFromToken(refreshToken);
        Users validUser = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User with id : " + userId + " not Found."));
        UserPrincipal principal = (UserPrincipal) userService.loadUserByUsername(validUser.getUsername());
        return generateAccessToken(principal);

    }

}
