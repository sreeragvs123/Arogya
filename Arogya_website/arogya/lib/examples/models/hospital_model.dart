// ── Hospital Model ────────────────────────────────────────────────────────────
class HospitalModel {
  final String id;
  final String name;
  final String registrationNumber;
  final String type; // Government, Private, Trust/NGO, Clinic, Multispecialty
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String username;
  final String createdAt;

  const HospitalModel({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.type,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.username,
    required this.createdAt,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) => HospitalModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        registrationNumber: json['registrationNumber'] ?? '',
        type: json['type'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        pincode: json['pincode'] ?? '',
        username: json['username'] ?? '',
        createdAt: json['createdAt'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'registrationNumber': registrationNumber,
        'type': type,
        'email': email,
        'phone': phone,
        'address': address,
        'city': city,
        'state': state,
        'pincode': pincode,
        'username': username,
        'createdAt': createdAt,
      };

  HospitalModel copyWith({
    String? id, String? name, String? registrationNumber, String? type,
    String? email, String? phone, String? address, String? city,
    String? state, String? pincode, String? username, String? createdAt,
  }) => HospitalModel(
        id: id ?? this.id,
        name: name ?? this.name,
        registrationNumber: registrationNumber ?? this.registrationNumber,
        type: type ?? this.type,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        city: city ?? this.city,
        state: state ?? this.state,
        pincode: pincode ?? this.pincode,
        username: username ?? this.username,
        createdAt: createdAt ?? this.createdAt,
      );
}

// ── Department Model ──────────────────────────────────────────────────────────
class DepartmentModel {
  final String id;
  final String hospitalId;
  final String name;
  final String headDoctorId;
  final String headDoctorName;
  final int doctorCount;
  final int activePatientCount;

  const DepartmentModel({
    required this.id,
    required this.hospitalId,
    required this.name,
    required this.headDoctorId,
    required this.headDoctorName,
    required this.doctorCount,
    required this.activePatientCount,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) => DepartmentModel(
        id: json['id'] ?? '',
        hospitalId: json['hospitalId'] ?? '',
        name: json['name'] ?? '',
        headDoctorId: json['headDoctorId'] ?? '',
        headDoctorName: json['headDoctorName'] ?? '',
        doctorCount: json['doctorCount'] ?? 0,
        activePatientCount: json['activePatientCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'hospitalId': hospitalId,
        'name': name,
        'headDoctorId': headDoctorId,
        'headDoctorName': headDoctorName,
        'doctorCount': doctorCount,
        'activePatientCount': activePatientCount,
      };
}

// ── Doctor Model ──────────────────────────────────────────────────────────────
class DoctorModel {
  final String id;
  final String hospitalId;
  final String departmentId;
  final String name;
  final String specialisation;
  final String phone;
  final String email;
  final String experience;
  final bool isAvailable;
  final int activePatientCount;

  const DoctorModel({
    required this.id,
    required this.hospitalId,
    required this.departmentId,
    required this.name,
    required this.specialisation,
    required this.phone,
    required this.email,
    required this.experience,
    required this.isAvailable,
    required this.activePatientCount,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
        id: json['id'] ?? '',
        hospitalId: json['hospitalId'] ?? '',
        departmentId: json['departmentId'] ?? '',
        name: json['name'] ?? '',
        specialisation: json['specialisation'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '',
        experience: json['experience'] ?? '',
        isAvailable: json['isAvailable'] ?? true,
        activePatientCount: json['activePatientCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'hospitalId': hospitalId,
        'departmentId': departmentId,
        'name': name,
        'specialisation': specialisation,
        'phone': phone,
        'email': email,
        'experience': experience,
        'isAvailable': isAvailable,
        'activePatientCount': activePatientCount,
      };

  DoctorModel copyWith({
    String? id, String? hospitalId, String? departmentId, String? name,
    String? specialisation, String? phone, String? email,
    String? experience, bool? isAvailable, int? activePatientCount,
  }) => DoctorModel(
        id: id ?? this.id,
        hospitalId: hospitalId ?? this.hospitalId,
        departmentId: departmentId ?? this.departmentId,
        name: name ?? this.name,
        specialisation: specialisation ?? this.specialisation,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        experience: experience ?? this.experience,
        isAvailable: isAvailable ?? this.isAvailable,
        activePatientCount: activePatientCount ?? this.activePatientCount,
      );
}

// ── Inventory / Medicine Model ────────────────────────────────────────────────
class MedicineStockModel {
  final String id;
  final String hospitalId;
  final String name;
  final String category;
  final int stock;
  final String unit;
  final int minStock;
  final String expiry;
  final String manufacturer;
  final double pricePerUnit;

  const MedicineStockModel({
    required this.id,
    required this.hospitalId,
    required this.name,
    required this.category,
    required this.stock,
    required this.unit,
    required this.minStock,
    required this.expiry,
    required this.manufacturer,
    required this.pricePerUnit,
  });

  bool get isLowStock => stock <= minStock;

  factory MedicineStockModel.fromJson(Map<String, dynamic> json) => MedicineStockModel(
        id: json['id'] ?? '',
        hospitalId: json['hospitalId'] ?? '',
        name: json['name'] ?? '',
        category: json['category'] ?? '',
        stock: json['stock'] ?? 0,
        unit: json['unit'] ?? 'Units',
        minStock: json['minStock'] ?? 50,
        expiry: json['expiry'] ?? '',
        manufacturer: json['manufacturer'] ?? '',
        pricePerUnit: (json['pricePerUnit'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'hospitalId': hospitalId,
        'name': name,
        'category': category,
        'stock': stock,
        'unit': unit,
        'minStock': minStock,
        'expiry': expiry,
        'manufacturer': manufacturer,
        'pricePerUnit': pricePerUnit,
      };

  MedicineStockModel copyWith({
    String? id, String? hospitalId, String? name, String? category,
    int? stock, String? unit, int? minStock, String? expiry,
    String? manufacturer, double? pricePerUnit,
  }) => MedicineStockModel(
        id: id ?? this.id,
        hospitalId: hospitalId ?? this.hospitalId,
        name: name ?? this.name,
        category: category ?? this.category,
        stock: stock ?? this.stock,
        unit: unit ?? this.unit,
        minStock: minStock ?? this.minStock,
        expiry: expiry ?? this.expiry,
        manufacturer: manufacturer ?? this.manufacturer,
        pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      );
}
