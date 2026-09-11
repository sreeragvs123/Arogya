package com.Grp._8.backend.dto.medicine;

import com.Grp._8.backend.entities.enums.MedicineForm;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class DrugDetailResponseDto {
    private Long drugId;
    private String name;
    private String genericName;
    private String brandName;
    private String strength;
    private MedicineForm form;
    private String category;
    private String contents;
    private String uses;
    private String sideEffects;
    private String warnings;
    private String manufacturer;
    private Integer stockQuantity;
    private boolean availableInHospital;
}