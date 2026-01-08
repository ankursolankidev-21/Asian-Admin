import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/theme/theme_bloc.dart';
import 'bloc/theme/theme_state.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_page.dart';

class AsianFiberCableAdmin extends StatelessWidget {
  const AsianFiberCableAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (_, state) {
        return MaterialApp(
          title: 'Asian Fiber & Cable',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          home: const SplashPage(),
        );
      },
    );
  }
}
