package com.Grp._8.backend.entities.enums;


public enum DoctorStatus {
    ACTIVE,               // "Active Today"
    IN_OPD,                // "In OPD (Room 304)"
    ON_CALL,               // "On Call Duty"
    ON_LEAVE,
    PENDING_FIRST_LOGIN,   // hasn't logged in yet
    INACTIVE               // off duty / not currently working
}