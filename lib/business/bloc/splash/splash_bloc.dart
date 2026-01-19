import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
    on<SplashAnimationCompleted>(_onSplashAnimationCompleted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    // Simulate initialization delay
    await Future.delayed(const Duration(milliseconds: 100));
    emit(
      const SplashAnimating(
        scooterOpacity: 0.0,
        scooterOffset: 100.0,
        textOpacity: 0.0,
        textScale: 0.8,
        waveOffset: 0.0,
      ),
    );
  }

  Future<void> _onSplashAnimationCompleted(
    SplashAnimationCompleted event,
    Emitter<SplashState> emit,
  ) async {
    // Wait for splash duration
    await Future.delayed(AppConstants.splashDuration);
    emit(const SplashCompleted());
  }
}

