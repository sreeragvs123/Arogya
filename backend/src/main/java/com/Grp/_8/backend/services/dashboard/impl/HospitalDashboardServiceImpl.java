package com.Grp._8.backend.services.dashboard.impl;


import com.Grp._8.backend.dto.dashboard.hosptial.HospitalDashBoardDoctorSearchResponseDto;
import com.Grp._8.backend.dto.dashboard.hosptial.HospitalDashboardMetricsDto;
import com.Grp._8.backend.entities.enums.DoctorStaffSection;
import com.Grp._8.backend.entities.enums.DoctorStatus;
import com.Grp._8.backend.entities.enums.VerificationStatus;
import com.Grp._8.backend.entities.users.Doctor;
import com.Grp._8.backend.entities.users.Hospital;
import com.Grp._8.backend.exceptions.HospitalNotFoundException;
import com.Grp._8.backend.repositories.users.DoctorRepository;
import com.Grp._8.backend.repositories.users.HospitalRepository;
import com.Grp._8.backend.services.dashboard.HospitalDashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
public class HospitalDashboardServiceImpl implements HospitalDashboardService {

    private final HospitalRepository hospitalRepository;
    private final DoctorRepository doctorRepository;



    public HospitalDashboardMetricsDto getMetrics(Long Id) {

        Hospital hospital = hospitalRepository.findById(Id)
                .orElseThrow(() -> new HospitalNotFoundException("Hospital not found"));

        Long hospitalId = hospital.getId();

        Long totalStaff = doctorRepository.countByHospital_Id(hospitalId);
        Long activeOnDuty = doctorRepository.countByHospital_IdAndStatus(hospitalId, DoctorStatus.ACTIVE);
        Long pendingReviews = doctorRepository.countByHospital_IdAndVerificationStatus(hospitalId, VerificationStatus.PENDING);
        Long specialtyCount = doctorRepository.countDistinctSpecializationsByHospitalId(hospitalId);

        return HospitalDashboardMetricsDto.builder()
                .totalStaff(totalStaff)
                .activeOnDuty(activeOnDuty)
                .pendingReviews(pendingReviews)
                .specialtyCount(specialtyCount)
                .build();
    }




    @Override
    public Page<HospitalDashBoardDoctorSearchResponseDto> getDoctorsBySection(
            Long hospitalId,
            DoctorStaffSection section,
            int page,
            int size
    ) {
        Pageable pageable = createPageable(page, size);

        return doctorRepository.findByHospital_IdAndStatusIn(
                hospitalId,
                getStatusesForSection(section),
                pageable
        ).map(this::mapToResponse);
    }

    @Override
    public List<String> getSpecializations(Long hospitalId) {
        return doctorRepository.findDistinctSpecializationsByHospitalId(hospitalId);
    }

    @Override
    public Page<HospitalDashBoardDoctorSearchResponseDto> searchDoctorsByQuery(
            Long hospitalId,
            DoctorStaffSection section,
            String query,
            int page,
            int size
    ) {
        Pageable pageable = createPageable(page, size);

        Page<Doctor> result =  doctorRepository.searchDoctorsInSection(
                hospitalId,
                getStatusesForSection(section),
                query.trim(),
                pageable
        );

        return result.map(doctor -> mapToResponse(doctor));
    }

    @Override
    public Page<HospitalDashBoardDoctorSearchResponseDto> filterDoctorsBySpecialization(
            Long hospitalId,
            DoctorStaffSection section,
            String specialization,
            int page,
            int size
    ) {
        Pageable pageable = createPageable(page, size);

        return doctorRepository
                .findByHospital_IdAndStatusInAndSpecializationIgnoreCase(
                        hospitalId,
                        getStatusesForSection(section),
                        specialization.trim(),
                        pageable
                )
                .map(this::mapToResponse);
    }

    private List<DoctorStatus> getStatusesForSection(DoctorStaffSection section) {
        return switch (section) {
            case ALL_STAFF -> Arrays.asList(DoctorStatus.values());

            case ACTIVE_DUTY -> List.of(
                    DoctorStatus.ACTIVE,
                    DoctorStatus.IN_OPD
            );

            case ON_CALL -> List.of(DoctorStatus.ON_CALL);

            case PROVISIONING -> List.of(
                    DoctorStatus.PENDING_FIRST_LOGIN
            );
        };
    }

    private Pageable createPageable(int page, int size) {
        return PageRequest.of(
                Math.max(page, 0),
                Math.min(Math.max(size, 1), 100),
                Sort.by(Sort.Direction.DESC, "createdAt")
        );
    }

    private HospitalDashBoardDoctorSearchResponseDto mapToResponse(Doctor doctor) {
        return new HospitalDashBoardDoctorSearchResponseDto(
                doctor.getId(),
                doctor.getUserData().getName(),
                doctor.getUserData().getProfileImageUrl(),
                doctor.getDesignation(),
                doctor.getSpecialization(),
                doctor.getLicenseNumber(),
                doctor.getVerificationStatus(),
                doctor.getHospital().getId(),
                doctor.getHospital().getUserData().getName(),
                doctor.getSpecialization(),
                doctor.getStatus(),
                doctor.getUserData().getEmail(),
                doctor.getPhoneNumber(),
                doctor.getPrescriptionAuthority(),
                doctor.getLabImagingOrdering(),
                doctor.getDischargeSignoffAuthority()
        );
    }
}