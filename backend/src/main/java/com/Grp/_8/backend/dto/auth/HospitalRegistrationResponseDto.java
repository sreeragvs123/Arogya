package com.Grp._8.backend.dto.auth;
import lombok.Builder;
import lombok.Data;


@Data
@Builder
public class HospitalRegistrationResponseDto {
    private Long hospitalId;
    private String hospitalName;
}
