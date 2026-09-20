package com.Grp._8.backend.services.files;

import com.Grp._8.backend.entities.prescription.Prescription;
import com.Grp._8.backend.entities.prescription.PrescriptionItem;
import com.Grp._8.backend.entities.users.Patient;
import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.exceptions.FileStorageException;
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

    public byte[] renderPreview(Prescription prescription) {
        Context context = buildContext(prescription);
        String html = templateEngine.process("prescription-pdf", context);
        return convertToPdf(html);
    }

    public String generateAndStore(Prescription prescription) {
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

        // ── Vitals — all sourced from THIS visit's Prescription snapshot, not the patient's stored profile ──
        ctx.setVariable("bloodPressure", rx.getBloodPressure() != null ? rx.getBloodPressure() : "N/A");
        ctx.setVariable("bloodSugar", rx.getBloodSugar());
        ctx.setVariable("heartRate", rx.getHeartRate());
        ctx.setVariable("bodyTemp", rx.getBodyTemp());
        // raw numbers only — template owns unit formatting, no double-appending
        ctx.setVariable("height", rx.getHeight());
        ctx.setVariable("weight", rx.getWeight());

        // ── Clinical ──────────────────────────────────────────────
        ctx.setVariable("clinicalObservations",
                rx.getClinicalObservations() != null ? rx.getClinicalObservations() : "No observations recorded");
        ctx.setVariable("symptoms", rx.getSymptoms() != null ? rx.getSymptoms() : List.of());

        // ── Doctor ────────────────────────────────────────────────
        Users doctorUser = rx.getDoctor().getUserData();
        ctx.setVariable("doctorName", doctorUser.getName());
        ctx.setVariable("doctorSpecialization", formatEnumDisplay(rx.getDoctor().getDepartment()));
        ctx.setVariable("doctorEmail", doctorUser.getEmail());

        // ── Signature — only present once the doctor has actually signed ─
        ctx.setVariable("signatureImageUrl", rx.getSignatureImageUrl());

        // ── Meta ──────────────────────────────────────────────────
        ctx.setVariable("prescriptionDate",
                rx.getCreatedAt().format(DateTimeFormatter.ofPattern("MMM dd, yyyy")));
        ctx.setVariable("referenceNumber", rx.getReferenceNumber());
        ctx.setVariable("generatedAt",
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));

        // ── Prescription items — frequency derived from morning/afternoon/evening,
        //    since PrescriptionItem has no `frequency` or `instructions` field.
        List<Map<String, String>> items = rx.getPrescriptionItems().stream()
                .map(item -> Map.of(
                        "medicineName", item.getMedicine().getName(),
                        "dosage",       item.getDosage(),
                        "frequency",    formatFrequency(item),
                        "durationDays", String.valueOf(item.getDurationDays()),
                        "doseTiming",   item.getDoseTiming() != null ? item.getDoseTiming().toString() : "—"
                ))
                .toList();
        ctx.setVariable("prescriptionItems", items);

        return ctx;
    }

    private String formatFrequency(PrescriptionItem item) {
        return (Boolean.TRUE.equals(item.getMorning()) ? "1" : "0") + "-"
                + (Boolean.TRUE.equals(item.getAfternoon()) ? "1" : "0") + "-"
                + (Boolean.TRUE.equals(item.getEvening()) ? "1" : "0");
    }

    private byte[] convertToPdf(String html) {
        try (ByteArrayOutputStream os = new ByteArrayOutputStream()) {
            PdfRendererBuilder builder = new PdfRendererBuilder();
            builder.useFastMode();
            builder.withHtmlContent(html, null);
            builder.toStream(os);
            builder.run();
            return os.toByteArray();
        } catch (IOException e) {
            throw new FileStorageException("Failed to render PDF", e);
        }
    }

    private String formatEnumDisplay(Enum<?> value) {
        if (value == null) return "N/A";
        String name = value.name().replace("_", " ").toLowerCase();
        return Character.toUpperCase(name.charAt(0)) + name.substring(1);
    }
}