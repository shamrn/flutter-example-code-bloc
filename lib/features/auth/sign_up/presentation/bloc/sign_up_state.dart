import 'package:finance_mobile/features/auth/common/models/sign_up_validation_result.dart';
import 'package:finance_mobile/features/auth/sign_up/presentation/models/sign_up_available_input_data_result.dart';
import 'package:finance_mobile/features/auth/sign_up/presentation/models/sign_up_errors.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState({
    required String termsAndConditionsUrl,
    required String privacyPolicyUrl,
    @Default(false) bool isLoading,
    @Default(false) bool isContinued,
    @Default(false) bool isContinueButtonEnabled,
    @Default(SignUpAvailableInputDataResult())
    SignUpAvailableInputDataResult availableInputDataResult,
    @Default(SignUpValidationResult()) SignUpValidationResult validationResult,
    SignUpErrors? errors,
  }) = _SignUpState;
}
