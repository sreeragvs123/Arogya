package com.Grp._8.backend.dto.auth;

import com.Grp._8.backend.entities.enums.Department;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class StaffCreateResponseDto {
    private Long staffId;
    private String fullName;
    private String email;
    private String employeeId;
    private String phoneNumber;
    private Department department;
    private String temporaryPin;
    private LocalDateTime assignedAt;
}