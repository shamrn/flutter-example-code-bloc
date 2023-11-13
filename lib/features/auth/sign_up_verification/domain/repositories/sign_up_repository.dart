import 'package:either_dart/either.dart';
import 'package:finance_mobile/common/models/auth_token_data.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/domain/models/sign_up_error_data.dart';

abstract interface class SignUpRepository {
  Future<Either<SignUpErrorData, AuthTokenData>> signUp({
    required String code,
    required String password,
    required String email,
  });
}
