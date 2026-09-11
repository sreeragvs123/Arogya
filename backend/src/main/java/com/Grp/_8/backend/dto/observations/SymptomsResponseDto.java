package com.Grp._8.backend.dto.observations;

import lombok.Builder;
import lombok.Data;
import lombok.Getter;

import java.util.List;

@Data
@Builder
public class SymptomsResponseDto {
    private Long prescriptionId;
    private List<String> symptoms;
}