class Employee {
  const Employee({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.email,
    this.lastName,
    this.phone,
    this.departmentId,
    this.designationId,
    this.managerId,
    this.clientId,
    this.locationId,
    this.joiningDate,
    this.status = 'ACTIVE',
  });

  final int id;
  final String employeeId;
  final String firstName;
  final String? lastName;
  final String email;
  final String? phone;
  final String? departmentId;
  final String? designationId;
  final String? managerId;
  final String? clientId;
  final String? locationId;
  final DateTime? joiningDate;
  final String status;

  String get fullName => [firstName, lastName].whereType<String>()
      .where((part) => part.trim().isNotEmpty).join(' ');

  factory Employee.fromJson(Map<String, dynamic> json) {
    final joiningDateValue = json['joiningDate'];
    return Employee(
      id: _requiredInt(json['id'], 'id'),
      employeeId: json['employeeId']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString(),
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      departmentId: json['departmentId']?.toString(),
      designationId: json['designationId']?.toString(),
      managerId: json['managerId']?.toString(),
      clientId: json['clientId']?.toString(),
      locationId: json['locationId']?.toString(),
      joiningDate: joiningDateValue == null
          ? null
          : DateTime.tryParse(joiningDateValue.toString()),
      status: json['status']?.toString() ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toRequestJson() => {
    'employeeId': employeeId,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'departmentId': departmentId,
    'designationId': designationId,
    'managerId': managerId,
    'clientId': clientId,
    'locationId': locationId,
    'joiningDate': joiningDate == null
        ? null
        : '${joiningDate!.year.toString().padLeft(4, '0')}-'
            '${joiningDate!.month.toString().padLeft(2, '0')}-'
            '${joiningDate!.day.toString().padLeft(2, '0')}',
  };
}

int _requiredInt(dynamic value, String field) {
  final parsed = _optionalInt(value);
  if (parsed == null) throw FormatException('Employee response is missing $field.');
  return parsed;
}

int? _optionalInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}