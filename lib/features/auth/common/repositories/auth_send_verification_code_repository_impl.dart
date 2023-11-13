import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:finance_mobile/common/exceptions/unknown_error_exception.dart';
import 'package:finance_mobile/common/helpers/hash_sum_helper.dart';
import 'package:finance_mobile/features/auth/common/data_sources/auth_send_verification_code_data_source.dart';
import 'package:finance_mobile/features/auth/common/models/auth_send_verification_code_request.dart';
import 'package:finance_mobile/features/auth/common/models/sign_up_validation_result.dart';
import 'package:finance_mobile/features/auth/common/repositories/auth_send_verification_code_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthSendVerificationCodeRepository)
class AuthSendVerificationCodeRepositoryImpl
    implements AuthSendVerificationCodeRepository {
  const AuthSendVerificationCodeRepositoryImpl({
    required HashSumHelper hashSumHelper,
    required AuthSendVerificationCodeDataSource sendVerificationCodeDataSource,
  })  : _hashSumHelper = hashSumHelper,
        _sendVerificationCodeDataSource = sendVerificationCodeDataSource;

  final HashSumHelper _hashSumHelper;
  final AuthSendVerificationCodeDataSource _sendVerificationCodeDataSource;

  @override
  Future<Either<UnknownErrorException, SignUpValidationResult>>
      sendVerificationCode({
    required String email,
  }) async {
    try {
      await _sendVerificationCodeDataSource.sendVerificationCode(
        AuthSendVerificationCodeRequest(
          email: email,
          hashSum: _hashSumHelper.generateHashSum(email),
        ),
      );

      return const Right(SignUpValidationResult());
    } on DioException catch (dioException) {
      final response = dioException.response;

      if (response != null && response.statusCode == HttpStatus.badRequest) {
        final fieldsError =
            response.data['fields_error'] ?? <String, dynamic>{};
        final messageErrorText = response.data['message'];

        final emailErrorText = fieldsError['email'];

        return Right(
          SignUpValidationResult(
            isEmailInvalidError: emailErrorText != null,
            emailErrorText: emailErrorText is String ? emailErrorText : null,
            isServerMessageError: messageErrorText != null,
            serverMessageText:
                messageErrorText is String ? messageErrorText : null,
          ),
        );
      }

      return Left(UnknownErrorException());
    } on Exception catch (_) {
      return Left(UnknownErrorException());
    }
  }
}
