import 'package:finance_mobile/common/extensions/theme_extension.dart';
import 'package:finance_mobile/common/ui/app_colors.dart';
import 'package:finance_mobile/common/widgets/logo_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderSemiCircleWithLogo extends StatefulWidget {
  const HeaderSemiCircleWithLogo({super.key});

  @override
  State<HeaderSemiCircleWithLogo> createState() =>
      _HeaderSemiCircleWithLogoState();
}

class _HeaderSemiCircleWithLogoState extends State<HeaderSemiCircleWithLogo>
    with TickerProviderStateMixin {
  late AnimationController _semiCircleAnimationController;

  @override
  void initState() {
    super.initState();

    _semiCircleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5600),
    )..repeat(min: 0.8, max: 1.0, reverse: true);
  }

  @override
  void dispose() {
    _semiCircleAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AnimatedBuilder(
          animation: _semiCircleAnimationController,
          builder: (_, __) => ClipPath(
            clipper: SemiCircleClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200.h * _semiCircleAnimationController.value,
              color:
                  context.isDarkMode ? AppColors.accent : AppColors.lightBlue,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 26.h),
            child: const LogoText(),
          ),
        ),
      ],
    );
  }
}

class SemiCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height / 2)
      ..quadraticBezierTo(
        size.width / 2,
        size.height,
        size.width,
        size.height / 2,
      )
      ..lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
