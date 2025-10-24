// onboarding_state.dart
part of 'onboarding_bloc.dart';

enum OnboardingStep { splash, onboarding, done }

class OnboardingState extends Equatable {
  final OnboardingStep step;
  const OnboardingState(this.step);

  @override
  List<Object?> get props => [step];

  static const splash = OnboardingState(OnboardingStep.splash);
  static const onboarding = OnboardingState(OnboardingStep.onboarding);
  static const done = OnboardingState(OnboardingStep.done);
}
