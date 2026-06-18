import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;

  void Function()? onComplete;

  void Function()? onStart;

  void Function(String)? onError;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _flutterTts = FlutterTts();

    await _flutterTts!.setLanguage('en-US');
    await _flutterTts!.setSpeechRate(0.5);
    await _flutterTts!.setVolume(1.0);
    await _flutterTts!.setPitch(1.15);

    _flutterTts!.setCompletionHandler(() {
      onComplete?.call();
    });

    _flutterTts!.setStartHandler(() {
      onStart?.call();
    });

    _flutterTts!.setErrorHandler((message) {
      onError?.call(message.toString());
    });

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized || _flutterTts == null) {
      throw StateError('TTS not initialized. Call initialize() first.');
    }
    final result = await _flutterTts!.speak(text);
    if (result != 1) {
      throw Exception('TTS speak failed with result: $result');
    }
  }

  Future<void> stop() async {
    if (_flutterTts != null) {
      await _flutterTts!.stop();
    }
  }

  Future<void> dispose() async {
    onComplete = null;
    onStart = null;
    onError = null;
    if (_flutterTts != null) {
      await _flutterTts!.stop();
      _isInitialized = false;
      _flutterTts = null;
    }
  }
}
