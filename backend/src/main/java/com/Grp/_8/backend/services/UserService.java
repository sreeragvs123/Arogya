package com.Grp._8.backend.services;

import com.Grp._8.backend.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class UserService  {

    private final UserRepository userRepository;
    private final ModelMapper modelMapper;




}
