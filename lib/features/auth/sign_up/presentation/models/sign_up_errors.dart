import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_errors.freezed.dart';

@freezed
class SignUpErrors with _$SignUpErrors {
  const factory SignUpErrors({
    @Default(false) bool isUnknownError,
  }) = _SignUpErrors;
}
