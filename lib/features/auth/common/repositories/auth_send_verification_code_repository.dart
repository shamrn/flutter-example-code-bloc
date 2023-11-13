import 'package:either_dart/either.dart';
import 'package:finance_mobile/common/exceptions/unknown_error_exception.dart';
import 'package:finance_mobile/features/auth/common/models/sign_up_validation_result.dart';

abstract interface class AuthSendVerificationCodeRepository {
  Future<Either<UnknownErrorException, SignUpValidationResult>>
      sendVerificationCode({
    required String email,
  });
}
