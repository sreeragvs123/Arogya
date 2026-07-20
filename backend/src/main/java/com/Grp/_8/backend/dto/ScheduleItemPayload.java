package com.Grp._8.backend.dto;

import lombok.Data;

import java.util.List;


@Data
public class ScheduleItemPayload {
    private Long itemId;
    private String medicineName;
    private String dosage;
    private String doseTiming;
    private List<String> timeOfDay;
    private String frequency;
    private String weeklyDay;
}
