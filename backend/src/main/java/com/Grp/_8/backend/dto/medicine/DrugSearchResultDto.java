package com.Grp._8.backend.dto.medicine;

import com.Grp._8.backend.entities.enums.MedicineForm;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class DrugSearchResultDto {
    private Long drugId;
    private String name;
    private String genericName;
    private String strength;
    private MedicineForm form;
    private Integer stockQuantity;  // from HospitalMedicine
}