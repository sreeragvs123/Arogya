package com.Grp._8.backend.entities;
import com.Grp._8.backend.entities.enums.BloodType;
import com.Grp._8.backend.entities.enums.Sex;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;


@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Patient{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Sex sex;

    private String phoneNumber;

    private String address;

    private LocalDate dateOfBirth;

    private Boolean isActive;

    private BloodType bloodType;

    private User userData;

    @Column(unique = true)
    private String qrCode;

    @OneToMany
    private List<Prescription> perscriptionsList;


}
