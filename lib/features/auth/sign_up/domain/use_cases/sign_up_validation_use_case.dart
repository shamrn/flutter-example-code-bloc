import 'package:finance_mobile/features/auth/common/helpers/auth_validation_helper.dart';
import 'package:finance_mobile/features/auth/common/models/sign_up_validation_result.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignUpValidationUseCase {
  SignUpValidationResult validate({
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    var validationResult = const SignUpValidationResult();

    if (!AuthValidationHelper.isValidEmail(email)) {
      validationResult = validationResult.copyWith(
        isEmailInvalidError: true,
      );
    }

    if (!AuthValidationHelper.isValidPassword(password)) {
      validationResult = validationResult.copyWith(
        isPasswordInvalidError: true,
      );
    }

    if (password != confirmPassword) {
      validationResult = validationResult.copyWith(
        isPasswordMismatchError: true,
      );
    }

    return validationResult;
  }
}
