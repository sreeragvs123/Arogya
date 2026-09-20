part of 'patient_details_bloc.dart';

sealed class PatientDetailsEvent extends Equatable {
  const PatientDetailsEvent();

  @override
  List<Object?> get props => [];
}

class PatientDetailsStarted extends PatientDetailsEvent {
  final String patientId;
  const PatientDetailsStarted(this.patientId);
  @override
  List<Object?> get props => [patientId];
}

class PatientDetailsRefreshRequested extends PatientDetailsEvent {
  const PatientDetailsRefreshRequested();
}

// --- Vitals ---
class VitalsUpdateSubmitted extends PatientDetailsEvent {
  final VitalsUpdateInput input;
  const VitalsUpdateSubmitted(this.input);
  @override
  List<Object?> get props => [input];
}

// --- Observations ---
class SymptomAdded extends PatientDetailsEvent {
  final String symptom;
  const SymptomAdded(this.symptom);
  @override
  List<Object?> get props => [symptom];
}

class SymptomRemoved extends PatientDetailsEvent {
  final String symptom;
  const SymptomRemoved(this.symptom);
  @override
  List<Object?> get props => [symptom];
}

class ObservationsSaveRequested extends PatientDetailsEvent {
  final String clinicalNote;
  const ObservationsSaveRequested(this.clinicalNote);
  @override
  List<Object?> get props => [clinicalNote];
}

// --- Prescription ---
class PrescriptionItemAdded extends PatientDetailsEvent {
  final String name;
  final String dosage;
  final String frequency;
  final String timing;
  const PrescriptionItemAdded({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.timing,
  });
  @override
  List<Object?> get props => [name, dosage, frequency, timing];
}

class PrescriptionItemRemoved extends PatientDetailsEvent {
  final String itemId;
  const PrescriptionItemRemoved(this.itemId);
  @override
  List<Object?> get props => [itemId];
}

class PrescriptionDiscardRequested extends PatientDetailsEvent {
  const PrescriptionDiscardRequested();
}

class PrescriptionSaveRequested extends PatientDetailsEvent {
  const PrescriptionSaveRequested();
}

// --- Clinical report ---
class ClinicalReportGenerateRequested extends PatientDetailsEvent {
  const ClinicalReportGenerateRequested();
}

class ClinicalReportSignatureAdded extends PatientDetailsEvent {
  const ClinicalReportSignatureAdded();
}
