import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/cubits/auth/auth_cubit.dart';
import 'package:mobile_frontend/cubits/auth/auth_state.dart';
import 'package:mobile_frontend/models/user_model.dart';
import '../utils/text_field_input_decoration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreen();
}


class _RegisterScreen extends State<RegisterScreen> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  int? selectedGender;
  int? selectedLevel ;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Validation state variables
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  final _formGlobalId = GlobalKey<FormState>();

  // Name validation function
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  // Email validation function
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!regex.hasMatch(value)) {
      return 'Invalid email format (e.g., example@domain.com)';
    }
    return null;
  }

  // Password validation function
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 number';
    }
    return null;
  }

  // Confirm Password validation function
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Show dialog
  Future<void> showAlertDialog(String title, String message, Color color, IconData icon) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Gender widget builder
  Widget buildGenderOption(int? value, String label, Color color) {
    return Column(
      children: [
        Radio<int?>(
          value: value,
          groupValue: selectedGender,
          onChanged: (newValue) {
            setState(() {
              selectedGender = newValue;
            });
          },
          activeColor: color,
        ),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Function to register in remote database
  Future<void> _registerUser() async {
    if (!_formGlobalId.currentState!.validate()) return;

    // Convert gender to string
    String genderStr;
    if(selectedGender == 0) {
      genderStr = "Male";
    }else if (selectedGender == 1) {
      genderStr = "Female";
    }else{
      genderStr = "";
    }

    final user = UserModel(
      name: _nameController.text,
      gender: genderStr,
      email: _emailController.text,
      level: selectedLevel ?? 0,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );



    // Trigger Cubit registration
    context.read<AuthCubit>().register(user);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is RegisterSuccess) {
          await showAlertDialog("Success", "Registration successful!", Colors.green, Icons.check_circle);
          Navigator.pushReplacementNamed(context, '/login');
        } else if (state is AuthFailure) {
          showAlertDialog("Error", state.error, Colors.red, Icons.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      // Background Circles (unchanged)
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

                      // Form Content
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            Image.asset('assets/register_image.png', height: 251),
                            const SizedBox(height: 20),
                            const SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Create account!",
                                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF169C89)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Sign up to get started.",
                                style: TextStyle(fontSize: 18, color: Color(0xFF999999)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Form
                            Form(
                              key: _formGlobalId,
                              child: Column(
                                children: [
                                  // Name
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: TextFieldInputDecoration.getInputDecoration(
                                      hintText: "Name",
                                      icon: Icons.person,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _nameError = _validateName(value);
                                      });
                                    },
                                  ),
                                  if (_nameError != null && _nameController.text != "")
                                    _buildErrorText(_nameError!),

                                  const SizedBox(height: 20),

                                  // Email
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: TextFieldInputDecoration.getInputDecoration(
                                      hintText: "ex. example@domain.com",
                                      icon: Icons.email,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _emailError = _validateEmail(value);
                                      });
                                    },
                                  ),
                                  if (_emailError != null && _emailController.text != "")
                                    _buildErrorText(_emailError!),

                                  const SizedBox(height: 20),

                                  // Password
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !isPasswordVisible,
                                    decoration: TextFieldInputDecoration.getInputDecoration(
                                      hintText: "Password",
                                      icon: Icons.lock,
                                      suffix_: IconButton(
                                        icon: Icon(
                                          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                          color: Color(0xFF169C89),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isPasswordVisible = !isPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _passwordError = _validatePassword(value);
                                      });
                                    },
                                  ),
                                  if (_passwordError != null && _passwordController.text!= "")
                                    _buildErrorText(_passwordError!),

                                  const SizedBox(height: 20),

                                  // Confirm Password
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: !isConfirmPasswordVisible,
                                    decoration: TextFieldInputDecoration.getInputDecoration(
                                      hintText: "Confirm Password",
                                      icon: Icons.lock,
                                      suffix_: IconButton(
                                        icon: Icon(
                                          isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                          color: Color(0xFF169C89),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isConfirmPasswordVisible = !isConfirmPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _confirmPasswordError = _validateConfirmPassword(value);
                                      });
                                    },
                                  ),
                                  if (_confirmPasswordError != null)
                                    _buildErrorText(_confirmPasswordError!),

                                  const SizedBox(height: 20),

                                  // Gender
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildGenderOption(0, "Male", Colors.blue),
                                      buildGenderOption(1, "Female", Colors.pink),
                                      buildGenderOption(null, "Not Specified", Colors.grey),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Level
                                  Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        margin: const EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: DropdownButtonFormField<int>(
                                          value: selectedLevel,
                                          decoration: const InputDecoration(border: InputBorder.none),
                                          hint: const Text("Select Level", style: TextStyle(color: Colors.grey)),
                                          items: [1, 2, 3, 4].map((int value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text("Level $value"),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedLevel = value;
                                            });
                                          },
                                        ),
                                      ),
                                      const Positioned(
                                        top: 2,
                                        left: 15,
                                        child: Text(
                                          "Level",
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 30),

                                  // Register Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF169C89),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      onPressed: state is AuthLoading ? null : _registerUser,
                                      child: state is AuthLoading
                                          ? CircularProgressIndicator(color: Colors.white)
                                          : const Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)),
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  // Login link
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Already have an account? ", style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
                                      GestureDetector(
                                        onTap: () => Navigator.pushNamed(context, '/login'),
                                        child: const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF169C89))),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Back arrow
                      Positioned(
                        top: 40,
                        left: 20,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        error,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }


}