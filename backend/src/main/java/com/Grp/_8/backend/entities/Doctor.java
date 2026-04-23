package com.Grp._8.backend.entities;

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

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Doctor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private User userData;

    @Enumerated(EnumType.STRING)
    private Sex sex;

    private String specialization;

    private LocalDate dateOfBirth;

    private Boolean isAvailable;

    @OneToMany(mappedBy = "hospital",cascade = CascadeType.ALL,fetch = FetchType.LAZY)
    private List<DoctorHospital> hospitalAssignments;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

}
