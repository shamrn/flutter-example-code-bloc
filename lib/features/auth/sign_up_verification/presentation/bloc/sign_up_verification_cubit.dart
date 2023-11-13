import 'dart:async';

import 'package:finance_mobile/common/bloc/base_cubit.dart';
import 'package:finance_mobile/common/models/auth_token_data.dart';
import 'package:finance_mobile/common/use_cases/auth_data/auth_data_save_use_case.dart';
import 'package:finance_mobile/features/auth/common/arguments/sign_up_verification_arguments.dart';
import 'package:finance_mobile/features/auth/common/models/sign_up_validation_result.dart';
import 'package:finance_mobile/features/auth/common/use_cases/auth_send_verification_code_use_case.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/domain/models/sign_up_error_data.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/domain/use_cases/sign_up_use_case.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/presentation/bloc/sign_up_verification_state.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/presentation/models/sign_up_verification_errors.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignUpVerificationCubit extends BaseCubit<SignUpVerificationState> {
  SignUpVerificationCubit({
    @factoryParam
    required SignUpVerificationArguments signUpVerificationArguments,
    required AuthSendVerificationCodeUseCase sendVerificationCodeUseCase,
    required SignUpUseCase signUpUseCase,
    required AuthDataSaveUseCase authDataSaveUseCase,
  })  : _sendVerificationCodeUseCase = sendVerificationCodeUseCase,
        _signUpUseCase = signUpUseCase,
        _authDataSaveUseCase = authDataSaveUseCase,
        super(SignUpVerificationState(
          email: signUpVerificationArguments.email,
          password: signUpVerificationArguments.password,
        ));

  static const _resendCodeCountdownSeconds = 30;
  static const _validCodeLength = 6;

  final AuthSendVerificationCodeUseCase _sendVerificationCodeUseCase;
  final SignUpUseCase _signUpUseCase;
  final AuthDataSaveUseCase _authDataSaveUseCase;

  Timer? _timer;

  @override
  Future<void> onInit() async {
    unawaited(_runResendCodeCountdown());
  }

  @override
  Future<void> close() async {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }

    await super.close();
  }

  void handleInputVerificationCodeValue(String value) {
    emit(
      state.copyWith(isSignInButtonEnabled: value.length >= _validCodeLength),
    );
  }

  Future<void> resendVerificationCode() async {
    final unknownErrorOrSignUpValidationResult =
        await _sendVerificationCodeUseCase.sendVerificationCode(
      email: state.email,
    );

    unknownErrorOrSignUpValidationResult.fold(
      _onUnknownError,
      _onSignUpValidationResult,
    );
  }

  void _onUnknownError(_) {
    emit(
      state.copyWith(
        isLoading: false,
        errors: const SignUpVerificationErrors(isUnknownError: true),
      ),
    );
  }

  void _onSignUpValidationResult(
    SignUpValidationResult signUpValidationResult,
  ) {
    if (!signUpValidationResult.isValid) {
      emit(
        state.copyWith(
          signUpValidationResult: signUpValidationResult,
          isBackRedirect: true,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        isResendCodeButtonEnabled: false,
        resendCodeCountdownSeconds: _resendCodeCountdownSeconds,
      ),
    );

    _runResendCodeCountdown();
  }

  Future<void> signIn({required String verificationCode}) async {
    emit(state.copyWith(isLoading: true));

    final signUpErrorOrAuthTokenData = await _signUpUseCase.signUp(
      code: verificationCode,
      password: state.password,
      email: state.email,
    );

    signUpErrorOrAuthTokenData.fold(_onSignUpError, _onAuthTokenData);
  }

  void _onSignUpError(SignUpErrorData signUpErrorData) {
    if (signUpErrorData.isUnknownError ?? false) {
      emit(
        state.copyWith(
          isLoading: false,
          errors: const SignUpVerificationErrors(isUnknownError: true),
        ),
      );

      return;
    }

    if (!(signUpErrorData.signUpValidationResult?.isValid ?? true)) {
      emit(
        state.copyWith(
          isLoading: false,
          isBackRedirect: true,
          signUpValidationResult: signUpErrorData.signUpValidationResult,
        ),
      );

      return;
    }

    if (!(signUpErrorData.signUpVerificationValidationResult?.isValid ??
        true)) {
      emit(
        state.copyWith(
          isLoading: false,
          validationResult: signUpErrorData.signUpVerificationValidationResult,
        ),
      );
    }
  }

  void _onAuthTokenData(AuthTokenData authTokenData) {
    _authDataSaveUseCase.save(authTokenData);

    emit(state.copyWith(isLoading: false, isFinished: true));
  }

  void resetErrors() {
    emit(state.copyWith(errors: null));
  }

  Future<void> _runResendCodeCountdown() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final timeSecond = timer.tick;

      emit(state.copyWith(
        resendCodeCountdownSeconds: _resendCodeCountdownSeconds - timeSecond,
      ));

      if (timeSecond == _resendCodeCountdownSeconds) {
        emit(state.copyWith(isResendCodeButtonEnabled: true));

        timer.cancel();
      }
    });
  }
}
