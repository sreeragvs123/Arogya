package com.Grp._8.backend.dto.search;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DrugSearchResponseDto {
    private Long drugId;
    private String name;
    private String strength;
    private String form;
}