package com.Grp._8.backend.security;


import com.Grp._8.backend.entities.users.Hospital;
import com.Grp._8.backend.entities.users.UserPrincipal;
import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.repositories.users.HospitalRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class HospitalAuthContext {

    private final HospitalRepository hospitalRepository;

    public UserPrincipal currentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !(auth.getPrincipal() instanceof UserPrincipal principal)) {
            throw new AccessDeniedException("Not authenticated");
        }
        return principal;
    }

    public Long requireHospitalId() {
        UserPrincipal principal = currentUser();
        return hospitalRepository.findByUserData_Id(principal.getUserId())
                .orElseThrow(() -> new AccessDeniedException("Hospital not found"))
                .getId();
    }
}