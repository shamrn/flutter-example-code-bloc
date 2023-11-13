import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_available_input_data_result.freezed.dart';

@freezed
class SignUpAvailableInputDataResult with _$SignUpAvailableInputDataResult {
  const factory SignUpAvailableInputDataResult({
    @Default(true) bool isEmailEmpty,
    @Default(true) bool isPasswordEmpty,
    @Default(true) bool isConfirmPasswordEmpty,
  }) = _SignUpAvailableInputDataResult;

  const SignUpAvailableInputDataResult._();

  bool get isFieldsNotEmpty =>
      !isEmailEmpty && !isPasswordEmpty && !isConfirmPasswordEmpty;
}
