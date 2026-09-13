# 🏥 Arogya — Hospital Workflow Management System

Arogya is a full-stack healthcare platform that connects **Hospitals**, **Doctors**, and **Patients** in a single digital workflow — from hospital onboarding and doctor management to consultations, prescriptions, and medication reminders.

---

## 📖 Overview

Arogya streamlines the day-to-day operations of hospitals and the treatment journey of patients by digitizing the entire consultation lifecycle:

- Hospitals register on the platform and manage their doctors department-wise.
- Doctors consult patients, record diagnoses, and generate digital prescriptions.
- Patients receive prescriptions and medication reminders directly on their phones, along with a consolidated history of their treatment across multiple hospitals.

The system is built as a **website** (for Hospitals & Doctors) and a **mobile app** (for Patients), both powered by a common **Spring Boot** backend.

---

## 👥 Actors

| Actor | Platform | Role |
|---|---|---|
| **Hospital** | Website | Registers the hospital on the platform and creates/manages doctors under specific departments |
| **Doctor** | Website | Logs in under their registered hospital, views assigned patients and their medical history, conducts consultations, and issues prescriptions |
| **Patient** | Mobile App | Views prescriptions, receives medicine reminders, and accesses their complete treatment history across hospitals |
| **User** | Website / App | Represents general/shared account access across the platform |

---

## ✨ Key Features

### 🏨 Hospital (Website)
- Hospital self-registration
- Create and manage doctors, organized by department

### 🩺 Doctor (Website)
- Login scoped to the specific hospital of registration
- View list of assigned patients
- Access complete previous medical records of a patient
- Conduct consultations:
  - Record diagnosis notes
  - Assign medicines
  - Generate a digital **prescription PDF**
- Prescription is automatically sent to the patient's mobile app

### 🙍 Patient (Mobile App)
- Receive prescriptions directly on the app
- Automatic **medication reminder notifications** based on prescribed dosage/schedule
- View consolidated treatment history across **multiple hospitals**

---

## 🏗️ Tech Stack

| Layer | Technology |
|---|---|
| Website | Flutter (Web) |
| Mobile App | Flutter |
| Backend | Spring Boot |
| Database | *(add your DB, e.g. PostgreSQL / MySQL)* |
| Notifications | Firebase Cloud Messaging (medication reminders) |
| Authentication | Spring Security *(add JWT/OAuth2 if applicable)* |
| PDF Generation | *(add library used, e.g. iText / OpenPDF)* |

---

## 🧩 System Architecture

```
┌────────────────────┐        ┌──────────────────────┐
│  Flutter Website    │        │   Flutter Mobile App │
│ (Hospital & Doctor)  │        │      (Patient)        │
└──────────┬──────────┘        └───────────┬───────────┘
           │                               │
           │           REST API            │
           └───────────────┬───────────────┘
                            │
                 ┌──────────▼──────────┐
                 │   Spring Boot API    │
                 │  (Auth, Hospitals,   │
                 │  Doctors, Patients,  │
                 │  Prescriptions)      │
                 └──────────┬──────────┘
                            │
                 ┌──────────▼──────────┐
                 │      Database        │
                 └──────────────────────┘
                            │
                 ┌──────────▼──────────┐
                 │  Firebase (Push /    │
                 │  Medicine Reminders) │
                 └──────────────────────┘
```

---

## 🔄 Core Workflow

1. **Hospital Registration** — A hospital signs up on the website.
2. **Doctor Onboarding** — The hospital creates doctor accounts under specific departments.
3. **Doctor Login** — Doctors log in under their registered hospital.
4. **Patient Consultation** — The doctor views the patient's history, conducts the consultation, and records the diagnosis.
5. **Prescription Generation** — Medicines are assigned, and a prescription PDF is generated.
6. **Delivery to Patient** — The prescription is sent to the patient's mobile app.
7. **Medication Reminders** — The app schedules notifications based on the prescribed medication.
8. **Unified Patient History** — All treatment records, across all hospitals visited, are stored and accessible within the patient's app.

---

## 📁 Project Structure

```
arogya/
├── arogya_website/        # Flutter Web app (Hospital & Doctor)
├── arogya_app/            # Flutter mobile app (Patient)
├── arogya_backend/        # Spring Boot backend
│   ├── src/main/java/...
│   └── src/main/resources/
└── README.md
```

*(Update this section to match your actual repo/folder layout.)*

---

## ⚙️ Getting Started

### Prerequisites
- Flutter SDK (>= 3.x)
- JDK 17+
- Maven or Gradle
- A running instance of your chosen database
- Firebase project (for push notifications)

### Backend Setup
```bash
cd arogya_backend
./mvnw spring-boot:run
```

### Website Setup
```bash
cd arogya_website
flutter pub get
flutter run -d chrome
```

### Mobile App Setup
```bash
cd arogya_app
flutter pub get
flutter run
```

*(Add environment variable / `.env` / `application.properties` configuration instructions here.)*

---

## 🗺️ Roadmap

- [ ] Hospital registration & authentication
- [ ] Doctor management (department-wise)
- [ ] Doctor login scoped to hospital
- [ ] Patient assignment & history view
- [ ] Consultation & prescription module
- [ ] Prescription PDF generation
- [ ] Delivery of prescriptions to patient app
- [ ] Medicine reminder notification system
- [ ] Multi-hospital patient history aggregation

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome. Feel free to check the [issues page](../../issues) if you want to contribute.

---

## 📄 License

*(Add your license here, e.g. MIT License)*

---

## 📬 Contact

**Project Author:** Sreerag
**Project:** Arogya — Hospital Workflow Management System
