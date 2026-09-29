import 'package:flutter/material.dart';

import '../models/employee.dart';

const _ink = Color(0xff183b3d);
const _muted = Color(0xff61787a);
const _line = Color(0xffdce7e6);
const _canvas = Color(0xfff3f8f7);
const _teal = Color(0xff176b68);

class WorkspaceNavigation extends StatelessWidget {
  const WorkspaceNavigation({
    super.key,
    required this.activeSection,
    required this.onSelect,
  });

  final String activeSection;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: _ink,
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 18, 30),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xff8ed8c7),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(Icons.query_stats_rounded, color: _ink),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Text(
                    'VERINITE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 16, 10),
            child: Text(
              'WORKSPACE',
              style: TextStyle(
                color: Color(0xff9ab4b1),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ),
          _NavigationItem(
            label: 'Dashboard',
            icon: Icons.grid_view_rounded,
            selected: activeSection == 'Dashboard',
            onTap: () => onSelect('Dashboard'),
          ),
          _NavigationItem(
            label: 'Employees',
            icon: Icons.groups_2_outlined,
            selected: activeSection == 'Employees',
            onTap: () => onSelect('Employees'),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xff264b4b),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xff426665)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_outlined, color: Color(0xff8ed8c7), size: 19),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Employee workspace',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    child: ListTile(
      onTap: onTap,
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      selected: selected,
      selectedTileColor: const Color(0xff8ed8c7),
      iconColor: selected ? _ink : const Color(0xffb5cbc8),
      textColor: selected ? _ink : const Color(0xffe5efed),
      leading: Icon(icon, size: 20),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
  );
}

class EmployeeDashboardPage extends StatelessWidget {
  const EmployeeDashboardPage({
    super.key,
    required this.employees,
    required this.loading,
    required this.error,
    required this.onRetry,
    required this.onOpenEmployees,
    required this.onSelectEmployee,
  });

  final List<Employee> employees;
  final bool loading;
  final String? error;
  final VoidCallback onRetry;
  final VoidCallback onOpenEmployees;
  final ValueChanged<Employee> onSelectEmployee;

  @override
  Widget build(BuildContext context) {
    final active = employees.where((item) => item.status.toUpperCase() == 'ACTIVE').length;
    final inactive = employees.length - active;
    final since = DateTime.now().subtract(const Duration(days: 30));
    final joinedRecently = employees
        .where((item) => item.joiningDate != null && item.joiningDate!.isAfter(since))
        .length;
    final recent = [...employees]
      ..sort((a, b) => (b.joiningDate ?? DateTime(1900))
          .compareTo(a.joiningDate ?? DateTime(1900)));
    final width = MediaQuery.sizeOf(context).width;

    return ColoredBox(
      color: _canvas,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(width < 600 ? 18 : 34, 26, width < 600 ? 18 : 34, 36),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Overview', style: TextStyle(color: _muted, fontSize: 13)),
                          SizedBox(height: 5),
                          Text(
                            'People at a glance',
                            style: TextStyle(
                              color: _ink,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Refresh dashboard',
                      onPressed: loading ? null : onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  padding: EdgeInsets.all(width < 600 ? 20 : 27),
                  decoration: BoxDecoration(
                    color: const Color(0xffd8eee8),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: const Color(0xffc2e2d9)),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 18,
                    spacing: 20,
                    children: [
                      SizedBox(
                        width: width < 600 ? width - 80 : 500,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your people, in one place.',
                              style: TextStyle(
                                color: _ink,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Review your workforce and keep employee records up to date.',
                              style: TextStyle(color: Color(0xff446766), height: 1.45),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: onOpenEmployees,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text('View employees'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _ink,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(170, 46),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (loading && employees.isEmpty)
                  const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()))
                else if (error != null && employees.isEmpty)
                  _WorkspaceError(message: error!, onRetry: onRetry)
                else ...[
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final count = constraints.maxWidth >= 900
                          ? 4
                          : constraints.maxWidth >= 570
                          ? 2
                          : 1;
                      final gap = 12.0;
                      final cardWidth = (constraints.maxWidth - gap * (count - 1)) / count;
                      return Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: [
                          _MetricTile(
                            width: cardWidth,
                            label: 'Total employees',
                            value: '${employees.length}',
                            icon: Icons.groups_2_outlined,
                            color: const Color(0xffdcecf2),
                          ),
                          _MetricTile(
                            width: cardWidth,
                            label: 'Active',
                            value: '$active',
                            icon: Icons.check_circle_outline_rounded,
                            color: const Color(0xffdff1e7),
                          ),
                          _MetricTile(
                            width: cardWidth,
                            label: 'Inactive',
                            value: '$inactive',
                            icon: Icons.pause_circle_outline_rounded,
                            color: const Color(0xfff3e8dc),
                          ),
                          _MetricTile(
                            width: cardWidth,
                            label: 'Joined this month',
                            value: '$joinedRecently',
                            icon: Icons.event_available_outlined,
                            color: const Color(0xffeee7d7),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Employee records',
                          style: TextStyle(color: _ink, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: onOpenEmployees,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                        label: const Text('All employees'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (recent.isEmpty)
                    const _WorkspaceEmpty(
                      icon: Icons.people_outline_rounded,
                      title: 'No employee records yet',
                      subtitle: 'Add employee records to see them here.',
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _line),
                      ),
                      child: Column(
                        children: [
                          for (final employee in recent.take(5).toList().asMap().entries) ...[
                            _EmployeeRow(
                              employee: employee.value,
                              onTap: () => onSelectEmployee(employee.value),
                            ),
                            if (employee.key < recent.take(5).length - 1)
                              const Divider(height: 1, indent: 18, endIndent: 18),
                          ],
                        ],
                      ),
                    ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Text('Could not refresh: $error', style: const TextStyle(color: Colors.red)),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmployeeDirectoryPage extends StatelessWidget {
  const EmployeeDirectoryPage({
    super.key,
    required this.employees,
    required this.totalCount,
    required this.activeCount,
    required this.searchController,
    required this.statusFilter,
    required this.loading,
    required this.error,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onRetry,
    required this.onRefresh,
    required this.onAdd,
    required this.onSelectEmployee,
  });

  final List<Employee> employees;
  final int totalCount;
  final int activeCount;
  final TextEditingController searchController;
  final String statusFilter;
  final bool loading;
  final String? error;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final VoidCallback onAdd;
  final ValueChanged<Employee> onSelectEmployee;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return ColoredBox(
      color: _canvas,
      child: Padding(
        padding: EdgeInsets.fromLTRB(width < 600 ? 18 : 34, 26, width < 600 ? 18 : 34, 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Directory',
                            style: TextStyle(color: _muted, fontSize: 13),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Employees',
                            style: TextStyle(color: _ink, fontSize: 28, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text('$totalCount total · $activeCount active', style: const TextStyle(color: _muted)),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Refresh employees',
                      onPressed: loading ? null : onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search name, ID, email, or phone',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: searchController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            onPressed: () {
                              searchController.clear();
                              onSearchChanged('');
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: 'ALL', label: Text('All')),
                      ButtonSegment(value: 'ACTIVE', label: Text('Active')),
                      ButtonSegment(value: 'INACTIVE', label: Text('Inactive')),
                    ],
                    selected: {statusFilter},
                    onSelectionChanged: (selection) => onStatusChanged(selection.first),
                  ),
                ),
                const SizedBox(height: 13),
                const Divider(height: 1),
                Expanded(
                  child: loading && totalCount == 0
                      ? const Center(child: CircularProgressIndicator())
                      : error != null && totalCount == 0
                      ? _WorkspaceError(message: error!, onRetry: onRetry)
                      : employees.isEmpty
                      ? _WorkspaceEmpty(
                          icon: totalCount == 0 ? Icons.people_outline_rounded : Icons.search_off_rounded,
                          title: totalCount == 0 ? 'No employee records yet' : 'No matching employees',
                          subtitle: totalCount == 0 ? 'Create the first employee record.' : 'Try another search or status filter.',
                          action: totalCount == 0 ? onAdd : null,
                        )
                      : RefreshIndicator(
                          onRefresh: onRefresh,
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: employees.length,
                            separatorBuilder: (_, _) => const Divider(height: 1),
                            itemBuilder: (context, index) => _EmployeeRow(
                              employee: employees[index],
                              onTap: () => onSelectEmployee(employees[index]),
                            ),
                          ),
                        ),
                ),
                if (error != null && totalCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Could not refresh: $error', style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmployeeProfilePage extends StatelessWidget {
  const EmployeeProfilePage({
    super.key,
    required this.employee,
    required this.onBack,
    required this.onEdit,
    required this.onDeactivate,
  });

  final Employee employee;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onDeactivate;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final inactive = employee.status.toUpperCase() == 'INACTIVE';
    final details = [
      _ProfileField('Employee ID', employee.employeeId, Icons.badge_outlined),
      _ProfileField('Email address', employee.email, Icons.mail_outline_rounded),
      _ProfileField('Phone', _orDash(employee.phone), Icons.phone_outlined),
      _ProfileField('Department ID', _orDash(employee.departmentId), Icons.account_tree_outlined),
      _ProfileField('Designation ID', _orDash(employee.designationId), Icons.work_outline_rounded),
      _ProfileField('Manager ID', _orDash(employee.managerId), Icons.supervisor_account_outlined),
      _ProfileField('Client ID', _orDash(employee.clientId), Icons.business_outlined),
      _ProfileField('Location ID', _orDash(employee.locationId), Icons.location_on_outlined),
      _ProfileField('Joining date', _date(employee.joiningDate), Icons.event_outlined),
    ];

    return ColoredBox(
      color: _canvas,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(width < 600 ? 18 : 34, 22, width < 600 ? 18 : 34, 36),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton.icon(
                  onPressed: onBack,
                  style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back to employees'),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: EdgeInsets.all(width < 600 ? 20 : 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: _line),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    runSpacing: 18,
                    children: [
                      SizedBox(
                        width: width < 600 ? width - 80 : 550,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 34,
                              backgroundColor: const Color(0xffd7eee9),
                              foregroundColor: _ink,
                              child: Text(
                                _initials(employee.fullName),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 17),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    employee.fullName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: _ink, fontSize: 25, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(employee.email, style: const TextStyle(color: _muted)),
                                  const SizedBox(height: 10),
                                  _StatusPill(status: employee.status),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit profile'),
                          ),
                          if (!inactive)
                            OutlinedButton.icon(
                              onPressed: onDeactivate,
                              icon: const Icon(Icons.person_off_outlined, size: 18),
                              label: const Text('Deactivate'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Employee information',
                  style: TextStyle(color: _ink, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final count = constraints.maxWidth >= 760 ? 2 : 1;
                    const gap = 12.0;
                    final tileWidth = (constraints.maxWidth - gap * (count - 1)) / count;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (final field in details)
                          _InformationTile(width: tileWidth, field: field),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.width,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final double width;
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    constraints: const BoxConstraints(minHeight: 116),
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(color: _ink, fontSize: 26, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
          child: Icon(icon, color: _ink, size: 21),
        ),
      ],
    ),
  );
}

class _EmployeeRow extends StatelessWidget {
  const _EmployeeRow({required this.employee, required this.onTap});

  final Employee employee;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: CircleAvatar(
      backgroundColor: const Color(0xffd7eee9),
      foregroundColor: _ink,
      child: Text(_initials(employee.fullName)),
    ),
    title: Text(
      employee.fullName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: _ink, fontWeight: FontWeight.w600),
    ),
    subtitle: Text(
      '${employee.employeeId}  ·  ${employee.email}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        _StatusPill(status: employee.status),
        const Icon(Icons.chevron_right_rounded, color: _muted),
      ],
    ),
  );
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final active = status.toUpperCase() == 'ACTIVE';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: active ? const Color(0xffe2f2e9) : const Color(0xfff3e8dc),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: active ? const Color(0xff286344) : const Color(0xff77543d),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProfileField {
  const _ProfileField(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}

class _InformationTile extends StatelessWidget {
  const _InformationTile({required this.width, required this.field});

  final double width;
  final _ProfileField field;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    constraints: const BoxConstraints(minHeight: 88),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: _line),
    ),
    child: Row(
      children: [
        Icon(field.icon, color: _teal, size: 20),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(field.label, style: const TextStyle(color: _muted, fontSize: 12)),
              const SizedBox(height: 5),
              Text(
                field.value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _ink, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _WorkspaceError extends StatelessWidget {
  const _WorkspaceError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_outlined, size: 42, color: _muted),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try again'),
          ),
        ],
      ),
    ),
  );
}

class _WorkspaceEmpty extends StatelessWidget {
  const _WorkspaceEmpty({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 42, color: _muted),
          const SizedBox(height: 11),
          Text(title, style: const TextStyle(color: _ink, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: _muted)),
          if (action != null) ...[
            const SizedBox(height: 13),
            OutlinedButton.icon(
              onPressed: action,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Add employee'),
            ),
          ],
        ],
      ),
    ),
  );
}

String _orDash(String? value) => value == null || value.trim().isEmpty ? 'Not provided' : value;

String _date(DateTime? value) => value == null
    ? 'Not provided'
    : '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty);
  return parts.take(2).map((part) => part[0].toUpperCase()).join();
}
