package com.Grp._8.backend.dto.profile;

import com.Grp._8.backend.entities.enums.BloodType;
import com.Grp._8.backend.entities.enums.Sex;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class PatientProfileCardDto {
    String patientDisplayId;
    String fullName;
    Integer age;
    Sex sex;
    BloodType bloodType;
    Double heightCm;
    Double weightKg;  // nullable — patient may have no WEIGHT vital logged yet
    String profileImageUrl;
}
