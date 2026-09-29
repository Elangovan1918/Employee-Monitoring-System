import 'package:flutter/material.dart';

import '../../employees/data/employee_repository.dart';
import '../../employees/models/employee.dart';
import '../../employees/presentation/employee_workspace_pages.dart';
import '../data/auth_repository.dart';
import '../models/login_session.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.session});

  final LoginSession session;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repository = EmployeeRepository();
  final _searchController = TextEditingController();
  List<Employee> _employees = [];
  bool _loading = true;
  String? _loadError;
  String _statusFilter = 'ALL';
  String _activeSection = 'Dashboard';
  bool _sidebarVisible = false;
  Employee? _selectedEmployee;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _repository.dispose();
    super.dispose();
  }

  Future<void> _loadEmployees() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final employees = await _repository.getEmployees();
      if (!mounted) return;
      setState(() => _employees = employees);
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadError = _message(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Employee> get _visibleEmployees {
    final query = _searchController.text.trim().toLowerCase();
    return _employees.where((employee) {
      final matchesStatus = _statusFilter == 'ALL' ||
          employee.status.toUpperCase() == _statusFilter;
      final matchesQuery = query.isEmpty ||
          [
            employee.fullName,
            employee.employeeId,
            employee.email,
            employee.phone ?? '',
          ].any((value) => value.toLowerCase().contains(query));
      return matchesStatus && matchesQuery;
    }).toList();
  }

  Future<void> _showEmployeeForm({Employee? employee}) async {
    final draft = await showDialog<Employee>(
      context: context,
      builder: (_) => EmployeeFormDialog(employee: employee),
    );
    if (draft == null || !mounted) return;
    try {
      if (employee == null) {
        await _repository.createEmployee(draft);
      } else {
        await _repository.updateEmployee(draft);
      }
      if (!mounted) return;
      _showMessage(employee == null ? 'Employee created.' : 'Employee updated.');
      await _loadEmployees();
      if (employee != null && mounted) {
        final updatedEmployees = _employees
            .where((item) => item.id == employee.id)
            .toList();
        if (updatedEmployees.isNotEmpty) {
          setState(() => _selectedEmployee = updatedEmployees.first);
        }
      }
    } catch (error) {
      if (mounted) _showMessage(_message(error));
    }
  }

  void _selectEmployee(Employee employee) {
    setState(() => _selectedEmployee = employee);
  }

  void _openSection(String section) {
    setState(() {
      _activeSection = section;
      _selectedEmployee = null;
    });
    Navigator.of(context).maybePop();
  }

  Future<void> _deactivateEmployee(Employee employee) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Deactivate employee?'),
        content: Text('${employee.fullName} will be marked inactive.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _repository.deleteEmployee(employee.id);
      if (!mounted) return;
      _showMessage('Employee deactivated.');
      await _loadEmployees();
    } catch (error) {
      if (mounted) _showMessage(_message(error));
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signOut() async {
    await AuthRepository().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 850;
    final selectedEmployee = _selectedEmployee;

    return Scaffold(
      drawer: wide
          ? null
          : Drawer(
              child: WorkspaceNavigation(
                activeSection: _activeSection,
                onSelect: _openSection,
              ),
            ),
      appBar: AppBar(
        leading: wide
            ? IconButton(
                tooltip: _sidebarVisible ? 'Hide navigation' : 'Show navigation',
                onPressed: () => setState(() => _sidebarVisible = !_sidebarVisible),
                icon: const Icon(Icons.menu_rounded),
              )
            : null,
        title: const Text(
          'Employee Monitoring System',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh employees',
            onPressed: _loading ? null : _loadEmployees,
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: _signOut,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            if (wide && _sidebarVisible)
              SizedBox(
                width: 238,
                child: WorkspaceNavigation(
                  activeSection: _activeSection,
                  onSelect: _openSection,
                ),
              ),
            Expanded(
              child: selectedEmployee != null
                  ? EmployeeProfilePage(
                      employee: selectedEmployee,
                      onBack: () => setState(() => _selectedEmployee = null),
                      onEdit: () => _showEmployeeForm(employee: selectedEmployee),
                      onDeactivate: () => _deactivateEmployee(selectedEmployee),
                    )
                  : _activeSection == 'Dashboard'
                  ? EmployeeDashboardPage(
                      employees: _employees,
                      loading: _loading,
                      error: _loadError,
                      onRetry: _loadEmployees,
                      onOpenEmployees: () => _openSection('Employees'),
                      onSelectEmployee: _selectEmployee,
                    )
                  : EmployeeDirectoryPage(
                      employees: _visibleEmployees,
                      totalCount: _employees.length,
                      activeCount: _employees
                          .where((employee) => employee.status.toUpperCase() == 'ACTIVE')
                          .length,
                      searchController: _searchController,
                      statusFilter: _statusFilter,
                      loading: _loading,
                      error: _loadError,
                      onSearchChanged: (_) => setState(() {}),
                      onStatusChanged: (status) => setState(() => _statusFilter = status),
                      onRetry: _loadEmployees,
                      onRefresh: _loadEmployees,
                      onAdd: () => _showEmployeeForm(),
                      onSelectEmployee: _selectEmployee,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: selectedEmployee == null && _activeSection == 'Employees'
          ? FloatingActionButton.extended(
              onPressed: () => _showEmployeeForm(),
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Add employee'),
            )
          : null,
    );
  }
}

class EmployeeFormDialog extends StatefulWidget {
  const EmployeeFormDialog({super.key, this.employee});

  final Employee? employee;

  @override
  State<EmployeeFormDialog> createState() => _EmployeeFormDialogState();
}

class _EmployeeFormDialogState extends State<EmployeeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _fields;
  DateTime? _joiningDate;

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;
    _joiningDate = employee?.joiningDate;
    _fields = {
      'Employee ID': TextEditingController(text: employee?.employeeId ?? ''),
      'First name': TextEditingController(text: employee?.firstName ?? ''),
      'Last name': TextEditingController(text: employee?.lastName ?? ''),
      'Email': TextEditingController(text: employee?.email ?? ''),
      'Phone': TextEditingController(text: employee?.phone ?? ''),
      'Department ID': TextEditingController(text: employee?.departmentId?.toString() ?? ''),
      'Designation ID': TextEditingController(text: employee?.designationId?.toString() ?? ''),
      'Manager ID': TextEditingController(text: employee?.managerId?.toString() ?? ''),
      'Client ID': TextEditingController(text: employee?.clientId?.toString() ?? ''),
      'Location ID': TextEditingController(text: employee?.locationId?.toString() ?? ''),
    };
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;

  String? _email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())
        ? null
        : 'Enter a valid email address';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _joiningDate ?? now,
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year + 1),
    );
    if (selected != null) setState(() => _joiningDate = selected);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final employee = widget.employee;
    String value(String label) => _fields[label]!.text.trim();
    String? optionalId(String label) =>
      value(label).isEmpty ? null : value(label);
    Navigator.pop(
      context,
      Employee(
        id: employee?.id ?? 0,
        employeeId: value('Employee ID'),
        firstName: value('First name'),
        lastName: value('Last name').isEmpty ? null : value('Last name'),
        email: value('Email'),
        phone: value('Phone').isEmpty ? null : value('Phone'),
        departmentId: optionalId('Department ID'),
        designationId: optionalId('Designation ID'),
        managerId: optionalId('Manager ID'),
        clientId: optionalId('Client ID'),
        locationId: optionalId('Location ID'),
        joiningDate: _joiningDate,
        status: employee?.status ?? 'ACTIVE',
      ),
    );
  }

  Widget _textField(
    String label, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) => TextFormField(
    controller: _fields[label],
    decoration: InputDecoration(labelText: label),
    validator: validator,
    keyboardType: keyboardType,
    textCapitalization: label == 'Email'
        ? TextCapitalization.none
        : TextCapitalization.words,
  );

  @override
  Widget build(BuildContext context) {
    final dialogWidth = (MediaQuery.sizeOf(context).width - 48).clamp(280.0, 520.0);
    return AlertDialog(
      title: Text(widget.employee == null ? 'Add employee' : 'Edit employee'),
      content: SizedBox(
        width: dialogWidth,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _textField('Employee ID', validator: _required),
                const SizedBox(height: 12),
                _textField('First name', validator: _required),
                const SizedBox(height: 12),
                _textField('Last name'),
                const SizedBox(height: 12),
                _textField('Email', validator: _email, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 12),
                _textField('Phone', keyboardType: TextInputType.phone),
                for (final field in [
                  'Department ID',
                  'Designation ID',
                  'Manager ID',
                  'Client ID',
                  'Location ID',
                ]) ...[
                  const SizedBox(height: 12),
                  _textField(field),
                ],
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Joining date'),
                  subtitle: Text(_date(_joiningDate)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_joiningDate != null)
                        IconButton(
                          tooltip: 'Clear joining date',
                          onPressed: () => setState(() => _joiningDate = null),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      IconButton(
                        tooltip: 'Choose joining date',
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_month_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.employee == null ? 'Create' : 'Save changes'),
        ),
      ],
    );
  }
}

String _message(Object error) => error.toString().replaceFirst('Exception: ', '');

String _date(DateTime? value) => value == null
    ? 'Not set'
    : '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';

