import 'package:finance_mobile/features/auth/common/models/sign_up_validation_result.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/domain/models/sign_up_verification_validation_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_error_data.freezed.dart';

@freezed
class SignUpErrorData with _$SignUpErrorData {
  const factory SignUpErrorData({
    bool? isUnknownError,
    SignUpValidationResult? signUpValidationResult,
    SignUpVerificationValidationResult? signUpVerificationValidationResult,
  }) = _SignUpErrorData;
}
