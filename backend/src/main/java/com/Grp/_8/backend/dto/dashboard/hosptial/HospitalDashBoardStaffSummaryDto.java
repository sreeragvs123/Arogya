package com.Grp._8.backend.dto.dashboard.hosptial;


import com.Grp._8.backend.entities.enums.Department;
import com.Grp._8.backend.entities.enums.Role;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class HospitalDashBoardStaffSummaryDto {
    private Long id;
    private String name;
    private String email;
    private String profileImageUrl;
    private Role role;
    private Department department;
    private String phoneNumber;
    private boolean onCall;
    private LocalDateTime lastLoginAt;
    @JsonProperty("isActive")
    private boolean isActive;
}