import 'package:finance_mobile/core/env/environment_config.dart';
import 'package:finance_mobile/features/auth/common/models/sign_up_validation_result.dart';
import 'package:finance_mobile/features/auth/common/use_cases/auth_send_verification_code_use_case.dart';
import 'package:finance_mobile/features/auth/sign_up/domain/use_cases/sign_up_validation_use_case.dart';
import 'package:finance_mobile/features/auth/sign_up/presentation/bloc/sign_up_state.dart';
import 'package:finance_mobile/features/auth/sign_up/presentation/models/sign_up_errors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required EnvironmentConfig environmentConfig,
    required SignUpValidationUseCase validationUseCase,
    required AuthSendVerificationCodeUseCase sendVerificationCodeUseCase,
  })  : _validationUseCase = validationUseCase,
        _sendVerificationCodeUseCase = sendVerificationCodeUseCase,
        super(SignUpState(
          termsAndConditionsUrl: environmentConfig.termsAndConditionsUrl,
          privacyPolicyUrl: environmentConfig.privacyPolicyUrl,
        ));

  final SignUpValidationUseCase _validationUseCase;
  final AuthSendVerificationCodeUseCase _sendVerificationCodeUseCase;

  void handleInputEmailValue(String value) {
    final availableInputDataResult = state.availableInputDataResult.copyWith(
      isEmailEmpty: value.isEmpty,
    );

    emit(
      state.copyWith(
        availableInputDataResult: availableInputDataResult,
        isContinueButtonEnabled: availableInputDataResult.isFieldsNotEmpty,
      ),
    );
  }

  void handleInputPasswordValue(String value) {
    final availableInputDataResult = state.availableInputDataResult.copyWith(
      isPasswordEmpty: value.isEmpty,
    );

    emit(
      state.copyWith(
        availableInputDataResult: availableInputDataResult,
        isContinueButtonEnabled: availableInputDataResult.isFieldsNotEmpty,
      ),
    );
  }

  void handleInputConfirmPasswordValue(String value) {
    final availableInputDataResult = state.availableInputDataResult.copyWith(
      isConfirmPasswordEmpty: value.isEmpty,
    );

    emit(
      state.copyWith(
        availableInputDataResult: availableInputDataResult,
        isContinueButtonEnabled: availableInputDataResult.isFieldsNotEmpty,
      ),
    );
  }

  Future<void> validateAndContinue({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final validationResult = _validationUseCase.validate(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (!validationResult.isValid) {
      emit(state.copyWith(validationResult: validationResult));

      return;
    }

    emit(state.copyWith(isLoading: true));

    final unknownErrorOrValidationResult =
        await _sendVerificationCodeUseCase.sendVerificationCode(
      email: email,
    );

    unknownErrorOrValidationResult.fold(_onUnknownError, _onValidationResult);
  }

  void _onValidationResult(SignUpValidationResult validationResult) {
    if (!validationResult.isValid) {
      emit(
        state.copyWith(
          isLoading: false,
          validationResult: validationResult,
        ),
      );

      return;
    }

    emit(state.copyWith(isLoading: false, isContinued: true));
  }

  void _onUnknownError(_) {
    emit(
      state.copyWith(
        isLoading: false,
        errors: const SignUpErrors(isUnknownError: true),
      ),
    );
  }

  void handleValidationResult(dynamic validationResult) {
    if (validationResult is SignUpValidationResult) {
      emit(state.copyWith(validationResult: validationResult));
    }
  }

  void resetErrors() {
    emit(state.copyWith(errors: null));
  }

  void resetContinued() {
    emit(state.copyWith(isContinued: false));
  }
}
