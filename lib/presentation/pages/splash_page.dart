import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import '../../business/bloc/splash/splash_bloc.dart';
import '../widgets/wave_painter.dart';
import 'dashboard_page.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _scooterController;
  late AnimationController _textController;
  late AnimationController _waveController;

  late Animation<double> _scooterOpacityAnimation;
  late Animation<double> _scooterOffsetAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(const SplashStarted());

    // Scooter animation (fade in + slide from right)
    _scooterController = AnimationController(
      duration: AppConstants.scooterAnimationDuration,
      vsync: this,
    );

    _scooterOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scooterController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _scooterOffsetAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _scooterController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Text animation (fade in + scale)
    _textController = AnimationController(
      duration: AppConstants.textAnimationDuration,
      vsync: this,
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
      ),
    );

    _textScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Wave animation (continuous movement)
    _waveController = AnimationController(
      duration: AppConstants.waveAnimationDuration,
      vsync: this,
    )..repeat();

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _waveController, curve: Curves.linear));

    // Start animations
    _scooterController.forward();
    Future.delayed(AppConstants.textAnimationDelay, () {
      _textController.forward();
    });
    _waveController.forward();

    // Complete splash after duration
    Future.delayed(AppConstants.splashDuration, () {
      if (mounted) {
        context.read<SplashBloc>().add(const SplashAnimationCompleted());
      }
    });
  }

  @override
  void dispose() {
    _scooterController.dispose();
    _textController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardPage()),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Wavy red section at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _waveAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height * 0.33,
                    ),
                    painter: WavePainter(waveOffset: _waveAnimation.value),
                  );
                },
              ),
            ),

            // Main content (scooter + text)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Scooter with animation
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _scooterOpacityAnimation,
                      _scooterOffsetAnimation,
                    ]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_scooterOffsetAnimation.value, 0),
                        child: Opacity(
                          opacity: _scooterOpacityAnimation.value,
                          child: Image.asset(
                            'assets/images/scooter.png',
                            width: 220,
                            height: 160,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if image not found
                              return SizedBox(
                                width: 220,
                                height: 160,
                                child: Icon(
                                  Icons.two_wheeler,
                                  size: 100,
                                  color: AppColors.coralRed,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // eFood text with animation
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _textOpacityAnimation,
                      _textScaleAnimation,
                    ]),
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textOpacityAnimation.value,
                        child: Transform.scale(
                          scale: _textScaleAnimation.value,
                          child: _buildEFoodText(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEFoodText() {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // "e" with cloche icon
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Text(
              'e',
              style: TextStyle(
                fontSize: 76,
                fontWeight: FontWeight.bold,
                color: AppColors.coralText,
                fontFamily: 'Roboto',
                letterSpacing: 0,
                height: 1.0,
              ),
            ),
            Positioned(
              top: -8,
              child: Icon(
                Icons.restaurant_menu,
                color: scheme.onSurface,
                size: 32,
              ),
            ),
          ],
        ),
        // "Food"
        Text(
          'Food',
          style: TextStyle(
            fontSize: 76,
            fontWeight: FontWeight.bold,
            color: AppColors.orangeRed,
            fontFamily: 'Roboto',
            letterSpacing: 0,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
