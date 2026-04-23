package com.Grp._8.backend.services;

import com.Grp._8.backend.dto.LoginRequestDTO;
import com.Grp._8.backend.dto.LoginResponseDTO;
import com.Grp._8.backend.dto.UserSignUpDTO;
import com.Grp._8.backend.entities.User;
import com.Grp._8.backend.entities.enums.Role;
import com.Grp._8.backend.repositories.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;


@Service
@Slf4j
public class AuthService implements UserDetailsService {

    private final UserRepository userRepository;
    private final ModelMapper modelMapper;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;

    public AuthService(UserRepository userRepository,
                       ModelMapper modelMapper,
                       @Lazy AuthenticationManager authenticationManager,
                       JwtService jwtService,
                       PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.modelMapper = modelMapper;
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
        this.passwordEncoder = passwordEncoder;
    }


    public UserSignUpDTO signUp(UserSignUpDTO user) {

        Optional<User> existingPaitent = userRepository.findByUsernameAndRole(user.getUsername(), user.getRole());
        if (existingPaitent.isPresent()) {
            throw new BadCredentialsException("Username already exists: " + user.getUsername());
        }


        User newUser = modelMapper.map(user, User.class);
        newUser.setPassword(passwordEncoder.encode(newUser.getPassword()));
        User savedUser = userRepository.save(newUser);
        return modelMapper.map(savedUser, UserSignUpDTO.class);

    }

    public LoginResponseDTO login(LoginRequestDTO request) {
        String compositeKey = request.getUsername() + ":" + request.getRole();
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(compositeKey, request.getPassword())
        );

        User validUser = (User) authentication.getPrincipal();

        String accessToken = jwtService.generateAccessToken(validUser);
        String refreshToken = jwtService.generateRefreshToken(validUser);
        Long id =  validUser.getId();

        return new LoginResponseDTO(id,  refreshToken,accessToken);
    }

    public LoginResponseDTO accessToken(String refreshToken) {

        String accessToken = jwtService.generateAcessTokenFromRefreshToken(refreshToken);
        Long id = jwtService.getUserIdFromToken(refreshToken);

        return new LoginResponseDTO(id, refreshToken, accessToken);

    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        String[] parts = username.split(":");
        if (parts.length != 2) {
            throw new BadCredentialsException("Invalid credentials format");
        }

        String actualUsername = parts[0];
        Role role = Role.valueOf(parts[1]);

        return userRepository.findByUsernameAndRole(actualUsername, role)
                .orElseThrow(() -> new BadCredentialsException("User not found with username: " + actualUsername));

    }

}
