import 'package:finance_mobile/common/extensions/theme_extension.dart';
import 'package:finance_mobile/common/ui/app_colors.dart';
import 'package:finance_mobile/common/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    required String label,
    TextEditingController? controller,
    FocusNode? currentFocusNode,
    FocusNode? nextFocusNode,
    String? errorText,
    bool isError = false,
    super.key,
  })  : _label = label,
        _controller = controller,
        _currentFocusNode = currentFocusNode,
        _nextFocusNode = nextFocusNode,
        _errorText = errorText,
        _isError = isError;

  final String _label;
  final TextEditingController? _controller;
  final FocusNode? _currentFocusNode;
  final FocusNode? _nextFocusNode;
  final String? _errorText;
  final bool _isError;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _isObscureText = true;

  void _onTapEyeIcon() {
    setState(() => _isObscureText = !_isObscureText);
  }

  void _onFieldSubmitted(BuildContext context) {
    if (widget._currentFocusNode != null && widget._nextFocusNode != null) {
      widget._currentFocusNode!.unfocus();
      FocusScope.of(context).requestFocus(widget._nextFocusNode);
    }
  }

  Widget _buildIconButton() {
    return GestureDetector(
      onTap: _onTapEyeIcon,
      child: Icon(
        _isObscureText ? Icons.visibility_off : Icons.visibility,
        size: 21.w,
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color:
        context.isDarkMode ? AppColors.transparentBlack : AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: widget._isError ? AppColors.red : AppColors.accent,
          width: 1.w,
        ),
      ),
      child: TextField(
        onSubmitted: (_) => _onFieldSubmitted(context),
        obscureText: _isObscureText,
        style: AppTextStyles.nunitoRegular.copyWith(fontSize: 16.sp),
        cursorColor: AppColors.accent,
        focusNode: widget._currentFocusNode,
        controller: widget._controller,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 9.h,
          ),
          border: InputBorder.none,
          labelText: widget._label,
          suffixIcon: _buildIconButton(),
        ),
      ),
    );
  }

  Widget _buildErrorText(String errorText) {
    return Text(
      errorText,
      style: AppTextStyles.nunitoRegular.copyWith(
        fontSize: 14.sp,
        color: AppColors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(context),
        SizedBox(height: 5.h),
        if (widget._isError && widget._errorText != null)
          _buildErrorText(widget._errorText!),
      ],
    );
  }
}
