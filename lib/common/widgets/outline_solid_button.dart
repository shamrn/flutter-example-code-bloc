import 'package:finance_mobile/common/ui/app_colors.dart';
import 'package:finance_mobile/common/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutlineSolidButton extends StatelessWidget {
  const OutlineSolidButton({
    required String title,
    required VoidCallback onTap,
    bool isEnabled = true,
    bool isLoading = false,
    super.key,
  })  : _title = title,
        _onTap = onTap,
        _isEnabled = isEnabled,
        _isLoading = isLoading;

  final String _title;
  final VoidCallback _onTap;
  final bool _isEnabled;
  final bool _isLoading;

  bool get isEnabled => _isEnabled && !_isLoading;

  void _onTapButton() {
    HapticFeedback.lightImpact();
    _onTap();
  }

  Widget _buildTitleOrLoader() {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator(
        color: AppColors.white,
        strokeWidth: 2.5.w,
      )
          : Text(
        _title,
        style: AppTextStyles.nunitoMedium.copyWith(
          color: AppColors.white,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isEnabled ? 1.0 : 0.3,
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(32.r),
        child: InkWell(
          onTap: isEnabled ? _onTapButton : null,
          splashFactory: InkRipple.splashFactory,
          splashColor: AppColors.darkAccent,
          highlightColor: AppColors.mediumAccent,
          borderRadius: BorderRadius.circular(32.r),
          child: Ink(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.r),
              color: AppColors.accent,
            ),
            child: _buildTitleOrLoader(),
          ),
        ),
      ),
    );
  }
}
