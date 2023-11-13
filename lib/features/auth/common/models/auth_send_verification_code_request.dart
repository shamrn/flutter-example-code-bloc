import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_send_verification_code_request.freezed.dart';
part 'auth_send_verification_code_request.g.dart';

@freezed
class AuthSendVerificationCodeRequest with _$AuthSendVerificationCodeRequest {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AuthSendVerificationCodeRequest({
    required String email,
    required String hashSum,
  }) = _AuthSignUpSendCode;

  factory AuthSendVerificationCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthSendVerificationCodeRequestFromJson(json);
}
