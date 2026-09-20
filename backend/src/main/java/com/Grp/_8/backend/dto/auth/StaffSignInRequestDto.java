package com.Grp._8.backend.dto.auth;

import com.Grp._8.backend.entities.enums.Department;
import com.Grp._8.backend.entities.enums.Role;
import lombok.Data;

@Data
public class StaffSignInRequestDto {
    private Long hospitalId;
    private Department department;
    private String username;
    private String password;
}