package com.Grp._8.backend.dto.prescription;


import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class PrescriptionItemsUpdateRequestDto {
    private List<PrescriptionItemRequestDto> items;
}