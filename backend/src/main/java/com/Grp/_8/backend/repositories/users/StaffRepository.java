package com.Grp._8.backend.repositories.users;

import com.Grp._8.backend.entities.users.Staff;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface StaffRepository extends JpaRepository<Staff, Long> {
    Optional<Staff> findByUserData_Id(Long userId);

    Optional<Long> findIdByUserData_Username(String username);
}
