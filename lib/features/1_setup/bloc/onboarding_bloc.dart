import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final Future<bool> Function() hasSeenOnboarding;
  final Future<void> Function() markSeen;

  OnboardingBloc({
    required this.hasSeenOnboarding,
    required this.markSeen,
  }) : super(const OnboardingState(OnboardingStep.splash)) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingCompleted>(_onCompleted);
  }

  Future<void> _onStarted(OnboardingStarted e, Emitter emit) async {
    final seen = await hasSeenOnboarding();
    emit(seen
        ? const OnboardingState(OnboardingStep.done)
        : const OnboardingState(OnboardingStep.onboarding));
  }

  Future<void> _onCompleted(OnboardingCompleted e, Emitter emit) async {
    await markSeen();
    emit(const OnboardingState(OnboardingStep.done));
  }
}
