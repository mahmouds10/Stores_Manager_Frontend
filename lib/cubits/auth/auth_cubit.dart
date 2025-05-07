import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_frontend/models/user_model.dart';
import '../../services/auth_service.dart';
import 'auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final token = await _authService.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      emit(LoginSuccess(token: token));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> register(UserModel user) async {
    emit(AuthLoading());
    try {
      await _authService.register(user);
      emit(RegisterSuccess());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}

