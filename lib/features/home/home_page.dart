import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/widgets/side_menu.dart';
import '../employee/bloc/employee_bloc.dart';
import '../employee/bloc/employee_event.dart';
import '../employee/data/employee_repository.dart';
import '../employee/ui/employee_list_page.dart';
import '../task/ui/task_page.dart';
import '../settings/settings_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      const Center(
        child: Text(
          'Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      BlocProvider(
        create: (_) => EmployeeBloc(EmployeeRepository())
          ..add(WatchEmployeesRequested()),
        child: const EmployeeListPage(),
      ),

      const TaskPage(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideMenu(
            selectedIndex: selectedIndex,
            parentContext: context,
            onItemSelected: (index) {
              setState(() => selectedIndex = index);
            },
          ),

          Expanded(
            child: pages[selectedIndex],
          ),
        ],
      ),
    );
  }
}
