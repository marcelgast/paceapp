import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../services/notification_service.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../widgets/graffiti_tag.dart';
import '../../widgets/pace_wordmark.dart';
import '../../widgets/start_lights.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _pager = PageController();
  late final AnimationController _lights = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    value: 0.06,
  );

  final _price = TextEditingController(text: '8,00');
  final _perPack = TextEditingController(text: '20');
  final _perDay = TextEditingController(text: '15');

  TimeOfDay _sleepStart = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _sleepEnd = const TimeOfDay(hour: 7, minute: 0);

  int _step = 0;
  bool _launching = false;

  // Indexed by step: 0 welcome, 1-3 questions, 4 sleep, 5 measuring-week.
  static const _stepProgress = [0.06, 0.31, 0.46, 0.61, 0.68, 0.74];

  @override
  void dispose() {
    _pager.dispose();
    _lights.dispose();
    _price.dispose();
    _perPack.dispose();
    _perDay.dispose();
    super.dispose();
  }

  int? _priceCents() {
    final raw = _price.text.trim().replaceAll('.', '').replaceAll(',', '.');
    final value = double.tryParse(raw);
    if (value == null || value <= 0) return null;
    return (value * 100).round();
  }

  bool _validateStep(int step) {
    return switch (step) {
      1 => _priceCents() != null,
      2 => (int.tryParse(_perPack.text.trim()) ?? 0) > 0,
      3 => (int.tryParse(_perDay.text.trim()) ?? 0) > 0,
      _ => true, // welcome (0), sleep (4) and explainer (5) need no validation
    };
  }

  Future<void> _next() async {
    if (!_validateStep(_step)) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.onboardingInvalidValue)),
      );
      return;
    }
    HapticFeedback.lightImpact();

    if (_step < 5) {
      setState(() => _step++);
      if (_step == 4) {
        // Sleep page — no text field, drop the keyboard.
        FocusScope.of(context).unfocus();
        _lights.animateTo(_stepProgress[_step]);
      } else if (_step == 5) {
        // The staging tree is finally on screen — replay the amber cascade.
        FocusScope.of(context).unfocus();
        _playStagingTree();
      } else {
        _lights.animateTo(_stepProgress[_step]);
      }
      _pager.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
    } else {
      FocusScope.of(context).unfocus();
      await _launch();
    }
  }

  /// Slow drag-strip cascade, played when the staging tree first becomes
  /// visible. Each amber lights in turn with a beat between, instead of
  /// snapping through unseen behind the keyboard.
  void _playStagingTree() {
    _lights.value = 0.06;
    const stops = [0.31, 0.46, 0.61];
    for (var i = 0; i < stops.length; i++) {
      Future<void>.delayed(Duration(milliseconds: 650 + i * 900), () {
        if (!mounted || _step != 5 || _launching) return;
        _lights.animateTo(stops[i],
            duration: const Duration(milliseconds: 520), curve: Curves.easeOut);
      });
    }
  }

  void _back() {
    if (_step == 0) return;
    FocusScope.of(context).unfocus();
    setState(() => _step--);
    _pager.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Future<void> _pickSleep({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _sleepStart : _sleepEnd,
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _sleepStart = picked;
      } else {
        _sleepEnd = picked;
      }
    });
  }

  Future<void> _launch() async {
    setState(() => _launching = true);
    await _lights.animateTo(0.9, duration: const Duration(milliseconds: 700));
    HapticFeedback.heavyImpact();
    await ref.read(databaseProvider).saveOnboarding(
          packPriceCents: _priceCents()!,
          cigarettesPerPack: int.parse(_perPack.text.trim()),
          baselineCigsPerDay: int.parse(_perDay.text.trim()),
          startedAt: DateTime.now(),
          sleepStartMinutes: _sleepStart.hour * 60 + _sleepStart.minute,
          sleepEndMinutes: _sleepEnd.hour * 60 + _sleepEnd.minute,
        );
    await NotificationService.requestPermission();
    // Settings stream flips the gate to the cockpit.
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: RacetrackBackground(
        child: Stack(
          children: [
            // Decorative tags, tucked clear of the logo and content.
            const Positioned(
              left: -6,
              bottom: 96,
              child: GraffitiTag(
                  text: 'NO\nLIMITS',
                  color: PaceColors.neonCyan,
                  size: 30,
                  angle: -0.14,
                  opacity: 0.3),
            ),
            const Positioned(
              right: -4,
              top: 150,
              child: GraffitiTag(
                  text: 'FUEL THE\nSTREAK',
                  color: PaceColors.neonMagenta,
                  size: 24,
                  angle: 0.12,
                  opacity: 0.26),
            ),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: keyboardOpen ? 6 : 14),
                  PaceWordmark(size: keyboardOpen ? 44 : 66)
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: -0.3, curve: Curves.easeOut),
                  // Collapse the decorative header when typing so the
                  // question stays in view above the keyboard.
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: keyboardOpen
                        ? const SizedBox(width: double.infinity)
                        : Column(
                            children: [
                              const SizedBox(height: 4),
                              Text(l10n.onboardingTagline,
                                  style: TextStyle(
                                      color: PaceColors.textMuted, fontSize: 14)),
                              // The staging tree is the launch ritual — show it
                              // only on the measuring-week page.
                              if (_step == 5) ...[
                                const SizedBox(height: 16),
                                AnimatedBuilder(
                                  animation: _lights,
                                  builder: (_, _) =>
                                      StartLights(progress: _lights.value),
                                ),
                              ],
                            ],
                          ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: PageView(
                      controller: _pager,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _WelcomePage(onNext: _next),
                        _QuestionPage(
                          eyebrow: l10n.onboardingPitCheck1of3,
                          headline: l10n.onboardingPackPriceHeadline,
                          sub: l10n.onboardingPackPriceSub,
                          field: _BigField(
                              controller: _price,
                              suffix: '€',
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                              onSubmit: _next),
                          buttonLabel: l10n.onboardingNext,
                          onNext: _next,
                          onBack: _back,
                          launching: false,
                        ),
                        _QuestionPage(
                          eyebrow: l10n.onboardingPitCheck2of3,
                          headline: l10n.onboardingPerPackHeadline,
                          sub: l10n.onboardingPerPackSub,
                          field: _BigField(
                              controller: _perPack,
                              keyboardType: TextInputType.number,
                              onSubmit: _next),
                          buttonLabel: l10n.onboardingNext,
                          onNext: _next,
                          onBack: _back,
                          launching: false,
                        ),
                        _QuestionPage(
                          eyebrow: l10n.onboardingPitCheck3of3,
                          headline: l10n.onboardingPerDayHeadline,
                          sub: l10n.onboardingPerDaySub,
                          field: _BigField(
                              controller: _perDay,
                              keyboardType: TextInputType.number,
                              onSubmit: _next),
                          buttonLabel: l10n.onboardingNext,
                          onNext: _next,
                          onBack: _back,
                          launching: false,
                        ),
                        _SleepPage(
                          start: _sleepStart,
                          end: _sleepEnd,
                          onPickStart: () => _pickSleep(isStart: true),
                          onPickEnd: () => _pickSleep(isStart: false),
                          onNext: _next,
                          onBack: _back,
                        ),
                        _MeasureWeekPage(
                          onNext: _next,
                          onBack: _back,
                          launching: _launching,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionPage extends StatelessWidget {
  const _QuestionPage({
    required this.eyebrow,
    required this.headline,
    required this.sub,
    required this.field,
    required this.buttonLabel,
    required this.onNext,
    required this.onBack,
    required this.launching,
  });

  final String eyebrow;
  final String headline;
  final String sub;
  final Widget field;
  final String buttonLabel;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final bool launching;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 6, 28, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eyebrow,
              style: const TextStyle(
                  color: PaceColors.neonOrange,
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(headline,
              style: PaceTheme.dash(size: 30, weight: FontWeight.w800)
                  .copyWith(height: 1.05)),
          const SizedBox(height: 8),
          Text(sub,
              style: TextStyle(
                  color: PaceColors.textMuted, fontSize: 14, height: 1.4)),
          const SizedBox(height: 22),
          field,
          const Spacer(),
          Row(
            children: [
              if (onBack != null) ...[
                _BackButton(onTap: onBack!),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: _PrimaryButton(
                    label: launching ? l10n.onboardingCountdown : buttonLabel,
                    onTap: launching ? null : onNext),
              ),
            ],
          ),
        ],
      ).animate(key: ValueKey(eyebrow)).fadeIn(duration: 320.ms).slideX(
            begin: 0.15,
            curve: Curves.easeOutCubic,
            duration: 320.ms,
          ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 2, 28, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.onboardingWelcomeEyebrow,
                      style: const TextStyle(
                          color: PaceColors.neonOrange,
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(l10n.onboardingWelcomeHeadline,
                      style: PaceTheme.dash(size: 30, weight: FontWeight.w800)
                          .copyWith(height: 1.05)),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingWelcomeBody,
                    style: TextStyle(
                        color: PaceColors.textMuted, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 22),
                  _FeatureRow(
                    icon: Icons.insights,
                    color: PaceColors.neonCyan,
                    title: l10n.onboardingFeatureObserveTitle,
                    detail: l10n.onboardingFeatureObserveDetail,
                  ),
                  _FeatureRow(
                    icon: Icons.trending_up,
                    color: PaceColors.neonMagenta,
                    title: l10n.onboardingFeatureStretchTitle,
                    detail: l10n.onboardingFeatureStretchDetail,
                  ),
                  _FeatureRow(
                    icon: Icons.emoji_events,
                    color: PaceColors.neonLime,
                    title: l10n.onboardingFeatureCelebrateTitle,
                    detail: l10n.onboardingFeatureCelebrateDetail,
                  ),
                  _FeatureRow(
                    icon: Icons.air,
                    color: PaceColors.neonOrange,
                    title: l10n.onboardingFeatureEmergencyTitle,
                    detail: l10n.onboardingFeatureEmergencyDetail,
                    last: true,
                  ),
                  const SizedBox(height: 18),
                  Text(l10n.onboardingWelcomeClosing,
                      style: const TextStyle(
                          color: PaceColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _PrimaryButton(label: l10n.onboardingLetsGo, onTap: onNext),
        ],
      ).animate(key: const ValueKey('welcome')).fadeIn(duration: 320.ms).slideX(
            begin: 0.15,
            curve: Curves.easeOutCubic,
            duration: 320.ms,
          ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
    this.last = false,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String detail;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: color.withValues(alpha: 0.6)),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: PaceColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(detail,
                    style: TextStyle(
                        color: PaceColors.textMuted,
                        fontSize: 13,
                        height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepPage extends StatelessWidget {
  const _SleepPage({
    required this.start,
    required this.end,
    required this.onPickStart,
    required this.onPickEnd,
    required this.onNext,
    required this.onBack,
  });

  final TimeOfDay start;
  final TimeOfDay end;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final VoidCallback onNext;
  final VoidCallback onBack;

  static String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 6, 28, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.onboardingSleepEyebrow,
                      style: const TextStyle(
                          color: PaceColors.neonOrange,
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(l10n.onboardingSleepHeadline,
                      style: PaceTheme.dash(size: 30, weight: FontWeight.w800)
                          .copyWith(height: 1.05)),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingSleepBody,
                    style: TextStyle(
                        color: PaceColors.textMuted, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                          child: _TimeBox(
                              label: l10n.onboardingSleepFrom,
                              value: _fmt(start),
                              onTap: onPickStart)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _TimeBox(
                              label: l10n.onboardingSleepTo,
                              value: _fmt(end),
                              onTap: onPickEnd)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _BackButton(onTap: onBack),
              const SizedBox(width: 12),
              Expanded(
                  child: _PrimaryButton(
                      label: l10n.onboardingNext, onTap: onNext)),
            ],
          ),
        ],
      ).animate(key: const ValueKey('sleep')).fadeIn(duration: 320.ms).slideX(
            begin: 0.15,
            curve: Curves.easeOutCubic,
            duration: 320.ms,
          ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox(
      {required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: PaceColors.panel.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PaceColors.neonCyan.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(color: PaceColors.textMuted, fontSize: 12)),
            const SizedBox(height: 6),
            Text(value,
                style: PaceTheme.dash(
                    size: 34,
                    weight: FontWeight.w800,
                    color: PaceColors.neonCyan)),
          ],
        ),
      ),
    );
  }
}

class _MeasureWeekPage extends StatelessWidget {
  const _MeasureWeekPage({
    required this.onNext,
    required this.onBack,
    required this.launching,
  });

  final VoidCallback onNext;
  final VoidCallback onBack;
  final bool launching;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 6, 28, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.onboardingMeasureEyebrow,
                      style: const TextStyle(
                          color: PaceColors.neonOrange,
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(l10n.onboardingMeasureHeadline,
                      style: PaceTheme.dash(size: 30, weight: FontWeight.w800)
                          .copyWith(height: 1.05)),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingMeasureBody,
                    style: TextStyle(
                        color: PaceColors.textMuted, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 22),
                  _StepRow(
                    number: '1',
                    color: PaceColors.neonCyan,
                    title: l10n.onboardingStepMeasureTitle,
                    detail: l10n.onboardingStepMeasureDetail,
                  ),
                  _StepRow(
                    number: '2',
                    color: PaceColors.neonMagenta,
                    title: l10n.onboardingStepTargetTitle,
                    detail: l10n.onboardingStepTargetDetail,
                  ),
                  _StepRow(
                    number: '3',
                    color: PaceColors.neonLime,
                    title: l10n.onboardingStepRaceTitle,
                    detail: l10n.onboardingStepRaceDetail,
                    last: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _BackButton(onTap: onBack),
              const SizedBox(width: 12),
              Expanded(
                child: _PrimaryButton(
                    label: launching
                        ? l10n.onboardingCountdown
                        : l10n.onboardingStartMeasuringLap,
                    onTap: launching ? null : onNext),
              ),
            ],
          ),
        ],
      ).animate(key: const ValueKey('measure-week')).fadeIn(duration: 320.ms).slideX(
            begin: 0.15,
            curve: Curves.easeOutCubic,
            duration: 320.ms,
          ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.color,
    required this.title,
    required this.detail,
    this.last = false,
  });

  final String number;
  final Color color;
  final String title;
  final String detail;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.7)),
            ),
            child: Text(number,
                style: PaceTheme.dash(
                    size: 18, weight: FontWeight.w800, color: color)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: PaceColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(detail,
                    style: TextStyle(
                        color: PaceColors.textMuted,
                        fontSize: 13,
                        height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BigField extends StatelessWidget {
  const _BigField({
    required this.controller,
    required this.keyboardType,
    required this.onSubmit,
    this.suffix,
  });

  final TextEditingController controller;
  final TextInputType keyboardType;
  final VoidCallback onSubmit;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      autofocus: true,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => onSubmit(),
      style: PaceTheme.dash(size: 44, weight: FontWeight.w800),
      decoration: InputDecoration(
        filled: true,
        fillColor: PaceColors.panel.withValues(alpha: 0.85),
        suffixText: suffix,
        suffixStyle: PaceTheme.dash(size: 34, color: PaceColors.neonCyan),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: PaceColors.chrome.withValues(alpha: 0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: PaceColors.neonCyan, width: 2),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: PaceColors.underglow),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: PaceColors.neonMagenta.withValues(alpha: 0.45),
                blurRadius: 24,
                offset: const Offset(0, 6)),
          ],
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: Colors.white)),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
          duration: 2400.ms,
          color: Colors.white.withValues(alpha: 0.16),
        );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: PaceColors.panel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PaceColors.chrome),
        ),
        child: const Icon(Icons.arrow_back, color: PaceColors.textMuted),
      ),
    );
  }
}
