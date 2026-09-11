package com.Grp._8.backend.dto.search;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class HospitalSearchResponseDto {
    private Long id;
    private String hospitalName;
}
