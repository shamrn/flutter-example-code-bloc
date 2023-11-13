import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:finance_mobile/common/helpers/hash_sum_helper.dart';
import 'package:finance_mobile/common/models/auth_token_data.dart';
import 'package:finance_mobile/features/auth/common/models/sign_up_validation_result.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/data/data_sources/sign_up_data_source.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/data/models/sign_up_request.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/domain/models/sign_up_error_data.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/domain/models/sign_up_verification_validation_result.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/domain/repositories/sign_up_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SignUpRepository)
class SignUpRepositoryImpl implements SignUpRepository {
  const SignUpRepositoryImpl({
    required HashSumHelper hashSumHelper,
    required SignUpDataSource dataSource,
  })  : _hashSumHelper = hashSumHelper,
        _dataSource = dataSource;

  final HashSumHelper _hashSumHelper;
  final SignUpDataSource _dataSource;

  @override
  Future<Either<SignUpErrorData, AuthTokenData>> signUp({
    required String code,
    required String password,
    required String email,
  }) async {
    try {
      final authToken = await _dataSource.signUp(
        SignUpRequest(
          hashSum: _hashSumHelper.generateHashSum(email),
          code: code,
          password: password,
          email: email,
        ),
      );

      return Right(authToken);
    } on DioException catch (dioException) {
      final response = dioException.response;

      if (response != null && response.statusCode == HttpStatus.badRequest) {
        final fieldsError =
            response.data['fields_error'] ?? <String, dynamic>{};

        final verificationCodeErrorText = fieldsError['code'];
        final emailErrorText = fieldsError['email'];
        final passwordErrorText = fieldsError['password'];

        return Left(
          SignUpErrorData(
            signUpValidationResult: SignUpValidationResult(
              isEmailInvalidError: emailErrorText != null,
              isPasswordInvalidError: passwordErrorText != null,
              emailErrorText: emailErrorText is String ? emailErrorText : null,
              passwordErrorText:
                  passwordErrorText is String ? passwordErrorText : null,
            ),
            signUpVerificationValidationResult:
                SignUpVerificationValidationResult(
              isVerificationCodeInvalidError: verificationCodeErrorText != null,
              verificationCodeErrorText: verificationCodeErrorText is String
                  ? verificationCodeErrorText
                  : null,
            ),
          ),
        );
      }

      return const Left(SignUpErrorData(isUnknownError: true));
    } on Exception catch (_) {
      return const Left(SignUpErrorData(isUnknownError: true));
    }
  }
}
