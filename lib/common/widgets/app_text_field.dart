import 'package:finance_mobile/common/extensions/theme_extension.dart';
import 'package:finance_mobile/common/ui/app_colors.dart';
import 'package:finance_mobile/common/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required String label,
    TextEditingController? controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? textInputFormatters,
    FocusNode? currentFocusNode,
    FocusNode? nextFocusNode,
    String? errorText,
    bool isError = false,
    super.key,
  })  : _label = label,
        _controller = controller,
        _keyboardType = keyboardType,
        _textInputFormatters = textInputFormatters,
        _currentFocusNode = currentFocusNode,
        _nextFocusNode = nextFocusNode,
        _errorText = errorText,
        _isError = isError;

  final String _label;
  final TextEditingController? _controller;
  final TextInputType? _keyboardType;
  final List<TextInputFormatter>? _textInputFormatters;
  final FocusNode? _currentFocusNode;
  final FocusNode? _nextFocusNode;
  final String? _errorText;
  final bool _isError;

  void _onFieldSubmitted(BuildContext context) {
    if (_currentFocusNode != null && _nextFocusNode != null) {
      _currentFocusNode!.unfocus();
      FocusScope.of(context).requestFocus(_nextFocusNode);
    }
  }

  Widget _buildTextField(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            context.isDarkMode ? AppColors.transparentBlack : AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: _isError ? AppColors.red : AppColors.accent,
          width: 1.w,
        ),
      ),
      child: TextField(
        onSubmitted: (_) => _onFieldSubmitted(context),
        inputFormatters: _textInputFormatters,
        style: AppTextStyles.nunitoRegular.copyWith(fontSize: 16.sp),
        cursorColor: AppColors.accent,
        focusNode: _currentFocusNode,
        controller: _controller,
        keyboardType: _keyboardType,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 9.h,
          ),
          border: InputBorder.none,
          labelText: _label,
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
        if (_isError && _errorText != null) _buildErrorText(_errorText!),
      ],
    );
  }
}
