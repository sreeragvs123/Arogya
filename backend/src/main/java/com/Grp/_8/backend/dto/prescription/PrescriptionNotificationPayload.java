package com.Grp._8.backend.dto.prescription;

import com.Grp._8.backend.dto.ScheduleItemPayload;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;


@Data
public class PrescriptionNotificationPayload {
    private Long prescriptionId;
    private String doctorName;
    private String hospitalName;
    private LocalDate startDate;
    private LocalDate endDate;
    private List<ScheduleItemPayload> scheduleItems;
}
