package com.Grp._8.backend.entities.prescription;

import com.Grp._8.backend.entities.enums.DoseFrequency;
import com.Grp._8.backend.entities.enums.DoseTiming;
import com.Grp._8.backend.entities.medicine.Drug;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;


@Entity
@Getter @Setter
@AllArgsConstructor @NoArgsConstructor
public class PrescriptionItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false)
    private Prescription prescription;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "drug_id", nullable = false)
    private Drug medicine;

    @Column(nullable = false)
    private String dosage;

    private Boolean morning;
    private Boolean afternoon;
    private Boolean evening;

    @ElementCollection
    @CollectionTable(name = "prescription_item_weekly_days", joinColumns = @JoinColumn(name = "item_id"))
    @Enumerated(EnumType.STRING)
    @Column(name = "day_of_week")
    private Set<DayOfWeek> weeklyDays = new HashSet<>();

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DoseFrequency frequency;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DoseTiming doseTiming;

    @Column(nullable = false)
    private LocalDate startDate;

    @Column(nullable = false)
    private Integer durationDays;

    private String instructions;
}