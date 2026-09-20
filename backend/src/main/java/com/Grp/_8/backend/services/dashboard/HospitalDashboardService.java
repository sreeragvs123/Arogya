package com.Grp._8.backend.services.dashboard;

import com.Grp._8.backend.dto.dashboard.hosptial.DoctorDetailResponseDto;
import com.Grp._8.backend.dto.dashboard.hosptial.HospitalDashBoardDoctorSearchResponseDto;
import com.Grp._8.backend.dto.dashboard.hosptial.HospitalDashboardMetricsDto;
import com.Grp._8.backend.entities.enums.DoctorStaffSection;
import org.springframework.data.domain.Page;

import java.util.List;

public interface HospitalDashboardService {

    Page<HospitalDashBoardDoctorSearchResponseDto> getDoctorsBySection(
            Long hospitalId,
            DoctorStaffSection section,
            int page,
            int size
    );

    Page<HospitalDashBoardDoctorSearchResponseDto> searchDoctorsByQuery(
            Long hospitalId,
            DoctorStaffSection section,
            String query,
            int page,
            int size
    );

    HospitalDashboardMetricsDto getMetrics(Long Id);

    List<String> getSpecializations(Long hospitalId);

    Page<HospitalDashBoardDoctorSearchResponseDto> filterDoctorsBySpecialization(
            Long hospitalId,
            DoctorStaffSection section,
            String specialization,
            int page,
            int size
    );

    DoctorDetailResponseDto getDoctorDetail(Long hospitalId, Long doctorId);
}