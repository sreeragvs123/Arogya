# New backend endpoints required

All responses are expected in the existing `ApiResponse<T>` envelope already used
by the hospital-dashboard endpoints: `{ "timestamp": ..., "data": T | null, "error": {"message": string} | null }`.
Auth is via the existing Bearer JWT (Dio interceptor already attaches it), so
"doctor" and "patient" scoping below is derived server-side from the token,
not from path parameters, unless a patientId is explicitly part of the URL.

## Doctor Dashboard

| Method | Path | Notes |
|---|---|---|
| GET | `/doctor/dashboard/summary` | `{ morningOverview: {consultationsToday, capacityPercent}, pendingReportsCount, newReportsCount, criticalAlertsCount, weeklySummary: {efficiencyDeltaPercent, progress} }` |
| GET | `/doctor/dashboard/consultations` | List of `{id, patientId, patientName, time, reason, initials?, avatarUrl?, action: "START_VISIT"|"JOIN_CALL", status: "UPCOMING"|"IN_PROGRESS"|"COMPLETED"}` |
| GET | `/doctor/dashboard/activity?limit=10` | List of `{id, title, description, timeAgo, isHighlighted}` |
| POST | `/doctor/consultations/{consultationId}/start` | Marks a consultation in-progress |
| POST | `/doctor/consultations/{consultationId}/join-call` | Marks a telehealth call as joined |

## Patients Directory

| Method | Path | Notes |
|---|---|---|
| GET | `/doctor/patients/summary` | `{totalPatients, totalPatientsGrowth, newThisMonth, followUpsPending}` |
| GET | `/doctor/patients/active` | The patient currently in an active session with this doctor, or `data: null` / 404 if none |
| GET | `/doctor/patients?query=&sortBy=&condition=&page=&size=` | Spring-style Page response: `{content: [...], number, size, totalPages, totalElements}` of `{id, name, patientId, age, gender, status, lastVisit, diagnosis, isHighRisk}` |
| GET | `/patients/lookup?identifier=` | Resolves a manually entered or scanned Patient Identifier to the same patient shape above (404 if not found) |

## Patient Detail Workspace

| Method | Path | Notes |
|---|---|---|
| GET | `/patients/{patientId}` | `{id, name, displayId, age, gender, bloodGroup, heightCm, weightKg, isHighSensitivity, photoUrl?}` |
| GET | `/patients/{patientId}/vitals` | `{heartRateBpm, heartRateStatus, heartRateTrend: number[], bloodPressure, bloodPressureStatus, bodyTempF, bloodSugar?, weightKg?, heightCm?}` |
| POST | `/patients/{patientId}/vitals` | Body: any subset of `{heartRateBpm, bloodPressure, bodyTempF, bloodSugar, weightKg, heightCm}` (all strings as typed). Returns the updated vitals shape above. |
| GET | `/patients/{patientId}/observations` | List of `{date, note}`, most recent first |
| POST | `/patients/{patientId}/observations` | Body: `{symptoms: string[], clinicalNote: string}` |
| GET | `/patients/{patientId}/prescription/draft` | List of `{id, name, dosage, frequency, timing}` |
| POST | `/patients/{patientId}/prescription/save` | Body: `{items: [{id, name, dosage, frequency, timing}]}` — full replace of the draft |
| POST | `/patients/{patientId}/clinical-report/generate` | Compiles vitals+observations+prescription into a report; returns `{sessionDuration, reportDate, reportRef, signaturePending}` |

## Notes / open items

- **Doctor auth isn't wired to a real backend yet** (`auth_bloc.dart` still has a
  TODO for `doctorLogin`), so none of the above can be exercised end-to-end
  until that lands — but the frontend contract above is ready for it.
- **QR camera scanning** is UI-only right now (placeholder preview). Wiring a
  real scanner needs a package like `mobile_scanner` added to `pubspec.yaml`;
  the hook (`_handleQrDetected` in `patient_qr_sync_page.dart`) already routes
  a decoded string through the same `lookupPatient` flow as manual entry.
- **"Full History"**, **"View Calendar"**, and **"View Full Activity Log"**
  currently show a "coming soon" snackbar rather than navigating anywhere,
  since no such pages/routes exist yet.
- **Print QR** and **Review Document** show an in-app dialog rather than
  producing a real PDF/print job — no PDF/printing package is in the
  dependencies yet.
