package com.Grp._8.backend.dto.appointment;

import lombok.*;

@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AppointmentsNumberResponseDto {
    private Integer totalPatients;
    private Integer newPatientsThisMonth;
}

