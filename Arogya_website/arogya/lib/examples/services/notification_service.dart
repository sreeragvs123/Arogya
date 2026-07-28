import '../models/patient_model.dart';

/// Handles medication alarm scheduling and push notification logic.
/// On the web side this prepares the notification payload sent to the
/// patient's Arogya app via the backend. On the Flutter app side
/// (when ported) this will wire into flutter_local_notifications.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // ── Alarm schedule generation ─────────────────────────────────────────────

  /// Converts a list of [MedicationModel] into a flat list of [AlarmEntry]
  /// objects — one per dose per day — spanning the medication duration.
  List<AlarmEntry> buildAlarmSchedule(List<MedicationModel> medications) {
    final alarms = <AlarmEntry>[];
    final now = DateTime.now();

    for (final med in medications) {
      final durationDays = _parseDurationDays(med.duration);
      final timesOfDay = _timingToTimeOfDay(med.timing);

      for (int day = 0; day < durationDays; day++) {
        for (final tod in timesOfDay) {
          final scheduledTime = DateTime(
            now.year, now.month, now.day + day,
            tod.hour, tod.minute,
          );
          alarms.add(AlarmEntry(
            id: '${med.name}_${day}_${tod.label}'.hashCode.abs(),
            medicineName: med.name,
            dosage: med.dosage,
            scheduledTime: scheduledTime,
            timingLabel: tod.label,
            day: day + 1,
            totalDays: durationDays,
          ));
        }
      }
    }

    alarms.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return alarms;
  }

  /// Builds the notification payload map that gets sent to the backend,
  /// which then pushes it to the patient's device via FCM.
  Map<String, dynamic> buildNotificationPayload({
    required String patientId,
    required String receiptId,
    required List<MedicationModel> medications,
  }) {
    final schedule = buildAlarmSchedule(medications);
    return {
      'patientId': patientId,
      'receiptId': receiptId,
      'type': 'MEDICATION_SCHEDULE',
      'alarms': schedule.map((a) => a.toJson()).toList(),
      'summary': _buildSummary(medications),
      'generatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Returns a human-readable summary string for the notification banner.
  /// e.g. "3 medications scheduled — next dose at 8:00 AM"
  String buildNextDoseSummary(List<MedicationModel> medications) {
    if (medications.isEmpty) return 'No medications scheduled.';
    final alarms = buildAlarmSchedule(medications);
    final next = alarms.firstWhere(
      (a) => a.scheduledTime.isAfter(DateTime.now()),
      orElse: () => alarms.first,
    );
    final timeStr = _formatTime(next.scheduledTime);
    return '${medications.length} medication${medications.length == 1 ? '' : 's'} scheduled — next dose at $timeStr (${next.medicineName})';
  }

  // ── In-app snackbar / banner helpers ─────────────────────────────────────

  /// Returns a list of today's alarms only.
  List<AlarmEntry> getTodaysAlarms(List<MedicationModel> medications) {
    final now = DateTime.now();
    return buildAlarmSchedule(medications).where((a) =>
      a.scheduledTime.year == now.year &&
      a.scheduledTime.month == now.month &&
      a.scheduledTime.day == now.day,
    ).toList();
  }

  /// Groups alarms by timing label for display in the receipt page.
  Map<String, List<AlarmEntry>> groupByTiming(List<AlarmEntry> alarms) {
    final grouped = <String, List<AlarmEntry>>{};
    for (final alarm in alarms) {
      grouped.putIfAbsent(alarm.timingLabel, () => []).add(alarm);
    }
    return grouped;
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  int _parseDurationDays(String duration) {
    final lower = duration.toLowerCase();
    final match = RegExp(r'(\d+)').firstMatch(lower);
    if (match == null) return 7;
    final value = int.parse(match.group(1)!);
    if (lower.contains('week')) return value * 7;
    if (lower.contains('month')) return value * 30;
    return value; // default: treat number as days
  }

  List<_TimeOfDay> _timingToTimeOfDay(List<String> timing) {
    const map = {
      'Morning':   _TimeOfDay(hour: 8,  minute: 0,  label: 'Morning'),
      'Afternoon': _TimeOfDay(hour: 13, minute: 0,  label: 'Afternoon'),
      'Evening':   _TimeOfDay(hour: 18, minute: 0,  label: 'Evening'),
      'Night':     _TimeOfDay(hour: 21, minute: 0,  label: 'Night'),
    };
    return timing.map((t) => map[t] ?? const _TimeOfDay(hour: 8, minute: 0, label: 'Morning')).toList();
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Map<String, dynamic> _buildSummary(List<MedicationModel> medications) => {
    'totalMedicines': medications.length,
    'medicines': medications.map((m) => {
      'name': m.name,
      'dosage': m.dosage,
      'timing': m.timing,
      'duration': m.duration,
    }).toList(),
  };
}

// ── AlarmEntry ────────────────────────────────────────────────────────────────

class AlarmEntry {
  final int id;
  final String medicineName;
  final String dosage;
  final DateTime scheduledTime;
  final String timingLabel;
  final int day;
  final int totalDays;

  const AlarmEntry({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.scheduledTime,
    required this.timingLabel,
    required this.day,
    required this.totalDays,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicineName': medicineName,
    'dosage': dosage,
    'scheduledTime': scheduledTime.toIso8601String(),
    'timingLabel': timingLabel,
    'day': day,
    'totalDays': totalDays,
  };

  factory AlarmEntry.fromJson(Map<String, dynamic> json) => AlarmEntry(
    id: json['id'] as int,
    medicineName: json['medicineName'] as String,
    dosage: json['dosage'] as String,
    scheduledTime: DateTime.parse(json['scheduledTime'] as String),
    timingLabel: json['timingLabel'] as String,
    day: json['day'] as int,
    totalDays: json['totalDays'] as int,
  );
}

// ── Internal time helper ──────────────────────────────────────────────────────
class _TimeOfDay {
  final int hour;
  final int minute;
  final String label;
  const _TimeOfDay({required this.hour, required this.minute, required this.label});
}
