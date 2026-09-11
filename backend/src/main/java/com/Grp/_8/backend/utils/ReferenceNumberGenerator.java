package com.Grp._8.backend.utils;

import org.springframework.stereotype.Component;
import java.security.SecureRandom;
import java.time.Year;

@Component
public class ReferenceNumberGenerator {

    private static final SecureRandom RANDOM = new SecureRandom();

    public String generate() {
        int number = RANDOM.nextInt(9000) + 1000; // 4-digit random
        return "CSR-" + Year.now().getValue() + "-" + number;
        // TODO : this won't gurantee uniqueness update later
    }
}