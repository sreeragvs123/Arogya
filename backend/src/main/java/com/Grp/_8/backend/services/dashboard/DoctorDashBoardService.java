package com.Grp._8.backend.services.dashboard;

import com.Grp._8.backend.dto.dashboard.doctor.DoctorDashboardSummaryDto;
import com.Grp._8.backend.entities.users.Doctor;

public interface DoctorDashBoardService {

    DoctorDashboardSummaryDto getSummary(Doctor doctor);

}