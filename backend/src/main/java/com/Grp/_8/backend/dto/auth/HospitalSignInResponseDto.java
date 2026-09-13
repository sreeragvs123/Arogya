package com.Grp._8.backend.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class HospitalSignInResponseDto {
    private String accessToken;
    private Long hospitalId;
    private String hospitalName;
    private String hospitalCode;
    private String adminName;
    private String adminDesignation;
}