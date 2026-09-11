package com.Grp._8.backend.repositories.users;

import com.Grp._8.backend.entities.users.Users;
import com.Grp._8.backend.entities.enums.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<Users, Long> {

    Optional<Users> findByUsernameAndRole(String username, Role role);
    Optional<Users> findByUsername(String username);
    boolean existsByEmail(String email);
    boolean existsByUsername(String username);

}
