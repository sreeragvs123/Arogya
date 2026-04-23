package com.Grp._8.backend.entities;

import com.Grp._8.backend.entities.enums.RecordType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "medical_histories")
@Getter
@Setter
@NoArgsConstructor
public class MedicalHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private RecordType recordType;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    // S3 or Firebase Storage URLs
    @ElementCollection
    @CollectionTable(
            name = "medical_history_attachments",
            joinColumns = @JoinColumn(name = "history_id")
    )
    @Column(name = "attachment_url")
    private List<String> attachments;

    @Column(nullable = false, updatable = false)
    @CreationTimestamp
    private LocalDateTime recordedAt;


}