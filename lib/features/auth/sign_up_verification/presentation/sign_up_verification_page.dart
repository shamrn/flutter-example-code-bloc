import 'package:auto_route/auto_route.dart';
import 'package:finance_mobile/common/extensions/localization_extension.dart';
import 'package:finance_mobile/common/extensions/state_with_bloc.dart';
import 'package:finance_mobile/common/ui/app_colors.dart';
import 'package:finance_mobile/common/ui/app_text_styles.dart';
import 'package:finance_mobile/common/widgets/app_text_field.dart';
import 'package:finance_mobile/common/widgets/bottom_flash_bars/bottom_flash_bar_unknown_error.dart';
import 'package:finance_mobile/common/widgets/header_semi_circle_with_logo.dart';
import 'package:finance_mobile/common/widgets/outline_solid_button.dart';
import 'package:finance_mobile/common/widgets/responsive_button.dart';
import 'package:finance_mobile/core/routing/app_router.gr.dart';
import 'package:finance_mobile/features/auth/common/arguments/sign_up_verification_arguments.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/presentation/bloc/sign_up_verification_cubit.dart';
import 'package:finance_mobile/features/auth/sign_up_verification/presentation/bloc/sign_up_verification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class SignUpVerificationPage extends StatefulWidget {
  const SignUpVerificationPage({
    required SignUpVerificationArguments signUpVerificationArguments,
    super.key,
  }) : _arguments = signUpVerificationArguments;

  final SignUpVerificationArguments _arguments;

  @override
  State<SignUpVerificationPage> createState() =>
      // ignore: no_logic_in_create_state
      _SignUpVerificationPageState(_arguments);
}

class _SignUpVerificationPageState extends StateWithBloc<
    SignUpVerificationCubit, SignUpVerificationState, SignUpVerificationPage> {
  _SignUpVerificationPageState(SignUpVerificationArguments arguments)
      : super(paramBloc: arguments);

  late final TextEditingController _verificationCodeTextEditingController;

  @override
  void initState() {
    super.initState();

    _verificationCodeTextEditingController = TextEditingController()
      ..addListener(
        _verificationCodeControllerListener,
      );
  }

  @override
  void dispose() {
    super.dispose();

    _verificationCodeTextEditingController.dispose();
  }

  void _verificationCodeControllerListener() {
    bloc.handleInputVerificationCodeValue(
      _verificationCodeTextEditingController.text,
    );
  }

  void _errorListener(SignUpVerificationState state) {
    if (state.errors?.isUnknownError ?? false) {
      bloc.resetErrors();
      showBottomFlashBarUnknownError(context);
    }
  }

  void _backRedirectListener(SignUpVerificationState state) {
    if (state.isBackRedirect) {
      context.router.pop(state.signUpValidationResult);
    }
  }

  void _finishedListener(SignUpVerificationState state) {
    if (state.isFinished) {
      context.router.replaceAll([const PersonalSettingsRoute()]);
    }
  }

  void _blocListener(BuildContext context, SignUpVerificationState state) {
    _errorListener(state);
    _backRedirectListener(state);
    _finishedListener(state);
  }

  void _onTapChangeEmail() {
    context.router.pop();
  }

  void _onTapResendCode() {
    bloc.resendVerificationCode();
  }

  void _onTapSignIn() {
    bloc.signIn(verificationCode: _verificationCodeTextEditingController.text);
  }

  Widget _buildDescription(SignUpVerificationState state) {
    return Text(
      context.locale.authSignUpVerificationDescription(state.email),
      style: AppTextStyles.nunitoRegular,
    );
  }

  Widget _buildResendCode(SignUpVerificationState state) {
    return state.isResendCodeButtonEnabled
        ? ResponsiveButton(
            onTap: _onTapResendCode,
            child: Text(
              context.locale.authSignUpVerificationResendCodeButtonLabel,
              style: AppTextStyles.nunitoRegular.copyWith(
                fontSize: 14.sp,
                color: AppColors.accent,
              ),
            ),
          )
        : Text(
            context.locale.authSignUpVerificationResendCodeCountdown(
              state.resendCodeCountdownSeconds,
            ),
            style: AppTextStyles.nunitoRegular.copyWith(fontSize: 14.sp),
          );
  }

  Widget _buildChangeEmail() {
    return ResponsiveButton(
      onTap: _onTapChangeEmail,
      child: Text(
        context.locale.authSignUpVerificationChangeEmailButtonLabel,
        style: AppTextStyles.nunitoRegular.copyWith(
          fontSize: 14.sp,
          color: AppColors.accent,
        ),
      ),
    );
  }

  Widget _buildPageContent(SignUpVerificationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDescription(state),
        SizedBox(height: 24.h),
        AppTextField(
          label: context.locale.authSignUpVerificationCodeFieldTitle,
          controller: _verificationCodeTextEditingController,
          keyboardType: TextInputType.number,
          textInputFormatters: [LengthLimitingTextInputFormatter(6)],
          isError:
              state.validationResult?.isVerificationCodeInvalidError ?? false,
          errorText: state.validationResult?.verificationCodeErrorText,
        ),
        SizedBox(height: 14.h),
        _buildResendCode(state),
        SizedBox(height: 14.h),
        _buildChangeEmail(),
        const Spacer(),
        OutlineSolidButton(
          title: context.locale.appSignInButtonLabel,
          onTap: _onTapSignIn,
          isEnabled: state.isSignInButtonEnabled,
          isLoading: state.isLoading,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
            minHeight: constraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child:
                BlocBuilder<SignUpVerificationCubit, SignUpVerificationState>(
              builder: (context, state) => _buildPageContent(state),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<SignUpVerificationCubit, SignUpVerificationState>(
        bloc: bloc,
        listener: _blocListener,
        child: Scaffold(
          body: Stack(
            children: [
              const HeaderSemiCircleWithLogo(),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 120.h,
                    right: 16.w,
                    bottom: 24.h,
                    left: 16.w,
                  ),
                  child: _buildBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
