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
    required this.timeLabelEn,
    required this.titleEn,
    required this.detailEn,
    this.stintTime,
  });

  final String timeLabel;

  /// Non-null for per-stint markers — progress is measured against the current
  /// clean stint. Null markers are long-term goals.
  final Duration? stintTime;

  final String title;
  final String detail;
  final String timeLabelEn;
  final String titleEn;
  final String detailEn;

  String localizedTitle(String lang) => lang == 'en' ? titleEn : title;
  String localizedDetail(String lang) => lang == 'en' ? detailEn : detail;
  String localizedTimeLabel(String lang) =>
      lang == 'en' ? timeLabelEn : timeLabel;
}

/// Recovery within a clean stint (resets with each cigarette).
const List<RecoveryMarker> kStintRecovery = [
  RecoveryMarker(
    timeLabel: '20 Min',
    stintTime: Duration(minutes: 20),
    title: 'Puls & Blutdruck',
    detail: 'sinken wieder Richtung Normalwerte.',
    timeLabelEn: '20 min',
    titleEn: 'Heart Rate & Blood Pressure',
    detailEn: 'drop back toward normal levels.',
  ),
  RecoveryMarker(
    timeLabel: '8 Std',
    stintTime: Duration(hours: 8),
    title: 'Kohlenmonoxid',
    detail: 'im Blut sinkt, der Sauerstoff steigt.',
    timeLabelEn: '8 h',
    titleEn: 'Carbon Monoxide',
    detailEn: 'in your blood drops, oxygen rises.',
  ),
  RecoveryMarker(
    timeLabel: '24 Std',
    stintTime: Duration(hours: 24),
    title: 'Nikotin',
    detail: 'beginnt deinen Körper zu verlassen.',
    timeLabelEn: '24 h',
    titleEn: 'Nicotine',
    detailEn: 'starts leaving your body.',
  ),
  RecoveryMarker(
    timeLabel: '48 Std',
    stintTime: Duration(hours: 48),
    title: 'Geschmack & Geruch',
    detail: 'Nervenenden erholen sich, die Sinne kommen zurück.',
    timeLabelEn: '48 h',
    titleEn: 'Taste & Smell',
    detailEn: 'nerve endings recover, your senses come back.',
  ),
  RecoveryMarker(
    timeLabel: '72 Std',
    stintTime: Duration(hours: 72),
    title: 'Atmung',
    detail: 'Bronchien entspannen, Atmen fällt leichter.',
    timeLabelEn: '72 h',
    titleEn: 'Breathing',
    detailEn: 'bronchial tubes relax, breathing gets easier.',
  ),
];

/// Long-term benefits — only when you stay smoke-free.
const List<RecoveryMarker> kLongTermRecovery = [
  RecoveryMarker(
    timeLabel: '2 Wo – 3 Mon',
    title: 'Durchblutung & Lunge',
    detail: 'Kreislauf und Lungenfunktion verbessern sich.',
    timeLabelEn: '2 wk – 3 mo',
    titleEn: 'Circulation & Lungs',
    detailEn: 'circulation and lung function improve.',
  ),
  RecoveryMarker(
    timeLabel: '1 – 12 Mon',
    title: 'Husten lässt nach',
    detail: 'Husten und Kurzatmigkeit gehen zurück.',
    timeLabelEn: '1 – 12 mo',
    titleEn: 'Coughing Eases',
    detailEn: 'coughing and shortness of breath recede.',
  ),
  RecoveryMarker(
    timeLabel: '1 – 2 Jahre',
    title: 'Herzinfarkt-Risiko',
    detail: 'sinkt deutlich.',
    timeLabelEn: '1 – 2 yrs',
    titleEn: 'Heart Attack Risk',
    detailEn: 'drops significantly.',
  ),
  RecoveryMarker(
    timeLabel: '5 – 10 Jahre',
    title: 'Krebs & Schlaganfall',
    detail:
        'Risiko für Mund-/Rachen-/Kehlkopfkrebs halbiert sich, '
        'Schlaganfall-Risiko sinkt.',
    timeLabelEn: '5 – 10 yrs',
    titleEn: 'Cancer & Stroke',
    detailEn:
        'risk of mouth/throat/larynx cancer halves, '
        'stroke risk drops.',
  ),
  RecoveryMarker(
    timeLabel: '10 Jahre',
    title: 'Lungenkrebs-Risiko',
    detail: 'etwa halb so hoch wie bei Weiterrauchen.',
    timeLabelEn: '10 yrs',
    titleEn: 'Lung Cancer Risk',
    detailEn: 'about half that of someone who keeps smoking.',
  ),
  RecoveryMarker(
    timeLabel: '15 Jahre',
    title: 'Herzkrankheit',
    detail: 'Risiko nahe dem einer Person, die nie geraucht hat.',
    timeLabelEn: '15 yrs',
    titleEn: 'Heart Disease',
    detailEn: 'risk close to that of someone who never smoked.',
  ),
];
