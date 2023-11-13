import 'package:dio/dio.dart';
import 'package:finance_mobile/common/models/auth_token_data.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/data/models/sign_up_request.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'sign_up_data_source.g.dart';

@RestApi()
@injectable
abstract class SignUpDataSource {
  @factoryMethod
  factory SignUpDataSource(Dio dio) => _SignUpDataSource(dio);

  @POST('/api/authorization/email/sign-up/')
  Future<AuthTokenData> signUp(@Body() SignUpRequest body);
}
