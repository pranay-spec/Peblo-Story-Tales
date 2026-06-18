import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import '../providers/ui_provider.dart';

class BuddyWidget extends ConsumerWidget {
  const BuddyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buddyState = ref.watch(uiProvider.select((s) => s.buddyState));

    return RepaintBoundary(
      child: SizedBox(
        width: AppDimensions.buddySizeLarge,
        height: AppDimensions.buddySizeLarge,
        child: _buildBuddy(buddyState),
      ),
    );
  }

  Widget _buildBuddy(BuddyAnimationState buddyState) {
    return _AnimatedBuddyBody(buddyState: buddyState);
  }
}

class _AnimatedBuddyBody extends StatelessWidget {
  final BuddyAnimationState buddyState;

  const _AnimatedBuddyBody({required this.buddyState});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SpeechBubble(buddyState: buddyState),
        const SizedBox(height: 4),

        Expanded(child: _buildRobotWithAnimation()),
      ],
    );
  }

  Widget _buildRobotWithAnimation() {
    Widget robot = const _RobotCharacter();

    switch (buddyState) {
      case BuddyAnimationState.idle:
        return robot
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(
              begin: 0,
              end: -6,
              duration: 1500.ms,
              curve: Curves.easeInOut,
            );

      case BuddyAnimationState.narrating:
        return robot
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.05, 1.05),
              duration: 600.ms,
            )
            .then()
            .scale(
              begin: const Offset(1.05, 1.05),
              end: const Offset(1.0, 1.0),
              duration: 600.ms,
            );

      case BuddyAnimationState.happy:
        return robot
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .rotate(
              begin: -0.03,
              end: 0.03,
              duration: 500.ms,
              curve: Curves.easeInOut,
            );

      case BuddyAnimationState.celebrating:
        return robot
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: -12, duration: 400.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.1, 1.1),
              duration: 400.ms,
            );
    }
  }
}

class _SpeechBubble extends StatelessWidget {
  final BuddyAnimationState buddyState;

  const _SpeechBubble({required this.buddyState});

  String get _message {
    switch (buddyState) {
      case BuddyAnimationState.idle:
        return AppStrings.buddyGreeting;
      case BuddyAnimationState.narrating:
        return AppStrings.buddyNarrating;
      case BuddyAnimationState.happy:
        return AppStrings.buddyQuizTime;
      case BuddyAnimationState.celebrating:
        return AppStrings.buddyCelebrating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: Container(
        key: ValueKey(buddyState),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMD,
          vertical: AppDimensions.paddingSM,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          border: Border.all(color: AppColors.border, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          _message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _RobotCharacter extends StatelessWidget {
  const _RobotCharacter();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RobotPainter(),
      size: const Size(AppDimensions.buddySize, AppDimensions.buddySize),
    );
  }
}

class _RobotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final unit = size.width / 10;

    final antennaPaint = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = unit * 0.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(centerX, centerY - unit * 2.5),
      Offset(centerX, centerY - unit * 3.8),
      antennaPaint,
    );

    final tipPaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(centerX, centerY - unit * 4),
      unit * 0.5,
      tipPaint,
    );

    final glowPaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(centerX, centerY - unit * 4),
      unit * 0.8,
      glowPaint,
    );

    final headPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final headRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY - unit * 1.2),
        width: unit * 5.5,
        height: unit * 4.5,
      ),
      Radius.circular(unit * 1.5),
    );
    canvas.drawRRect(headRect, headPaint);

    final highlightPaint = Paint()
      ..color = AppColors.primaryLight.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    final highlightRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY - unit * 1.8),
        width: unit * 4.5,
        height: unit * 1.5,
      ),
      Radius.circular(unit),
    );
    canvas.drawRRect(highlightRect, highlightPaint);

    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - unit * 1.2, centerY - unit * 1.3),
        width: unit * 1.6,
        height: unit * 1.8,
      ),
      eyeWhitePaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + unit * 1.2, centerY - unit * 1.3),
        width: unit * 1.6,
        height: unit * 1.8,
      ),
      eyeWhitePaint,
    );

    final pupilPaint = Paint()
      ..color = const Color(0xFF2D2D2D)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX - unit * 1.1, centerY - unit * 1.2),
      unit * 0.5,
      pupilPaint,
    );
    canvas.drawCircle(
      Offset(centerX + unit * 1.3, centerY - unit * 1.2),
      unit * 0.5,
      pupilPaint,
    );

    final sparklePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(centerX - unit * 0.9, centerY - unit * 1.4),
      unit * 0.18,
      sparklePaint,
    );
    canvas.drawCircle(
      Offset(centerX + unit * 1.5, centerY - unit * 1.4),
      unit * 0.18,
      sparklePaint,
    );

    final smilePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = unit * 0.3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final smilePath = Path()
      ..moveTo(centerX - unit * 0.8, centerY - unit * 0.3)
      ..quadraticBezierTo(
        centerX,
        centerY + unit * 0.4,
        centerX + unit * 0.8,
        centerY - unit * 0.3,
      );
    canvas.drawPath(smilePath, smilePaint);

    final cheekPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - unit * 2, centerY - unit * 0.5),
        width: unit * 1.0,
        height: unit * 0.6,
      ),
      cheekPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + unit * 2, centerY - unit * 0.5),
        width: unit * 1.0,
        height: unit * 0.6,
      ),
      cheekPaint,
    );

    final bodyPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY + unit * 2.5),
        width: unit * 4.5,
        height: unit * 3.5,
      ),
      Radius.circular(unit * 1.2),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    final bodyHighlightRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY + unit * 1.8),
        width: unit * 3.5,
        height: unit * 1.0,
      ),
      Radius.circular(unit * 0.5),
    );
    canvas.drawRRect(bodyHighlightRect, highlightPaint);

    final heartPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.fill;

    final heartPath = Path();
    final hx = centerX;
    final hy = centerY + unit * 2.5;
    final hs = unit * 0.45;
    heartPath.moveTo(hx, hy + hs);
    heartPath.cubicTo(
      hx - hs * 2,
      hy - hs * 0.5,
      hx - hs * 1.2,
      hy - hs * 1.8,
      hx,
      hy - hs * 0.8,
    );
    heartPath.cubicTo(
      hx + hs * 1.2,
      hy - hs * 1.8,
      hx + hs * 2,
      hy - hs * 0.5,
      hx,
      hy + hs,
    );
    canvas.drawPath(heartPath, heartPaint);

    final armPaint = Paint()
      ..color = AppColors.primaryLight
      ..strokeWidth = unit * 0.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(centerX - unit * 2.25, centerY + unit * 1.8),
      Offset(centerX - unit * 3.2, centerY + unit * 2.8),
      armPaint,
    );

    canvas.drawCircle(
      Offset(centerX - unit * 3.2, centerY + unit * 2.8),
      unit * 0.35,
      Paint()..color = AppColors.secondary,
    );

    canvas.drawLine(
      Offset(centerX + unit * 2.25, centerY + unit * 1.8),
      Offset(centerX + unit * 3.2, centerY + unit * 2.8),
      armPaint,
    );

    canvas.drawCircle(
      Offset(centerX + unit * 3.2, centerY + unit * 2.8),
      unit * 0.35,
      Paint()..color = AppColors.secondary,
    );

    final feetPaint = Paint()
      ..color = AppColors.primaryDark
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX - unit * 1, centerY + unit * 4.4),
          width: unit * 1.6,
          height: unit * 0.8,
        ),
        Radius.circular(unit * 0.4),
      ),
      feetPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX + unit * 1, centerY + unit * 4.4),
          width: unit * 1.6,
          height: unit * 0.8,
        ),
        Radius.circular(unit * 0.4),
      ),
      feetPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
