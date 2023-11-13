import 'package:dio/dio.dart';
import 'package:finance_mobile/features/auth/common/models/auth_send_verification_code_request.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'auth_send_verification_code_data_source.g.dart';

@RestApi()
@injectable
abstract class AuthSendVerificationCodeDataSource {
  @factoryMethod
  factory AuthSendVerificationCodeDataSource(Dio dio) =>
      _AuthSendVerificationCodeDataSource(dio);

  @POST('/api/authorization/email/send-auth-code/')
  Future<void> sendVerificationCode(
    @Body() AuthSendVerificationCodeRequest body,
  );
}
