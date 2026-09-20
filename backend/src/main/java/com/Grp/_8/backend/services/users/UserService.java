    package com.Grp._8.backend.services.users;

    import com.Grp._8.backend.entities.enums.Role;
    import com.Grp._8.backend.entities.users.UserPrincipal;
    import com.Grp._8.backend.entities.users.Users;
    import com.Grp._8.backend.repositories.users.DoctorRepository;
    import com.Grp._8.backend.repositories.users.PatientRepository;
    import com.Grp._8.backend.repositories.users.StaffRepository;
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
        private final StaffRepository staffRepository;
        private final DoctorRepository doctorRepository;
        private final PatientRepository patientRepository;

        @Override
        public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
            Users user = userRepository.findByUsername(username)
                    .orElseThrow(() -> new UsernameNotFoundException("Users not found with username: " + username));

            Long profileId = switch (user.getRole()) {
                case STAFF -> staffRepository.findIdByUserData_Username(username).orElse(null);
                case DOCTOR -> doctorRepository.findIdByUserData_Username(username).orElse(null);
                case PATIENT -> patientRepository.findIdByUserData_Username(username).orElse(null);
                default -> null; // e.g. HOSPITAL, if that role has no Staff/Doctor/Patient row
            };

            return new UserPrincipal(user.getId(), user.getUsername(), user.getPassword(), user.getRole(), profileId);
        }


    }
