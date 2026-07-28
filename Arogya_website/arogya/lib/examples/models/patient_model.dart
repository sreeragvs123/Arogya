class PatientModel {
  final String id;
  final String name;
  final String dateOfBirth;
  final int age;
  final String gender;
  final String aadhaarNumber;
  final String phone;
  final String bloodGroup;
  final String address;
  final String city;
  final String departmentId;
  final String doctorId;
  final String registrationDate;
  final String username;
  final String? photoUrl;
  final String status; // Active, Critical, Stable, Recovering

  const PatientModel({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.age,
    required this.gender,
    required this.aadhaarNumber,
    required this.phone,
    required this.bloodGroup,
    required this.address,
    required this.city,
    required this.departmentId,
    required this.doctorId,
    required this.registrationDate,
    required this.username,
    this.photoUrl,
    this.status = 'Active',
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        dateOfBirth: json['dateOfBirth'] ?? '',
        age: json['age'] ?? 0,
        gender: json['gender'] ?? '',
        aadhaarNumber: json['aadhaarNumber'] ?? '',
        phone: json['phone'] ?? '',
        bloodGroup: json['bloodGroup'] ?? '',
        address: json['address'] ?? '',
        city: json['city'] ?? '',
        departmentId: json['departmentId'] ?? '',
        doctorId: json['doctorId'] ?? '',
        registrationDate: json['registrationDate'] ?? '',
        username: json['username'] ?? '',
        photoUrl: json['photoUrl'],
        status: json['status'] ?? 'Active',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dateOfBirth': dateOfBirth,
        'age': age,
        'gender': gender,
        'aadhaarNumber': aadhaarNumber,
        'phone': phone,
        'bloodGroup': bloodGroup,
        'address': address,
        'city': city,
        'departmentId': departmentId,
        'doctorId': doctorId,
        'registrationDate': registrationDate,
        'username': username,
        'photoUrl': photoUrl,
        'status': status,
      };

  PatientModel copyWith({
    String? id, String? name, String? dateOfBirth, int? age,
    String? gender, String? aadhaarNumber, String? phone,
    String? bloodGroup, String? address, String? city,
    String? departmentId, String? doctorId, String? registrationDate,
    String? username, String? photoUrl, String? status,
  }) => PatientModel(
        id: id ?? this.id,
        name: name ?? this.name,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
        phone: phone ?? this.phone,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        address: address ?? this.address,
        city: city ?? this.city,
        departmentId: departmentId ?? this.departmentId,
        doctorId: doctorId ?? this.doctorId,
        registrationDate: registrationDate ?? this.registrationDate,
        username: username ?? this.username,
        photoUrl: photoUrl ?? this.photoUrl,
        status: status ?? this.status,
      );
}

// ── Medication Model ──────────────────────────────────────────────────────────
class MedicationModel {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final List<String> timing; // Morning, Afternoon, Evening, Night

  const MedicationModel({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.timing,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) => MedicationModel(
        name: json['name'] ?? '',
        dosage: json['dosage'] ?? '',
        frequency: json['frequency'] ?? '',
        duration: json['duration'] ?? '',
        timing: List<String>.from(json['timing'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'dosage': dosage,
        'frequency': frequency,
        'duration': duration,
        'timing': timing,
      };
}

// ── Checkup Receipt Model ─────────────────────────────────────────────────────
class CheckupReceiptModel {
  final String receiptId;
  final String patientId;
  final String doctorId;
  final String date;
  final String diagnosis;
  final String symptoms;
  final String doctorNotes;
  final String followUpDate;
  final List<MedicationModel> medications;
  final List<String> attachedFileUrls;

  const CheckupReceiptModel({
    required this.receiptId,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.diagnosis,
    required this.symptoms,
    required this.doctorNotes,
    required this.followUpDate,
    required this.medications,
    required this.attachedFileUrls,
  });

  factory CheckupReceiptModel.fromJson(Map<String, dynamic> json) => CheckupReceiptModel(
        receiptId: json['receiptId'] ?? '',
        patientId: json['patientId'] ?? '',
        doctorId: json['doctorId'] ?? '',
        date: json['date'] ?? '',
        diagnosis: json['diagnosis'] ?? '',
        symptoms: json['symptoms'] ?? '',
        doctorNotes: json['doctorNotes'] ?? '',
        followUpDate: json['followUpDate'] ?? '',
        medications: (json['medications'] as List<dynamic>? ?? [])
            .map((m) => MedicationModel.fromJson(m as Map<String, dynamic>))
            .toList(),
        attachedFileUrls: List<String>.from(json['attachedFileUrls'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'receiptId': receiptId,
        'patientId': patientId,
        'doctorId': doctorId,
        'date': date,
        'diagnosis': diagnosis,
        'symptoms': symptoms,
        'doctorNotes': doctorNotes,
        'followUpDate': followUpDate,
        'medications': medications.map((m) => m.toJson()).toList(),
        'attachedFileUrls': attachedFileUrls,
      };
}

// ── QR Card Model ─────────────────────────────────────────────────────────────
class QrCardModel {
  final String patientId;
  final String username;
  final String qrData; // encoded string used for QR generation
  final String issuedDate;

  const QrCardModel({
    required this.patientId,
    required this.username,
    required this.qrData,
    required this.issuedDate,
  });

  factory QrCardModel.fromJson(Map<String, dynamic> json) => QrCardModel(
        patientId: json['patientId'] ?? '',
        username: json['username'] ?? '',
        qrData: json['qrData'] ?? '',
        issuedDate: json['issuedDate'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'username': username,
        'qrData': qrData,
        'issuedDate': issuedDate,
      };
}
