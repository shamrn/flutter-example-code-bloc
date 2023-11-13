import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_verification_validation_result.freezed.dart';

@freezed
class SignUpVerificationValidationResult
    with _$SignUpVerificationValidationResult {
  const factory SignUpVerificationValidationResult({
    @Default(false) bool isVerificationCodeInvalidError,
    String? verificationCodeErrorText,
  }) = _SignUpVerificationValidationResult;

  const SignUpVerificationValidationResult._();

  bool get isValid => !isVerificationCodeInvalidError;
}
