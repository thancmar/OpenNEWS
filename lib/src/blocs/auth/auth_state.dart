part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  // static late User? user;
  static String? savedEmail;
  static String? savedPWD;
  static  GetUserDetails? userDetails = GetUserDetails();
  static late GetUserDetails inCompleteUserDetails = GetUserDetails() ;

  AuthState();

  @override
  List<Object> get props => [];
}

// When the user presses the signin or signup button the state is changed to loading first and then to Authenticated.
class LoadingAuth extends AuthState {

  LoadingAuth( ) : super();
  // @override
  // List<Object?> get props => [userdetails];
}

class GoToLoginPage extends AuthState {

  GoToLoginPage() : super();
  // @override
  // List<Object?> get props => [];
}

// When the user is authenticated the state is changed to Authenticated.
class Authenticated extends AuthState {
  Authenticated() : super();
  // @override
  // List<Object?> get props => [userdetails];
}

class AuthenticatedWithGoogle extends AuthState {
  AuthenticatedWithGoogle( ) : super();
  // @override
  // List<Object?> get props => [];
}

class IncompleteAuthenticated extends AuthState {
  IncompleteAuthenticated( ) : super();
  // @override
  // List<Object?> get props => [];
}

// This is the initial state of the bloc. When the user is not authenticated the state is changed to Unauthenticated.
class UnAuthenticated extends AuthState {
  UnAuthenticated( ) : super();
  // @override
  // List<Object?> get props => [];
}

// If any error occurs the state is changed to AuthError.
class AuthError extends AuthState {
  final String error;

  AuthError(this.error):super();
  // @override
  // List<Object?> get props => [error];
}