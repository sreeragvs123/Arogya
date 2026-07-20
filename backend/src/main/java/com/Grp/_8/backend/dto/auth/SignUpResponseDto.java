package com.Grp._8.backend.dto.auth;

import com.Grp._8.backend.entities.enums.Role;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SignUpResponseDto {
    private Long id;
    private String name;
    private String username;
    private String email;
    private Role role;
}
