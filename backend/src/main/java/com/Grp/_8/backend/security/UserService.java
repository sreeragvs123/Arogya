    package com.Grp._8.backend.security;

    import com.Grp._8.backend.entities.enums.Role;
    import com.Grp._8.backend.entities.users.UserPrincipal;
    import com.Grp._8.backend.entities.users.Users;
    import com.Grp._8.backend.repositories.users.*;
    import lombok.RequiredArgsConstructor;
    import org.springframework.security.core.userdetails.UserDetails;
    import org.springframework.security.core.userdetails.UserDetailsService;
    import org.springframework.security.core.userdetails.UsernameNotFoundException;
    import org.springframework.stereotype.Service;

    import static com.Grp._8.backend.entities.enums.Role.*;


    @Service
    @RequiredArgsConstructor
    public class UserService  implements UserDetailsService {

        private final UserRepository userRepository;
        private final StaffRepository staffRepository;
        private final DoctorRepository doctorRepository;
        private final PatientRepository patientRepository;
        private final HospitalRepository hospitalRepository;

        @Override
        public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

            Users user = userRepository.findByUsername(username)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));


            Long profileId = switch (user.getRole()) {
                case STAFF   -> staffRepository.findIdByUserData_Username(username).orElse(null);
                case DOCTOR  -> doctorRepository.findIdByUserData_Username(username).orElse(null);
                case PATIENT -> patientRepository.findIdByUserData_Username(username).orElse(null);
                case HOSPITAL -> hospitalRepository.findIdByUserData_Username(username).orElse(null);

                default      -> null; // HOSPITAL has no profile row of these types
            };

           return new UserPrincipal(user.getUsername(),user.getPassword(),user.getRole(),user.getId(),profileId);
        }


    }
