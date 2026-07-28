package com.Grp._8.backend.entities.users;
import com.Grp._8.backend.entities.prescription.Prescription;
import com.Grp._8.backend.entities.enums.BloodType;
import com.Grp._8.backend.entities.enums.Sex;
import com.Grp._8.backend.entities.histories.BloodPressureReading;
import com.Grp._8.backend.entities.histories.VitalReading;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;


@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Patient{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    private String phoneNumber;

    private String address;

    private LocalDate dateOfBirth;

    private Boolean isActive;

    @Enumerated(EnumType.STRING)
    private Sex sex;

    @Enumerated(EnumType.STRING)
    private BloodType bloodType;

    @OneToOne
    @JoinColumn(name = "user_id", unique = true, nullable = false)
    private Users userData;

    @Column(unique = true)
    private String qrCode;

    private Double heightCm;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL)
    private List<Prescription> perscriptionsList;


    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL)
    private List<VitalReading> vitalReadings;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL)
    private List<BloodPressureReading> bloodPressureReadings;


}
