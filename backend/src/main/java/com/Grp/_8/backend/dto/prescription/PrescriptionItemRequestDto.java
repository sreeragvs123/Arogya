package com.Grp._8.backend.dto.prescription;

import com.Grp._8.backend.entities.enums.DoseTiming;
import lombok.Getter;
import lombok.Setter;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.Set;

@Getter
@Setter
public class PrescriptionItemRequestDto {
    private Long drugId;
    private String dosage;
    private Boolean morning;
    private Boolean afternoon;
    private Boolean evening;
    private Set<DayOfWeek> weeklyDays;
    private DoseTiming doseTiming;
    private LocalDate startDate;
    private Integer durationDays;
}