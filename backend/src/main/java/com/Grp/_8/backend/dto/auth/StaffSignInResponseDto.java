package com.Grp._8.backend.dto.auth;

import com.Grp._8.backend.entities.enums.Department;
import com.Grp._8.backend.entities.enums.Role;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class StaffSignInResponseDto {
    private Long staffId;
    private String staffName;
    private Role role;
    private Long hospitalId;
    private Department department;
    private String accessToken;
}