package com.Grp._8.backend.services;

import com.Grp._8.backend.entities.User;
import com.Grp._8.backend.repositories.UserRepository;
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

    @Value("${jwt.secret.key}")
    private String secretKey;

    private SecretKey getSigningKey(){
        return Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));
    }

    public String generateAccessToken(User user){
        return Jwts.builder()
                .subject(user.getId().toString())
                .claim("username",user.getUsername())
                .claim("role",user.getRole())
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis()+1000*60*15))
                .signWith(getSigningKey())
                .compact();

    }

    public String generateRefreshToken(User user){
        return Jwts.builder()
                .subject(user.getId().toString())
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + 1000L*60*60*24*31))
                .signWith(getSigningKey())
                .compact();
    }

    public Long getUserIdFromToken(String token){

        Claims claim = Jwts.parser()
                .verifyWith(getSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();

        Long Id =  Long.valueOf(claim.getSubject());
        return Id;

    }

    public String generateAcessTokenFromRefreshToken(String refreshToken){

        Long userId = getUserIdFromToken(refreshToken);
        User validUser = userRepository.findById(userId).orElseThrow();
        String accessToken = generateAccessToken(validUser);

        return accessToken;

    }

}
