package com.verinite.employee_service.service;

import com.verinite.employee_service.dto.EmployeeRequest;
import com.verinite.employee_service.dto.EmployeeResponse;
import jakarta.validation.Valid;

import java.util.List;

public interface EmployeeService {

        EmployeeResponse createEmployee(@Valid EmployeeRequest request);

        EmployeeResponse getEmployee(Long id);

        List<EmployeeResponse> getAllEmployees();

        EmployeeResponse updateEmployee(Long id, EmployeeRequest request);

        void deleteEmployee(Long id);
}
