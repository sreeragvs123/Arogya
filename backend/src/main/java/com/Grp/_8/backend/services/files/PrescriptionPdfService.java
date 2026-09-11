package com.Grp._8.backend.services.files;

import com.Grp._8.backend.entities.prescription.Prescription;
import com.Grp._8.backend.entities.users.Patient;
import com.Grp._8.backend.entities.users.Users;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PrescriptionPdfService {

    private final TemplateEngine templateEngine;
    private final StorageService storageService;

    public String generateAndStore(Prescription prescription) throws IOException {
        Context context = buildContext(prescription);
        String html = templateEngine.process("prescription-pdf", context);
        byte[] pdfBytes = convertToPdf(html);

        String fileName = "RX-" + prescription.getId() + "-" + System.currentTimeMillis();
        return storageService.upload(pdfBytes, fileName);
    }

    private Context buildContext(Prescription rx) {
        Context ctx = new Context();

        // ── Hospital ──────────────────────────────────────────────
        ctx.setVariable("hospitalName", rx.getHospital().getUserData().getName());
        ctx.setVariable("hospitalType", rx.getHospital().getHospitalType().toString());

        // ── Patient ───────────────────────────────────────────────
        Patient p = rx.getPatient();
        Users patientUser = p.getUserData();

        ctx.setVariable("patientName", patientUser.getName());
        ctx.setVariable("patientEmail", patientUser.getEmail());
        ctx.setVariable("patientCode", p.getQrCode());
        ctx.setVariable("patientAddress", p.getAddress());
        ctx.setVariable("patientPhone", p.getPhoneNumber());
        ctx.setVariable("patientGender", p.getSex() != null ? p.getSex().toString() : "N/A");
        ctx.setVariable("bloodType", p.getBloodType() != null ? p.getBloodType().toString() : "N/A");
        ctx.setVariable("patientAge",
                p.getDateOfBirth() != null
                        ? Period.between(p.getDateOfBirth(), LocalDate.now()).getYears()
                        : "N/A");
        ctx.setVariable("height", p.getHeightCm() != null ? p.getHeightCm() + " cm" : "N/A");

        // ── Vitals stored on Prescription ─────────────────────────
        ctx.setVariable("bloodPressure", rx.getBloodPressure() != null ? rx.getBloodPressure() : "N/A");
        ctx.setVariable("bloodSugar", rx.getBloodSugar() != null ? rx.getBloodSugar() + " mg/dL" : "N/A");
        ctx.setVariable("heartRate", rx.getHeartRate() != null ? rx.getHeartRate() + " BPM" : "N/A");
        ctx.setVariable("bodyTemp", rx.getBodyTemp() != null ? rx.getBodyTemp() + " °F" : "N/A");
        ctx.setVariable("weight", rx.getWeight() != null ? rx.getWeight() + " kg" : "N/A");

        // ── Clinical ──────────────────────────────────────────────
        ctx.setVariable("clinicalObservations",
                rx.getClinicalObservations() != null ? rx.getClinicalObservations() : "No observations recorded");

        // symptoms is now a tag list, not free text
        ctx.setVariable("symptoms", rx.getSymptoms() != null ? rx.getSymptoms() : List.of());

        // ── Doctor ────────────────────────────────────────────────
        Users doctorUser = rx.getDoctor().getUserData();
        ctx.setVariable("doctorName", doctorUser.getName());
        ctx.setVariable("doctorSpecialization", rx.getDoctor().getSpecialization());
        ctx.setVariable("doctorEmail", doctorUser.getEmail());

        // ── Meta ──────────────────────────────────────────────────
        ctx.setVariable("prescriptionDate",
                rx.getCreatedAt().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")));
        ctx.setVariable("referenceNumber", rx.getReferenceNumber());
        ctx.setVariable("generatedAt",
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));

        // ── Prescription items ────────────────────────────────────
        List<Map<String, String>> items = rx.getPrescriptionItems().stream()
                .map(item -> Map.of(
                        "medicineName", item.getMedicine().getName(),
                        "dosage",       item.getDosage(),
                        "frequency",    item.getFrequency().toString(),
                        "durationDays", String.valueOf(item.getDurationDays()),
                        "doseTiming",   item.getDoseTiming().toString(),
                        "morning",      Boolean.TRUE.equals(item.getMorning()) ? "Yes" : "No",
                        "afternoon",    Boolean.TRUE.equals(item.getAfternoon()) ? "Yes" : "No",
                        "evening",      Boolean.TRUE.equals(item.getEvening()) ? "Yes" : "No",
                        "instructions", item.getInstructions() != null ? item.getInstructions() : ""
                ))
                .toList();
        ctx.setVariable("prescriptionItems", items);

        return ctx;
    }

    private byte[] convertToPdf(String html) throws IOException {
        try (ByteArrayOutputStream os = new ByteArrayOutputStream()) {
            PdfRendererBuilder builder = new PdfRendererBuilder();
            builder.useFastMode();
            builder.withHtmlContent(html, null);
            builder.toStream(os);
            builder.run();
            return os.toByteArray();
        }
    }
}