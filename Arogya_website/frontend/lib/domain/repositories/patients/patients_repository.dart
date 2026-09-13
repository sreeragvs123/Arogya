import 'package:dartz/dartz.dart';
import 'package:frontend/common/paginated_result.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';

abstract class PatientsRepository {
  Future<Either<Failure, PatientsDirectorySummaryEntity>> getDirectorySummary();

  /// The patient currently in an active session with this doctor, if any.
  Future<Either<Failure, PatientSummaryEntity?>> getActivePatient();

  Future<Either<Failure, PaginatedResult<PatientSummaryEntity>>> getPatients({
    required String query,
    required String sortBy, // e.g. 'last_visited'
    required String condition, // e.g. 'All Conditions'
    required int page,
    required int size,
  });

  /// Resolves a patient by their scanned QR value or manually entered
  /// Patient Identifier (e.g. "AR-9920-X").
  Future<Either<Failure, PatientSummaryEntity>> lookupPatient({
    required String identifier,
  });
}
