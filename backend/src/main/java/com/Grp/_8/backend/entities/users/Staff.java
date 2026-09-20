package com.Grp._8.backend.entities.users;

import com.Grp._8.backend.entities.enums.Department;
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


@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Staff {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private Sex sex;

    private String phoneNumber;

    private String address;

    private LocalDate dateOfBirth;

    private Boolean isActive;

    @Enumerated(EnumType.STRING)
    private Department department;

    @OneToOne
    @JoinColumn(name = "user_id", unique = true, nullable = false)
    private Users userData;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private Hospital hospital;


    private LocalDateTime lastLoginAt;


    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;


}
