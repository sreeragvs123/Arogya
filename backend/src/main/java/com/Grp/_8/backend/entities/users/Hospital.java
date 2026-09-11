package com.Grp._8.backend.entities.users;


import com.Grp._8.backend.entities.enums.HospitalType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
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

    @OneToOne
    @JoinColumn(name = "user_id", unique = true, nullable = false)
    private Users userData;


    @Enumerated(EnumType.STRING)
    private HospitalType hospitalType;

    private String hosptialDirector;

    private String phoneNumber;

    @OneToMany(mappedBy = "hospital", fetch = FetchType.LAZY)
    private List<Doctor> doctors;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

}
