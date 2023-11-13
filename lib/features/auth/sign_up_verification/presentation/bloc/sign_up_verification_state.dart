import 'package:finance_mobile/features/auth/common/models/sign_up_validation_result.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/domain/models/sign_up_verification_validation_result.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/presentation/models/sign_up_verification_errors.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_verification_state.freezed.dart';

@freezed
class SignUpVerificationState with _$SignUpVerificationState {
  const factory SignUpVerificationState({
    required String email,
    required String password,
    @Default(false) bool isLoading,
    @Default(false) bool isBackRedirect,
    @Default(false) bool isFinished,
    @Default(false) bool isSignInButtonEnabled,
    @Default(false) bool isResendCodeButtonEnabled,
    @Default(30) int resendCodeCountdownSeconds,
    SignUpVerificationValidationResult? validationResult,
    SignUpValidationResult? signUpValidationResult,
    SignUpVerificationErrors? errors,
  }) = _SignUpVerificationState;
}
