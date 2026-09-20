package com.Grp._8.backend.dto.prescription;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ObservationUpdateRequestDto {
    private List<String> symptoms; // optional — new tags to add
    private String note;           // optional — appended to clinical observations
}