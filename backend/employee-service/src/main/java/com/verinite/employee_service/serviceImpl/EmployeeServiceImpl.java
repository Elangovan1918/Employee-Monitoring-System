package com.verinite.employee_service.serviceImpl;

import com.verinite.employee_service.dto.EmployeeRequest;
import com.verinite.employee_service.dto.EmployeeResponse;
import com.verinite.employee_service.entity.Employee;
import com.verinite.employee_service.repository.EmployeeRepository;
import com.verinite.employee_service.service.EmployeeService;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class EmployeeServiceImpl implements EmployeeService {


    private final EmployeeRepository employeeRepository;

    public EmployeeServiceImpl(EmployeeRepository employeeRepository) {
        this.employeeRepository = employeeRepository;
    }

    @Override
    public EmployeeResponse createEmployee(EmployeeRequest request) {

        Employee employee = Employee.builder()
                .employeeId(request.getEmployeeId())
                .userId(request.getUserId())
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .email(request.getEmail())
                .phone(request.getPhone())
                .departmentId(request.getDepartmentId())
                .designationId(request.getDesignationId())
                .managerId(request.getManagerId())
                .clientId(request.getClientId())
                .locationId(request.getLocationId())
                .joiningDate(request.getJoiningDate())
                .status("ACTIVE")
                .build();

        Employee savedEmployee = employeeRepository.save(employee);

        return mapToResponse(savedEmployee);
    }

    @Override
    public EmployeeResponse getEmployee(Long id) {

        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Employee not found: " + id));

        return mapToResponse(employee);
    }

    @Override
    public List<EmployeeResponse> getAllEmployees() {

        return employeeRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    @Override
    public EmployeeResponse updateEmployee(
            Long id,
            EmployeeRequest request) {

        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Employee not found: " + id));

        employee.setEmployeeId(request.getEmployeeId());
        employee.setUserId(request.getUserId());
        employee.setFirstName(request.getFirstName());
        employee.setLastName(request.getLastName());
        employee.setEmail(request.getEmail());
        employee.setPhone(request.getPhone());
        employee.setDepartmentId(request.getDepartmentId());
        employee.setDesignationId(request.getDesignationId());
        employee.setManagerId(request.getManagerId());
        employee.setClientId(request.getClientId());
        employee.setLocationId(request.getLocationId());
        employee.setJoiningDate(request.getJoiningDate());

        return mapToResponse(employeeRepository.save(employee));
    }

    @Override
    public void deleteEmployee(Long id) {

        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Employee not found: " + id));

        // Soft delete
        employee.setStatus("INACTIVE");

        employeeRepository.save(employee);
    }

    private EmployeeResponse mapToResponse(Employee employee) {

        return EmployeeResponse.builder()
                .id(employee.getId())
                .employeeId(employee.getEmployeeId())
                .userId(employee.getUserId())
                .firstName(employee.getFirstName())
                .lastName(employee.getLastName())
                .email(employee.getEmail())
                .phone(employee.getPhone())
                .departmentId(employee.getDepartmentId())
                .designationId(employee.getDesignationId())
                .managerId(employee.getManagerId())
                .clientId(employee.getClientId())
                .locationId(employee.getLocationId())
                .joiningDate(employee.getJoiningDate())
                .status(employee.getStatus())
                .build();
    }

}
