package com.Grp._8.backend.dto.prescription;

import com.Grp._8.backend.entities.enums.DoseFrequency;
import com.Grp._8.backend.entities.enums.DoseTiming;
import com.Grp._8.backend.entities.enums.TimeOfDay;
import lombok.Data;

import java.time.DayOfWeek;
import java.util.List;


@Data
public class PrescriptionItemResponse {
    private Long id;
    private String medicineName;
    private String dosage;
    private List<TimeOfDay> timeOfDay;
    private DoseFrequency frequency;
    private DayOfWeek weeklyDay;
    private DoseTiming doseTiming;
    private String instructions;
}
