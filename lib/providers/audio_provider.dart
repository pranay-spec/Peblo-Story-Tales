import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/tts_service.dart';
import '../core/constants/app_strings.dart';

enum AudioState { idle, loading, playing, completed, error }

class AudioProviderState {
  final AudioState state;
  final String? errorMessage;

  const AudioProviderState({this.state = AudioState.idle, this.errorMessage});

  AudioProviderState copyWith({AudioState? state, String? errorMessage}) {
    return AudioProviderState(
      state: state ?? this.state,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() =>
      'AudioProviderState(state: $state, error: $errorMessage)';
}

class AudioNotifier extends StateNotifier<AudioProviderState> {
  AudioNotifier() : super(const AudioProviderState());

  final TtsService _ttsService = TtsService();

  void Function()? onNarrationComplete;

  Future<void> startNarration() async {
    if (state.state == AudioState.loading ||
        state.state == AudioState.playing) {
      return;
    }

    state = const AudioProviderState(state: AudioState.loading);

    try {
      await _ttsService.initialize();

      _ttsService.onComplete = () {
        if (mounted) {
          state = const AudioProviderState(state: AudioState.completed);
          onNarrationComplete?.call();
        }
      };

      _ttsService.onStart = () {
        if (mounted) {
          state = const AudioProviderState(state: AudioState.playing);
        }
      };

      _ttsService.onError = (error) {
        if (mounted) {
          state = AudioProviderState(
            state: AudioState.error,
            errorMessage: AppStrings.errorMessage,
          );
        }
      };

      await _ttsService.speak(AppStrings.storyText);

      if (mounted && state.state == AudioState.loading) {
        state = const AudioProviderState(state: AudioState.playing);
      }
    } catch (e) {
      if (mounted) {
        state = AudioProviderState(
          state: AudioState.error,
          errorMessage: AppStrings.errorMessage,
        );
      }
    }
  }

  Future<void> stopNarration() async {
    await _ttsService.stop();
    if (mounted) {
      state = const AudioProviderState(state: AudioState.idle);
    }
  }

  void reset() {
    state = const AudioProviderState(state: AudioState.idle);
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioProviderState>((
  ref,
) {
  return AudioNotifier();
});
