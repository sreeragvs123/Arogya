package com.Grp._8.backend.dto.appointment;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class PatientPortalAccessRequestDto {

    @NotBlank
    private String password;

}