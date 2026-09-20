package com.Grp._8.backend.dto.appointment;
import com.Grp._8.backend.entities.enums.ConsultationType;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;


@Setter
@Getter
@Data
public class AppointmentRequestDto {

    @NotNull
    private Long doctorId;

    @NotNull
    @Future
    private LocalDateTime appointmentAt;

    @NotNull
    private ConsultationType consultationType;

    public Long getDoctorId() { return doctorId; }
    public void setDoctorId(Long doctorId) { this.doctorId = doctorId; }

    public LocalDateTime getAppointmentAt() { return appointmentAt; }
    public void setAppointmentAt(LocalDateTime appointmentAt) { this.appointmentAt = appointmentAt; }

    public ConsultationType getConsultationType() { return consultationType; }
    public void setConsultationType(ConsultationType consultationType) { this.consultationType = consultationType; }
}