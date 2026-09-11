package com.Grp._8.backend.dto.auth;

import com.Grp._8.backend.entities.enums.Role;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class HospitalSignInDataExchangeDto {
    private String accessToken;
    private String refreshToken;
    private Long userId;
    private String name;
    private Role role;
    private Long hospitalId;
}
