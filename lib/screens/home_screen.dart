import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../providers/audio_provider.dart';
import '../providers/ui_provider.dart';
import '../widgets/buddy_widget.dart';
import '../widgets/story_card.dart';
import '../widgets/read_story_button.dart';
import '../widgets/quiz_card.dart';
import '../widgets/success_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UIProviderState>(uiProvider, (prev, next) {
      if (next.showConfetti && !(prev?.showConfetti ?? false)) {
        _confettiController.play();
      }
      if (!next.showConfetti && (prev?.showConfetti ?? false)) {
        _confettiController.stop();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            _buildMainContent(),

            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: 25,
                maxBlastForce: 30,
                minBlastForce: 10,
                emissionFrequency: 0.06,
                gravity: 0.15,
                colors: const [
                  AppColors.primary,
                  AppColors.secondary,
                  AppColors.accent,
                  AppColors.success,
                  Color(0xFF00BCD4),
                  Color(0xFFE91E63),
                ],
                createParticlePath: (size) {
                  final path = Path();
                  final random = Random();
                  if (random.nextBool()) {
                    final halfWidth = size.width / 2;
                    final halfHeight = size.height / 2;
                    path.moveTo(halfWidth, 0);
                    path.lineTo(halfWidth + halfWidth * 0.3, halfHeight * 0.6);
                    path.lineTo(size.width, halfHeight);
                    path.lineTo(
                      halfWidth + halfWidth * 0.4,
                      halfHeight + halfHeight * 0.3,
                    );
                    path.lineTo(halfWidth + halfWidth * 0.2, size.height);
                    path.lineTo(halfWidth, halfHeight + halfHeight * 0.5);
                    path.lineTo(halfWidth - halfWidth * 0.2, size.height);
                    path.lineTo(
                      halfWidth - halfWidth * 0.4,
                      halfHeight + halfHeight * 0.3,
                    );
                    path.lineTo(0, halfHeight);
                    path.lineTo(halfWidth - halfWidth * 0.3, halfHeight * 0.6);
                    path.close();
                  } else {
                    path.addOval(
                      Rect.fromCircle(
                        center: Offset(size.width / 2, size.height / 2),
                        radius: size.width / 2,
                      ),
                    );
                  }
                  return path;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLG,
        vertical: AppDimensions.paddingMD,
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.paddingSM),
          const BuddyWidget(),
          const SizedBox(height: AppDimensions.paddingMD),

          const StoryCard(),
          const SizedBox(height: AppDimensions.paddingLG),

          _buildBottomSection(),
          const SizedBox(height: AppDimensions.paddingXL),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    final audioState = ref.watch(audioProvider);
    final screenPhase = ref.watch(uiProvider.select((s) => s.screenPhase));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: child,
          ),
        );
      },
      child: _buildCurrentPhase(audioState, screenPhase),
    );
  }

  Widget _buildCurrentPhase(
    AudioProviderState audioState,
    ScreenPhase screenPhase,
  ) {
    if (audioState.state == AudioState.error) {
      return const StoryErrorWidget(key: ValueKey('error'));
    }

    if (audioState.state == AudioState.loading) {
      return const LoadingWidget(key: ValueKey('loading'));
    }

    switch (screenPhase) {
      case ScreenPhase.story:
        return const ReadStoryButton(key: ValueKey('read_button'));

      case ScreenPhase.quiz:
        return const QuizCard(key: ValueKey('quiz'));

      case ScreenPhase.success:
        return const SuccessWidget(key: ValueKey('success'));
    }
  }
}
