package com.Grp._8.backend.dto.prescription;

import com.Grp._8.backend.entities.enums.DoseFrequency;
import com.Grp._8.backend.entities.enums.DoseTiming;
import com.Grp._8.backend.entities.enums.TimeOfDay;
import lombok.Data;

import java.time.DayOfWeek;
import java.util.List;

@Data
public class PrescriptionItemRequest {
    private Long medicineId;
    private String dosage;
    private List<TimeOfDay> timeOfDay;
    private DoseFrequency frequency;
    private DayOfWeek weeklyDay;//REVISE : This will be a nullable field as it is only set wehn DoseFrequency is Weekly
    private DoseTiming doseTiming;
    private String instructions;
}
