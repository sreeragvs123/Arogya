package com.Grp._8.backend.dto.auth;

import com.Grp._8.backend.entities.enums.Department;
import com.Grp._8.backend.entities.enums.Sex;
import lombok.Data;

import java.time.LocalDate;

@Data
public class StaffCreateRequestDto {
    private String fullName;
    private String email;
    private String employeeId;       // used as Users.username
    private String phoneNumber;
    private String address;
    private Sex sex;
    private LocalDate dateOfBirth;
    private Department department;
    private String temporaryPin;
}