package com.Grp._8.backend.configs;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Clock;

@Configuration
public class ClockConfiguration {
    @Bean
    Clock clock() {
        return Clock.systemDefaultZone();
    }
}
