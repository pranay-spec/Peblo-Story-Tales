import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ScreenPhase { story, quiz, success }

enum BuddyAnimationState { idle, narrating, happy, celebrating }

class UIProviderState {
  final ScreenPhase screenPhase;

  final BuddyAnimationState buddyState;

  final bool isStoryHighlighted;

  final bool showConfetti;

  const UIProviderState({
    this.screenPhase = ScreenPhase.story,
    this.buddyState = BuddyAnimationState.idle,
    this.isStoryHighlighted = false,
    this.showConfetti = false,
  });

  UIProviderState copyWith({
    ScreenPhase? screenPhase,
    BuddyAnimationState? buddyState,
    bool? isStoryHighlighted,
    bool? showConfetti,
  }) {
    return UIProviderState(
      screenPhase: screenPhase ?? this.screenPhase,
      buddyState: buddyState ?? this.buddyState,
      isStoryHighlighted: isStoryHighlighted ?? this.isStoryHighlighted,
      showConfetti: showConfetti ?? this.showConfetti,
    );
  }
}

class UINotifier extends StateNotifier<UIProviderState> {
  UINotifier() : super(const UIProviderState());

  void onNarrationStart() {
    state = state.copyWith(
      buddyState: BuddyAnimationState.narrating,
      isStoryHighlighted: true,
    );
  }

  void onNarrationComplete() {
    state = state.copyWith(
      screenPhase: ScreenPhase.quiz,
      buddyState: BuddyAnimationState.happy,
      isStoryHighlighted: false,
    );
  }

  void onCorrectAnswer() {
    state = state.copyWith(
      screenPhase: ScreenPhase.success,
      buddyState: BuddyAnimationState.celebrating,
      showConfetti: true,
    );
  }

  void stopConfetti() {
    state = state.copyWith(showConfetti: false);
  }

  void reset() {
    state = const UIProviderState();
  }
}

final uiProvider = StateNotifierProvider<UINotifier, UIProviderState>((ref) {
  return UINotifier();
});
