package com.Grp._8.backend.exceptions;

public class HospitalNotFoundException extends RuntimeException {
    public HospitalNotFoundException(String message) {
        super(message);
    }
}
