package com.Grp._8.backend.dto.prescription;

import com.Grp._8.backend.entities.enums.DoseFrequency;
import com.Grp._8.backend.entities.enums.DoseTiming;
import com.Grp._8.backend.entities.enums.TimeOfDay;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;
import java.util.Set;


@Getter
@Builder
public class PrescriptionItemResponseDto {
    private Long itemId;
    private String medicineName;
    private String dosage;
    private Boolean morning;
    private Boolean afternoon;
    private Boolean evening;
    private Set<DayOfWeek> weeklyDays;
    private DoseFrequency frequency;
    private DoseTiming doseTiming;
    private LocalDate startDate;
    private Integer durationDays;
    private String instructions;
}