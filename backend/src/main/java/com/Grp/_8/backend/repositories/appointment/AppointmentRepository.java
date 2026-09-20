package com.Grp._8.backend.repositories.appointment;

import com.Grp._8.backend.entities.appointment.Appointment;
import com.Grp._8.backend.entities.enums.AppointmentStatus;
import com.Grp._8.backend.entities.enums.Department;
import com.Grp._8.backend.entities.users.Patient;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    Long countByDoctorIdAndAppointmentAtGreaterThanEqualAndAppointmentAtLessThanAndStatusNot(
            Long doctorId, LocalDateTime from, LocalDateTime until, AppointmentStatus excludedStatus);

    Long countByDoctorIdAndAppointmentAtGreaterThanEqualAndAppointmentAtLessThanAndStatus(
            Long doctorId, LocalDateTime from, LocalDateTime until, AppointmentStatus status);
    List<Appointment> findByDoctorIdAndAppointmentAtGreaterThanEqualAndAppointmentAtLessThanAndStatusInOrderByAppointmentAtAsc(
            Long doctorId, LocalDateTime from, LocalDateTime until, Set<AppointmentStatus> statuses);
    Optional<Appointment> findByIdAndDoctorId(Long id, Long doctorId);

    List<Appointment> findByDoctor_IdAndStatus(Long doctorId, AppointmentStatus status);

    // Hospital's incoming-requests queue (all doctors under that hospital)
    List<Appointment> findByDoctor_Hospital_IdAndStatus(Long hospitalId, AppointmentStatus status);

    // Patient's own appointment history / status tracking
    List<Appointment> findByPatient_IdOrderByAppointmentAtDesc(Long patientId);


    // 1. All distinct patients ever seen by this doctor
    @Query("SELECT DISTINCT a.patient FROM Appointment a WHERE a.doctor.id = :doctorId")
    List<Patient> findDistinctPatientsByDoctorId(@Param("doctorId") Long doctorId);

    // 2a. Any patient with an appointment this month (returning + new)
    @Query("SELECT DISTINCT a.patient FROM Appointment a " +
            "WHERE a.doctor.id = :doctorId " +
            "AND a.appointmentAt BETWEEN :start AND :end")
    List<Patient> findPatientsWithAppointmentsInRange(
            @Param("doctorId") Long doctorId,
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end);

    // 2b. Only patients whose FIRST-EVER appointment with this doctor falls in this month
    @Query("SELECT a.patient FROM Appointment a " +
            "WHERE a.doctor.id = :doctorId " +
            "AND a.appointmentAt = (" +
            "    SELECT MIN(a2.appointmentAt) FROM Appointment a2 " +
            "    WHERE a2.patient = a.patient AND a2.doctor.id = :doctorId" +
            ") " +
            "AND a.appointmentAt BETWEEN :start AND :end")
    List<Patient> findNewPatientsInRange(
            @Param("doctorId") Long doctorId,
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end);


    // Today's appointments for this doctor
    Page<Appointment> findByDoctor_IdAndAppointmentAtBetween(
            Long doctorId, LocalDateTime start, LocalDateTime end, Pageable pageable);

    // Upcoming (after today) appointments for this doctor
    Page<Appointment> findByDoctor_IdAndAppointmentAtAfter(
            Long doctorId, LocalDateTime after, Pageable pageable);

    boolean existsByDoctorIdAndAppointmentAt(Long doctorId, LocalDateTime appointmentAt);

    Optional<Appointment> findByIdAndPatientId(Long id, Long patientId);

    @Query("SELECT a FROM Appointment a JOIN FETCH a.doctor d JOIN FETCH d.userData JOIN FETCH a.hospital WHERE a.patient.id = :patientId ORDER BY a.appointmentAt DESC")
    List<Appointment> findByPatientIdWithDetails(@Param("patientId") Long patientId);


    List<Appointment> findByDoctorIdAndStatus(Long doctorId, AppointmentStatus status);

    List<Appointment> findByHospitalIdAndDoctorDepartmentAndStatus(Long hospitalId, Department department, AppointmentStatus status);
}

