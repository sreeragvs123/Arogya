package com.Grp._8.backend.utils;

import com.Grp._8.backend.entities.enums.HospitalType;

public class HospitalDisplayUtils {

    public static String generateHospitalCode(Long hospitalId) {
        return "HOSP-" + String.format("%04d", hospitalId);
    }

    public static String designationFor(HospitalType hospitalType) {
        if (hospitalType == null) {
            return "Facility Administrator";
        }
        return switch (hospitalType) {
            // adjust these to your actual HospitalType enum values
            default -> "Chief Medical Admin";
        };
    }
}