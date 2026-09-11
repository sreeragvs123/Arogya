package com.Grp._8.backend.controllers.users;

import com.Grp._8.backend.services.users.DoctorService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;


@RequiredArgsConstructor
@RequestMapping("/hospital")
@RestController
@Slf4j
public class DoctorController {

    private final DoctorService doctorService;


}
