package com.Grp._8.backend.dto.dashboard.doctor;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ScheduledConsultationDto {

    private Long appointmentId;
    private Long patientId;
    private String patientName;
    private LocalDateTime appointmentAt;
    private String consultationType;
    private String status;
}