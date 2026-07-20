package com.Grp._8.backend.services.users;

import com.Grp._8.backend.entities.enums.Role;
import com.Grp._8.backend.repositories.users.UserRepository;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class UserService  implements UserDetailsService {

    private final UserRepository userRepository;
    private final ModelMapper modelMapper;


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        String[] parts = username.split(":");
        if (parts.length != 2) {
            throw new BadCredentialsException("Invalid credentials format");
        }

        String actualUsername = parts[0];
        Role role = Role.valueOf(parts[1]);

        return userRepository.findByUsernameAndRole(actualUsername, role)
                .orElseThrow(() -> new BadCredentialsException("Users not found with username: " + actualUsername));

    }


}
