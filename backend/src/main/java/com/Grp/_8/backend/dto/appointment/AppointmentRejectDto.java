package com.Grp._8.backend.dto.appointment;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AppointmentRejectDto {

        private String reason; // optional, shown to patient

}
