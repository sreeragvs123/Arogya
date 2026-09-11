package com.Grp._8.backend.dto.auth;


import com.Grp._8.backend.entities.enums.Role;
import lombok.Data;

@Data
public class HospitalSignInRequestDto {
    private String username;
    private Role role;
    private String password;
}
