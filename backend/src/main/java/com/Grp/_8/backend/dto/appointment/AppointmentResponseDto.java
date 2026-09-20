package com.Grp._8.backend.dto.appointment;


import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.entities.enums.ConsultationType;
import lombok.*;

import java.time.LocalDateTime;


@Getter
@Setter
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AppointmentResponseDto {

    private Long id;
    private Long doctorId;
    private Long hospitalId;
    private String doctorName;
    private Long patientId;
    private String patientName;
    private LocalDateTime appointmentAt;
    private ConsultationType consultationType;
    private AppointmentStatus status;
    private String rejectionReason;

}
