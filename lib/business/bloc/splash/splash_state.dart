part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashAnimating extends SplashState {
  final double scooterOpacity;
  final double scooterOffset;
  final double textOpacity;
  final double textScale;
  final double waveOffset;

  const SplashAnimating({
    required this.scooterOpacity,
    required this.scooterOffset,
    required this.textOpacity,
    required this.textScale,
    required this.waveOffset,
  });

  @override
  List<Object> get props => [
        scooterOpacity,
        scooterOffset,
        textOpacity,
        textScale,
        waveOffset,
      ];
}

class SplashCompleted extends SplashState {
  const SplashCompleted();
}

