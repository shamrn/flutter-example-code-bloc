import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_validation_result.freezed.dart';

@freezed
class SignUpValidationResult with _$SignUpValidationResult {
  const factory SignUpValidationResult({
    @Default(false) bool isEmailInvalidError,
    @Default(false) bool isPasswordInvalidError,
    @Default(false) bool isPasswordMismatchError,
    @Default(false) bool isServerMessageError,
    String? emailErrorText,
    String? passwordErrorText,
    String? confirmPasswordErrorText,
    String? serverMessageText,
  }) = _SignUpValidationResult;

  const SignUpValidationResult._();

  bool get isValid =>
      !isEmailInvalidError &&
      !isPasswordInvalidError &&
      !isPasswordMismatchError &&
      !isServerMessageError;
}
