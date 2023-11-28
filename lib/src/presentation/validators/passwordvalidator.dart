String? validatePassword(String? value) {
  // Define the criteria for a valid password with a regular expression.
  // This pattern requires at least one special character and at least 8 characters in total.
  String pattern = r'^(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value))
    return 'Password needs 8+ chars, 1+ symbol';
  else
    return null;
}