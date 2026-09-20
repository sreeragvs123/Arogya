package com.Grp._8.backend.entities.users;

import com.Grp._8.backend.entities.enums.Designation;
import com.Grp._8.backend.entities.enums.DoctorStatus;
import com.Grp._8.backend.entities.enums.Sex;
import com.Grp._8.backend.entities.enums.VerificationStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;


@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Doctor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id", unique = true, nullable = false)
    private Users userData;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private Hospital hospital;

    @Column(unique = true, nullable = false)
    private String licenseNumber;

    @Enumerated(EnumType.STRING)
    private Designation designation;//NOTE : this explains the position in the hospital

    @Enumerated(EnumType.STRING)
    private Sex sex;

    @Enumerated(EnumType.STRING)
    private VerificationStatus verificationStatus = VerificationStatus.PENDING;

    private String specialization;

    private String phoneNumber;

    private Boolean prescriptionAuthority;

    private Boolean labImagingOrdering;

    private Boolean dischargeSignoffAuthority;

    private LocalDate dateOfBirth;


    @Enumerated(EnumType.STRING)
    private DoctorStatus status = DoctorStatus.PENDING_FIRST_LOGIN;


    private LocalDateTime lastLoginAt;


    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}