package com.verinite.employee_service.repository;


import com.verinite.employee_service.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Long> {

    Optional<Employee> findByEmployeeId(String employeeId);

    boolean existsByEmployeeId(String employeeId);

    boolean existsByEmail(String email);
}
