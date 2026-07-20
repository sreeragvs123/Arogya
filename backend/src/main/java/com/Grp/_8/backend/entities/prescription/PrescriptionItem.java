package com.Grp._8.backend.entities.prescription;

import com.Grp._8.backend.entities.Medicine;
import com.Grp._8.backend.entities.enums.DoseFrequency;
import com.Grp._8.backend.entities.enums.DoseTiming;
import com.Grp._8.backend.entities.enums.TimeOfDay;
import jakarta.persistence.*;

import java.time.DayOfWeek;
import java.util.List;

@Entity
public class PrescriptionItem {

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
    @Column(name= "time_of_day")
    @ElementCollection
    @CollectionTable(name = "perscription_item_time_of_day", joinColumns = @JoinColumn(name = "item_id"))
    private List<TimeOfDay> timeOfDay;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DoseFrequency daysOfWeek;

    @Enumerated(EnumType.STRING)//TODO : Populate this when the DoseFrequency is WEEKLY to set a specific day of the week for the dose
    @Column(nullable = true)
    private DayOfWeek weeklyDay;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private DoseTiming doseTiming;

    private String instructions;

}
