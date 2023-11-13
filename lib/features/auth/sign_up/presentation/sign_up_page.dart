import 'package:auto_route/auto_route.dart';
import 'package:finance_mobile/common/extensions/localization_extension.dart';
import 'package:finance_mobile/common/extensions/state_with_bloc.dart';
import 'package:finance_mobile/common/ui/app_colors.dart';
import 'package:finance_mobile/common/ui/app_text_styles.dart';
import 'package:finance_mobile/common/widgets/app_password_field.dart';
import 'package:finance_mobile/common/widgets/app_text_field.dart';
import 'package:finance_mobile/common/widgets/bottom_flash_bars/bottom_flash_bar_unknown_error.dart';
import 'package:finance_mobile/common/widgets/header_semi_circle_with_logo.dart';
import 'package:finance_mobile/common/widgets/outline_solid_button.dart';
import 'package:finance_mobile/common/widgets/responsive_opacity_button.dart';
import 'package:finance_mobile/core/routing/app_router.gr.dart';
import 'package:finance_mobile/features/auth/common/arguments/sign_up_verification_arguments.dart';
import 'package:finance_mobile/features/auth/sign_up/presentation/bloc/sign_up_cubit.dart';
import 'package:finance_mobile/features/auth/sign_up/presentation/bloc/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState
    extends StateWithBloc<SignUpCubit, SignUpState, SignUpPage> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  late final TextEditingController _emailTextEditingController;
  late final TextEditingController _passwordTextEditingController;
  late final TextEditingController _confirmPasswordTextEditingController;

  @override
  void initState() {
    super.initState();

    _emailTextEditingController = TextEditingController()
      ..addListener(_emailControllerListener);

    _passwordTextEditingController = TextEditingController()
      ..addListener(_passwordControllerListener);

    _confirmPasswordTextEditingController = TextEditingController()
      ..addListener(_confirmPasswordControllerListener);
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _confirmPasswordTextEditingController.dispose();

    super.dispose();
  }

  void _emailControllerListener() {
    bloc.handleInputEmailValue(_emailTextEditingController.text);
  }

  void _passwordControllerListener() {
    bloc.handleInputPasswordValue(_passwordTextEditingController.text);
  }

  void _confirmPasswordControllerListener() {
    bloc.handleInputConfirmPasswordValue(
      _confirmPasswordTextEditingController.text,
    );
  }

  void _errorListener(SignUpState state) {
    if (state.errors?.isUnknownError ?? false) {
      bloc.resetErrors();
      showBottomFlashBarUnknownError(context);
    }
  }

  Future<void> _continuedListener(SignUpState state) async {
    if (state.isContinued) {
      bloc.resetContinued();

      final validationResult = await context.router.push(
        SignUpVerificationRoute(
          signUpVerificationArguments: SignUpVerificationArguments(
            email: _emailTextEditingController.text,
            password: _passwordTextEditingController.text,
          ),
        ),
      );

      bloc.handleValidationResult(validationResult);
    }
  }

  void _blocListener(BuildContext context, SignUpState state) {
    _errorListener(state);
    _continuedListener(state);
  }

  void _onTapTermsAndConditions() {
    launchUrl(
      Uri.parse(bloc.state.termsAndConditionsUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  void _onTapPrivacyPolicy() {
    launchUrl(
      Uri.parse(bloc.state.privacyPolicyUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  void _onTapContinue() {
    bloc.validateAndContinue(
      email: _emailTextEditingController.text,
      password: _passwordTextEditingController.text,
      confirmPassword: _confirmPasswordTextEditingController.text,
    );
  }

  void _onTapSignIn() {
    context.router.push(const SignInRoute());
  }

  Widget _buildTitle() {
    return Text(
      context.locale.authSignUpTitle,
      style: AppTextStyles.nunitoRegular.copyWith(
        fontSize: 24.sp,
      ),
    );
  }

  Widget _buildTextError(String text) {
    return Text(
      text,
      style: AppTextStyles.nunitoRegular.copyWith(
        fontSize: 14.sp,
        color: AppColors.red,
      ),
    );
  }

  Widget _buildConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.locale.authSignUpConditionsOneText,
          style: AppTextStyles.nunitoRegular.copyWith(fontSize: 14.sp),
        ),
        Row(
          children: [
            ResponsiveOpacityButton(
              onTap: _onTapTermsAndConditions,
              child: Text(
                context.locale.authSignUpConditionsTwoText,
                style: AppTextStyles.nunitoRegular.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.accent,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              context.locale.authSignUpConditionsThirdText,
              style: AppTextStyles.nunitoRegular.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        ResponsiveOpacityButton(
          onTap: _onTapPrivacyPolicy,
          child: Text(
            context.locale.authSignUpConditionsFourthText,
            style: AppTextStyles.nunitoRegular.copyWith(
              fontSize: 14.sp,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.locale.authSignUpSignInPromptDescription,
          style: AppTextStyles.nunitoMedium.copyWith(
            fontSize: 16.sp,
          ),
        ),
        SizedBox(width: 5.w),
        ResponsiveOpacityButton(
          onTap: _onTapSignIn,
          child: Text(
            context.locale.appSignInButtonLabel,
            style: AppTextStyles.nunitoMedium.copyWith(
              fontSize: 16.sp,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageContent(SignUpState state) {
    final validationResult = state.validationResult;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        SizedBox(height: 24.h),
        AppTextField(
          label: context.locale.appEmailFieldTitle,
          controller: _emailTextEditingController,
          keyboardType: TextInputType.emailAddress,
          currentFocusNode: _emailFocusNode,
          nextFocusNode: _passwordFocusNode,
          isError: validationResult.isEmailInvalidError,
          errorText: validationResult.emailErrorText ??
              context.locale.authSignUpIncorrectEmailError,
        ),
        SizedBox(height: 12.h),
        AppPasswordField(
          label: context.locale.appPasswordFieldTitle,
          controller: _passwordTextEditingController,
          currentFocusNode: _passwordFocusNode,
          nextFocusNode: _confirmPasswordFocusNode,
          isError: validationResult.isPasswordInvalidError,
          errorText: validationResult.passwordErrorText ??
              context.locale.authSignUpIncorrectPasswordError,
        ),
        SizedBox(height: 14.h),
        AppPasswordField(
          label: context.locale.authSignUpConfirmPasswordFieldTitle,
          controller: _confirmPasswordTextEditingController,
          currentFocusNode: _confirmPasswordFocusNode,
          isError: validationResult.isPasswordMismatchError,
          errorText: validationResult.confirmPasswordErrorText ??
              context.locale.authSignUpMismatchPasswordError,
        ),
        SizedBox(height: 14.h),
        if (validationResult.isServerMessageError &&
            validationResult.serverMessageText != null) ...[
          _buildTextError(validationResult.serverMessageText!),
          SizedBox(height: 14.h),
        ],
        _buildConditions(),
        const Spacer(),
        SizedBox(height: 14.h),
        OutlineSolidButton(
          title: context.locale.appContinueButtonLabel,
          onTap: _onTapContinue,
          isEnabled: state.isContinueButtonEnabled,
          isLoading: state.isLoading,
        ),
        SizedBox(height: 14.h),
        _buildSignInPrompt(),
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
            child: BlocBuilder<SignUpCubit, SignUpState>(
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
      child: BlocListener<SignUpCubit, SignUpState>(
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
