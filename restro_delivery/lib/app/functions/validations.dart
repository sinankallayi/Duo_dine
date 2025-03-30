import 'package:form_field_validator/form_field_validator.dart';

final phoneNumberValidator = MinLengthValidator(
  10,
  errorText: 'Phone Number must be at least 10 digits long',
);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: 'Enter a valid email address'),
]);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
  PatternValidator(
    r'(?=.*?[#?!@$%^&*-/])',
    errorText: 'Passwords must have at least one special character',
  ),
]);

final requiredValidator = RequiredValidator(errorText: 'This field is required');
