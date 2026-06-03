/// Smoking-recovery facts. Sourced — do not invent figures.
///
/// Sources:
///  - American Cancer Society, "Health Benefits of Quitting Smoking Over Time"
///    https://www.cancer.org/cancer/risk-prevention/tobacco/guide-quitting-smoking/benefits-of-quitting-smoking-over-time.html
///  - NHS, "What happens when you quit smoking?" / US Surgeon General
///    (short-term markers: heart rate/blood pressure 20 min, carbon monoxide,
///     smell & taste, breathing).
///
/// Honest framing: short-term recovery happens *within a single clean stint*
/// and resets with each cigarette; the long-term benefits require staying
/// smoke-free, so they're shown as goals, not as achieved progress.
library;

class RecoveryMarker {
  const RecoveryMarker({
    required this.timeLabel,
    required this.title,
    required this.detail,
    this.stintTime,
  });

  final String timeLabel;

  /// Non-null for per-stint markers — progress is measured against the current
  /// clean stint. Null markers are long-term goals.
  final Duration? stintTime;

  final String title;
  final String detail;
}

/// Recovery within a clean stint (resets with each cigarette).
const List<RecoveryMarker> kStintRecovery = [
  RecoveryMarker(
    timeLabel: '20 Min',
    stintTime: Duration(minutes: 20),
    title: 'Puls & Blutdruck',
    detail: 'sinken wieder Richtung Normalwerte.',
  ),
  RecoveryMarker(
    timeLabel: '8 Std',
    stintTime: Duration(hours: 8),
    title: 'Kohlenmonoxid',
    detail: 'im Blut sinkt, der Sauerstoff steigt.',
  ),
  RecoveryMarker(
    timeLabel: '24 Std',
    stintTime: Duration(hours: 24),
    title: 'Nikotin',
    detail: 'beginnt deinen Körper zu verlassen.',
  ),
  RecoveryMarker(
    timeLabel: '48 Std',
    stintTime: Duration(hours: 48),
    title: 'Geschmack & Geruch',
    detail: 'Nervenenden erholen sich, die Sinne kommen zurück.',
  ),
  RecoveryMarker(
    timeLabel: '72 Std',
    stintTime: Duration(hours: 72),
    title: 'Atmung',
    detail: 'Bronchien entspannen, Atmen fällt leichter.',
  ),
];

/// Long-term benefits — only when you stay smoke-free.
const List<RecoveryMarker> kLongTermRecovery = [
  RecoveryMarker(
    timeLabel: '2 Wo – 3 Mon',
    title: 'Durchblutung & Lunge',
    detail: 'Kreislauf und Lungenfunktion verbessern sich.',
  ),
  RecoveryMarker(
    timeLabel: '1 – 12 Mon',
    title: 'Husten lässt nach',
    detail: 'Husten und Kurzatmigkeit gehen zurück.',
  ),
  RecoveryMarker(
    timeLabel: '1 – 2 Jahre',
    title: 'Herzinfarkt-Risiko',
    detail: 'sinkt deutlich.',
  ),
  RecoveryMarker(
    timeLabel: '5 – 10 Jahre',
    title: 'Krebs & Schlaganfall',
    detail: 'Risiko für Mund-/Rachen-/Kehlkopfkrebs halbiert sich, '
        'Schlaganfall-Risiko sinkt.',
  ),
  RecoveryMarker(
    timeLabel: '10 Jahre',
    title: 'Lungenkrebs-Risiko',
    detail: 'etwa halb so hoch wie bei Weiterrauchen.',
  ),
  RecoveryMarker(
    timeLabel: '15 Jahre',
    title: 'Herzkrankheit',
    detail: 'Risiko nahe dem einer Person, die nie geraucht hat.',
  ),
];
