import 'package:either_dart/either.dart';
import 'package:finance_mobile/common/models/auth_token_data.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/domain/models/sign_up_error_data.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/domain/repositories/sign_up_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignUpUseCase {
  const SignUpUseCase(this._signUpRepository);

  final SignUpRepository _signUpRepository;

  Future<Either<SignUpErrorData, AuthTokenData>> signUp({
    required String code,
    required String password,
    required String email,
  }) {
    return _signUpRepository.signUp(
      code: code,
      password: password,
      email: email,
    );
  }
}
