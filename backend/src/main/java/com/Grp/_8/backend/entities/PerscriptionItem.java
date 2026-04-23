package com.Grp._8.backend.entities;

import com.Grp._8.backend.entities.enums.DayOfWeek;
import com.Grp._8.backend.entities.enums.DoseTiming;
import com.Grp._8.backend.entities.enums.TimeOfDay;
import jakarta.persistence.*;

import java.util.List;

@Entity
public class PerscriptionItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "perscription_id", nullable = false)
    private Prescription perscription;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medicine_id", nullable = false)
    private Medicine medicine;

    @Column(nullable = false)
    private String dosage;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private List<TimeOfDay> timeOfDay;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DayOfWeek daysOfWeek;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DoseTiming doseTiming;

    private String instructions;

}
