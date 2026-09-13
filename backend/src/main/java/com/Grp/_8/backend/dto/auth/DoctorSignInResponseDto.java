package com.Grp._8.backend.dto.auth;


import com.Grp._8.backend.entities.enums.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DoctorSignInResponseDto {
    private Long doctorId;
    private Long hospitalId;
    private Role role;
    private String accessToken;
}
