package com.Grp._8.backend.entities.enums;

public enum AppointmentStatus {
    PENDING,        // patient submitted, hospital hasn't decided yet
    CONFIRMED,      // hospital accepted -> now visible on doctor dashboard
    REJECTED,       // hospital declined
    IN_PROGRESS,    // doctor has opened the patient portal / consultation started
    COMPLETED,
    CANCELLED,      // cancelled by patient/hospital before it happened
    NO_SHOW,
    SCHEDULED
}
