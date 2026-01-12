import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../bloc/auth/auth_state.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/widgets/app_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }else{
            await SecureStorage.saveLogin(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              rememberMe: _rememberMe,
            );
            Navigator.pushReplacementNamed(context, '/home');

          }
        },
        child: Center(
          child: SizedBox(
            width: 360,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Admin Login',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  showRequiredMark: true,
                ),

                const SizedBox(height: 16),

                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscure: true,
                  showRequiredMark: true,
                ),

                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (v) {
                        setState(() => _rememberMe = v ?? false);
                      },
                    ),
                    const Text('Remember me'),
                  ],
                ),

                const SizedBox(height: 12),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                          FocusScope.of(context).unfocus(); // 🔑 web fix

                          context.read<AuthBloc>().add(
                            LoginRequested(
                              email:
                              _emailController.text.trim(),
                              password:
                              _passwordController.text.trim(),
                            ),
                          );
                        },
                        child: state is AuthLoading
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text('Login'),
                      ),
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
  Future<void> _loadSavedLogin() async {
    final email = await SecureStorage.getEmail();
    final password = await SecureStorage.getPassword();
    final remember = await SecureStorage.getRememberMe();

    if (email != null) {
      _emailController.text = email;
    }

    if (remember && password != null) {
      _passwordController.text = password;
    }

    setState(() => _rememberMe = remember);
  }
}
