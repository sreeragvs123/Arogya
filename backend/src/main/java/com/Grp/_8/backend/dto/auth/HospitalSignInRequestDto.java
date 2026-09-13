package com.Grp._8.backend.dto.auth;

import lombok.Data;

@Data
public class HospitalSignInRequestDto {
    private String identifierOrEmail;
    private String password;
}