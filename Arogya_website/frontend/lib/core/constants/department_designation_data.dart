

const List<Map<String, String>> kDepartmentOptions = [
  {'value': 'GENERAL_PHYSICIAN', 'label': 'General Physician'},
  {'value': 'PEDIATRICIAN', 'label': 'Pediatrician'},
  {
    'value': 'GYNECOLOGIST_OBSTETRICIAN',
    'label': 'Gynecologist / Obstetrician (OB-GYN)',
  },
  {'value': 'GENERAL_SURGEON', 'label': 'General Surgeon'},
  {'value': 'ORTHOPEDIC_SURGEON', 'label': 'Orthopedic Surgeon'},
  {'value': 'CARDIOLOGIST', 'label': 'Cardiologist'},
  {'value': 'NEUROLOGIST', 'label': 'Neurologist'},
  {'value': 'GASTROENTEROLOGIST', 'label': 'Gastroenterologist'},
  {'value': 'NEPHROLOGIST', 'label': 'Nephrologist'},
  {'value': 'PULMONOLOGIST', 'label': 'Pulmonologist'},
  {'value': 'ENDOCRINOLOGIST', 'label': 'Endocrinologist'},
  {'value': 'ONCOLOGIST', 'label': 'Oncologist'},
  {'value': 'RADIOLOGIST', 'label': 'Radiologist'},
  {'value': 'ANESTHESIOLOGIST', 'label': 'Anesthesiologist'},
  {'value': 'PATHOLOGIST', 'label': 'Pathologist'},
  {
    'value': 'EMERGENCY_MEDICINE_PHYSICIAN',
    'label': 'Emergency Medicine Physician',
  },
  {'value': 'DERMATOLOGIST', 'label': 'Dermatologist'},
  {'value': 'PSYCHIATRIST', 'label': 'Psychiatrist'},
  {'value': 'ENT_SURGEON', 'label': 'ENT Surgeon'},
  {'value': 'UROLOGIST', 'label': 'Urologist'},
  {'value': 'OPHTHALMOLOGIST', 'label': 'Ophthalmologist'},
];

const List<Map<String, String>> kDesignationOptions = [
  {'value': 'HOD', 'label': 'Head of Department (HOD)'},
  {'value': 'SENIOR_CONSULTANT', 'label': 'Senior Consultant'},
  {'value': 'CONSULTANT', 'label': 'Consultant'},
  {'value': 'ATTENDING_PHYSICIAN', 'label': 'Attending Physician'},
  {'value': 'RESIDENT_DOCTOR', 'label': 'Resident Doctor'},
  {'value': 'CLINICAL_FELLOW', 'label': 'Clinical Fellow'},
  {'value': 'JUNIOR_DOCTOR', 'label': 'Junior Doctor'},
  {'value': 'INTERN', 'label': 'Intern'},
];


String labelFor(List<Map<String, String>> options, String value) {
  for (final option in options) {
    if (option['value'] == value) return option['label']!;
  }
  return value;
}