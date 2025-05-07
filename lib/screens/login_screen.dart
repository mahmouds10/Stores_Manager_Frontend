import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  bool get isFormValid =>
      emailController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty;

  Future<void> showAlertDialog(
      String title,
      String message,
      Color color,
      IconData icon,
      ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(color: color)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> handleTokenStorage(String token, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = email.split('@')[0];
    await prefs.setString('auth_token', token);
    await prefs.setString('student_id', studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is LoginSuccess) {
            await handleTokenStorage(state.token, emailController.text);
            await showAlertDialog(
              "Success",
              "Login successful!",
              Colors.green,
              Icons.check_circle,
            );
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthFailure) {
            showAlertDialog("Error", state.error, Colors.red, Icons.error);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned(
                              left: -202,
                              top: -393,
                              child: Container(
                                width: 751,
                                height: 751,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFC1F6F0).withOpacity(1.0),
                                      Color(0xFFDDF6F3).withOpacity(0.0),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 141,
                              top: -176,
                              child: Container(
                                width: 412,
                                height: 412,
                                decoration: BoxDecoration(
                                  color: Color(0xFF169C89).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 30),
                                  Image.asset(
                                    'assets/login_image.png',
                                    height: 200,
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    child: const Text(
                                      "Welcome back!",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF169C89),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    child: const Text(
                                      "Enter your credentials to continue.",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF999999),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  TextField(
                                    controller: emailController,
                                    onChanged: (_) => setState(() {}),
                                    decoration: const InputDecoration(
                                      labelText: "Email Address",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: passwordController,
                                    onChanged: (_) => setState(() {}),
                                    obscureText: !isPasswordVisible,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: const Color(0xFF169C89),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isPasswordVisible =
                                            !isPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isFormValid
                                            ? const Color(0xFF169C89)
                                            : Colors.grey,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: (state is AuthLoading ||
                                          !isFormValid)
                                          ? null
                                          : () {
                                        context.read<AuthCubit>().login(
                                          emailController.text.trim(),
                                          passwordController.text
                                              .trim(),
                                        );
                                      },
                                      child: state is AuthLoading
                                          ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child:
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : const Text(
                                        'Log in',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 40,
                              left: 20,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.popAndPushNamed(context, '/');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF6F5),
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF999999),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF169C89),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
