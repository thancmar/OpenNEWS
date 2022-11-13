part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Initialize extends AuthEvent {
  Initialize();
}

class IncompleteSignInRequested extends AuthEvent {
  IncompleteSignInRequested();
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

// class IncompleteSignInRequested extends AuthEvent {
//   IncompleteSignInRequested();
// }

// When the user signing up with email and password this event is called and the [AuthRepository] is called to sign up the user
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstname;
  final String lastname;
  final String date_of_birth;
  final String sex;
  final String? address_street;
  final String? address_house_nr;
  final String? address_zip;
  final String? address_city;
  final String? phone;
  final String? iban;
  final String? account_owner;
  final String? creation_date;
  final String? origin;

  SignUpRequested(this.email, this.password, this.firstname, this.lastname, this.date_of_birth, this.sex, this.address_street, this.address_house_nr, this.address_zip, this.address_city, this.phone,
      this.iban, this.account_owner, this.creation_date, this.origin);
}

// When the user signing in with google this event is called and the [AuthRepository] is called to sign in the user
// class GoogleSignInRequested extends AuthEvent {}

// When the user signing out this event is called and the [AuthRepository] is called to sign out the user
class SignOutRequested extends AuthEvent {}