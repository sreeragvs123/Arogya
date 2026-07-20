package com.Grp._8.backend.repositories.users;

import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.entities.enums.Role;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<Users, Long> {

    Optional<Users> findByUsernameAndRole(String username, Role role1);
    Optional<Users> findByUsername(String username);
}
