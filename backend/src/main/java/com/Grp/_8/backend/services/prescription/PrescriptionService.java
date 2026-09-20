package com.Grp._8.backend.services.prescription;

import com.Grp._8.backend.dto.vitals.VitalsResponseDto;
import com.Grp._8.backend.dto.vitals.VitalsUpdateRequestDto;
import com.Grp._8.backend.entities.enums.ReportStatus;
import com.Grp._8.backend.entities.prescription.Prescription;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.entities.users.Patient;
import com.Grp._8.backend.exceptions.ResourceNotFoundException;
import com.Grp._8.backend.repositories.prescription.PrescriptionRepository;
import com.Grp._8.backend.repositories.users.DoctorRepository;
import com.Grp._8.backend.repositories.users.HospitalRepository;
import com.Grp._8.backend.repositories.users.PatientRepository;
import com.Grp._8.backend.services.files.PrescriptionPdfService;
import com.Grp._8.backend.utils.ReferenceNumberGenerator;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PrescriptionService {

    private final PrescriptionRepository prescriptionRepository;
    private final PatientRepository patientRepository;
    private final DoctorRepository doctorRepository;
    private final HospitalRepository hospitalRepository;
    private final PrescriptionPdfService prescriptionPdfService;
    private final ReferenceNumberGenerator referenceNumberGenerator;
    private final ModelMapper modelMapper;

    @Transactional
    public PrescriptionResponseDto generateAndSend(Long prescriptionId) throws IOException {
        Prescription prescription = prescriptionRepository.findById(prescriptionId)
                .orElseThrow(() -> new ResourceNotFoundException("Prescription not found: " + prescriptionId));

        if (prescription.getPrescriptionItems().isEmpty()) {
            throw new IllegalStateException("Cannot generate — no medicines added");
        }

        String pdfUrl = prescriptionPdfService.generateAndStore(prescription);
        prescription.setPdfUrl(pdfUrl);
        prescription.setStatus(ReportStatus.SENT);
        Prescription saved = prescriptionRepository.save(prescription);

        // notificationService.sendPrescriptionAlert(...) — wire when ready

        return toResponseDto(saved);
    }

    private PrescriptionResponseDto toResponseDto(Prescription p) {
        List<PrescriptionItemResponseDto> items = p.getPrescriptionItems().stream()
                .map(item -> PrescriptionItemResponseDto.builder()
                        .itemId(item.getId())
                        .medicineName(item.getMedicine().getName())
                        .dosage(item.getDosage())
                        .morning(item.getMorning())
                        .afternoon(item.getAfternoon())
                        .evening(item.getEvening())
                        .weeklyDays(item.getWeeklyDays())
                        .doseTiming(item.getDoseTiming())
                        .startDate(item.getStartDate())
                        .durationDays(item.getDurationDays())
                        .build())
                .toList();

        return PrescriptionResponseDto.builder()
                .id(p.getId())
                .referenceNumber(p.getReferenceNumber())
                .status(p.getStatus())
                .pdfUrl(p.getPdfUrl())
                .clinicalObservations(p.getClinicalObservations())
                .symptoms(p.getSymptoms())
                .bloodPressure(p.getBloodPressure())
                .bloodSugar(p.getBloodSugar())
                .weight(p.getWeight())
                .height(p.getHeight())
                .heartRate(p.getHeartRate())
                .bodyTemp(p.getBodyTemp())
                .items(items)
                .build();
    }



    @Transactional
    public PrescriptionDraftResponseDto createDraft(Long patientId, Long doctorId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new ResourceNotFoundException("Patient not found: " + patientId));

        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() -> new ResourceNotFoundException("Doctor not found: " + doctorId));

        Prescription prescription = new Prescription();
        prescription.setPatient(patient);
        prescription.setDoctor(doctor);
        prescription.setHospital(doctor.getHospital());
        prescription.setReferenceNumber(referenceNumberGenerator.generate());
        prescription.setStatus(ReportStatus.DRAFT);

        Prescription savedPrescription = prescriptionRepository.save(prescription);

        return PrescriptionDraftResponseDto.builder()
                .prescriptionId(savedPrescription.getId())
                .referenceNumber(savedPrescription.getReferenceNumber())
                .status(savedPrescription.getStatus())
                .build();
    }


    @Transactional
    public VitalsResponseDto updateVitals(Long prescriptionId, VitalsUpdateRequestDto dto) {
        Prescription prescription = prescriptionRepository.findById(prescriptionId)
                .orElseThrow(() -> new ResourceNotFoundException("Prescription not found: " + prescriptionId));

        if (dto.getBloodPressure() != null) {
            prescription.setBloodPressure(dto.getBloodPressure());
        }
        if (dto.getBloodSugar() != null) {
            prescription.setBloodSugar(dto.getBloodSugar());
        }
        if (dto.getWeight() != null) {
            prescription.setWeight(dto.getWeight());
        }
        if (dto.getHeight() != null) {
            prescription.setHeight(dto.getHeight());
        }
        if (dto.getHeartRate() != null) {
            prescription.setHeartRate(dto.getHeartRate());
        }
        if (dto.getBodyTemp() != null) {
            prescription.setBodyTemp(dto.getBodyTemp());
        }

        Prescription saved = prescriptionRepository.save(prescription);

        return VitalsResponseDto.builder()
                .prescriptionId(saved.getId())
                .bloodPressure(saved.getBloodPressure())
                .bloodSugar(saved.getBloodSugar())
                .weight(saved.getWeight())
                .height(saved.getHeight())
                .heartRate(saved.getHeartRate())
                .bodyTemp(saved.getBodyTemp())
                .build();
    }
}