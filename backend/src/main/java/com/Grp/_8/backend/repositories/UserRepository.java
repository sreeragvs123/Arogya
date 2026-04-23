package com.Grp._8.backend.repositories;

import com.Grp._8.backend.entities.User;
import com.Grp._8.backend.entities.enums.Role;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByUsernameAndRole(String username, Role role1);
    Optional<User> findByUsername(String username);
}
