import 'package:either_dart/either.dart';
import 'package:finance_mobile/common/exceptions/unknown_error_exception.dart';
import 'package:finance_mobile/features/auth/common/models/sign_up_validation_result.dart';
import 'package:finance_mobile/features/auth/common/repositories/auth_send_verification_code_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthSendVerificationCodeUseCase {
  const AuthSendVerificationCodeUseCase(this._sendVerificationCodeRepository);

  final AuthSendVerificationCodeRepository _sendVerificationCodeRepository;

  Future<Either<UnknownErrorException, SignUpValidationResult>>
      sendVerificationCode({
    required String email,
  }) {
    return _sendVerificationCodeRepository.sendVerificationCode(email: email);
  }
}
