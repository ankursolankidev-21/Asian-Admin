import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'bloc/auth/auth_event.dart';
import 'features/employee/bloc/employee_bloc.dart';
import 'features/employee/data/employee_repository.dart';
import 'features/task/data/task_repository.dart';
import 'firebase_options.dart';

import 'bloc/theme/theme_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'features/auth/data/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => TaskRepository()),
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<EmployeeRepository>(create: (_) => EmployeeRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()),
          BlocProvider(create: (context) => AuthBloc(context.read<AuthRepository>())..add(AppStarted())),
          BlocProvider(create: (context) => EmployeeBloc(context.read<EmployeeRepository>())),
        ],
        child: const AsianFiberCableAdmin(),
      ),
    ),
  );
}
