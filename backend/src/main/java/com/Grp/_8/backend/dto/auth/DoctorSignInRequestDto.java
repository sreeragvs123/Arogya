package com.Grp._8.backend.dto.auth;


import com.Grp._8.backend.entities.enums.Role;
import lombok.Data;

@Data
public class DoctorSignInRequestDto {
    private Long hospitalId;
    private Role role;
    private String username;
    private String password;
}
