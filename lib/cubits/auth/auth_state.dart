abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final String token;
  LoginSuccess({required this.token});
}

class RegisterSuccess extends AuthState {}


class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}
