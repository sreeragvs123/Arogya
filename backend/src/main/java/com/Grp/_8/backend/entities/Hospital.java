package com.Grp._8.backend.entities;


import com.Grp._8.backend.entities.enums.HospitalType;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Hospital{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private User userData;

    private String place;

    private HospitalType hospitalType;

    @OneToMany(mappedBy = "doctor",cascade = CascadeType.ALL,fetch = FetchType.LAZY)
    private List<DoctorHospital> doctorList;

}
