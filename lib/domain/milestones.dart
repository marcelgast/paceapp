/// Gamification catalog — pure data + evaluation, no Flutter imports.
///
/// Milestones blend racing flavour with real smoking-recovery facts, so every
/// unlock feels earned *and* tells the user something true about their body.
library;

enum MilestoneKind { time, money, avoided }

class Milestone {
  const Milestone({
    required this.key,
    required this.kind,
    required this.threshold,
    required this.title,
    required this.detail,
    required this.titleEn,
    required this.detailEn,
  });

  final String key;
  final MilestoneKind kind;

  /// Seconds (time), cents (money) or count (avoided).
  final num threshold;
  final String title;
  final String detail;
  final String titleEn;
  final String detailEn;

  String localizedTitle(String lang) => lang == 'en' ? titleEn : title;
  String localizedDetail(String lang) => lang == 'en' ? detailEn : detail;
}

class CarTier {
  const CarTier({
    required this.name,
    required this.unlockCents,
    required this.tagline,
    required this.nameEn,
    required this.taglineEn,
  });

  final String name;
  final int unlockCents;
  final String tagline;
  final String nameEn;
  final String taglineEn;

  String localizedName(String lang) => lang == 'en' ? nameEn : name;
  String localizedTagline(String lang) => lang == 'en' ? taglineEn : tagline;
}

const List<Milestone> kMilestones = [
  // ---- Time: racing flavour + recovery facts -----------------------------
  Milestone(
    key: 'time_1m',
    kind: MilestoneKind.time,
    threshold: 60,
    title: 'Zündung',
    detail: 'Der Motor läuft. Deine Reise beginnt genau jetzt.',
    titleEn: 'Ignition',
    detailEn: 'The engine is running. Your journey starts right now.',
  ),
  Milestone(
    key: 'time_20m',
    kind: MilestoneKind.time,
    threshold: 20 * 60,
    title: 'Aufwärmrunde',
    detail: '20 Minuten: Puls und Blutdruck normalisieren sich bereits.',
    titleEn: 'Warm-Up Lap',
    detailEn: '20 minutes: heart rate and blood pressure are already settling.',
  ),
  Milestone(
    key: 'time_8h',
    kind: MilestoneKind.time,
    threshold: 8 * 3600,
    title: 'Halbe Renndistanz',
    detail: '8 Stunden: Der Kohlenmonoxid-Spiegel im Blut halbiert sich.',
    titleEn: 'Half Race Distance',
    detailEn: '8 hours: the carbon monoxide level in your blood halves.',
  ),
  Milestone(
    key: 'time_24h',
    kind: MilestoneKind.time,
    threshold: 24 * 3600,
    title: '24-Stunden-Pace',
    detail: 'Ein ganzer Tag: Dein Herzinfarkt-Risiko beginnt zu sinken.',
    titleEn: '24-Hour Pace',
    detailEn: 'A full day: your risk of a heart attack starts to drop.',
  ),
  Milestone(
    key: 'time_48h',
    kind: MilestoneKind.time,
    threshold: 48 * 3600,
    title: 'Boxencrew feiert',
    detail: '48 Stunden: Geschmack und Geruch kommen zurück.',
    titleEn: 'Pit Crew Celebrates',
    detailEn: '48 hours: taste and smell are coming back.',
  ),
  Milestone(
    key: 'time_72h',
    kind: MilestoneKind.time,
    threshold: 72 * 3600,
    title: 'Freie Fahrt',
    detail: '72 Stunden: Die Bronchien entspannen, Atmen fällt leichter.',
    titleEn: 'Open Road',
    detailEn: '72 hours: your bronchial tubes relax, breathing gets easier.',
  ),
  Milestone(
    key: 'time_1w',
    kind: MilestoneKind.time,
    threshold: 7 * 24 * 3600,
    title: 'Erstes Podium',
    detail: 'Eine Woche durchgezogen — der schwerste Teil liegt hinter dir.',
    titleEn: 'First Podium',
    detailEn: 'One week down — the hardest part is behind you.',
  ),
  Milestone(
    key: 'time_2w',
    kind: MilestoneKind.time,
    threshold: 14 * 24 * 3600,
    title: 'Kreislauf auf Touren',
    detail: '2 Wochen: Durchblutung und Kondition verbessern sich spürbar.',
    titleEn: 'Circulation Revving Up',
    detailEn: '2 weeks: circulation and fitness improve noticeably.',
  ),
  Milestone(
    key: 'time_1mo',
    kind: MilestoneKind.time,
    threshold: 30 * 24 * 3600,
    title: 'Monats-Champion',
    detail: 'Ein Monat: Die Lungenfunktion steigt deutlich.',
    titleEn: 'Monthly Champion',
    detailEn: 'One month: your lung function climbs significantly.',
  ),
  Milestone(
    key: 'time_3mo',
    kind: MilestoneKind.time,
    threshold: 90 * 24 * 3600,
    title: 'Saisonsieg',
    detail: '3 Monate: Husten und Kurzatmigkeit lassen nach.',
    titleEn: 'Season Win',
    detailEn: '3 months: coughing and shortness of breath ease off.',
  ),
  Milestone(
    key: 'time_1y',
    kind: MilestoneKind.time,
    threshold: 365 * 24 * 3600,
    title: 'Weltmeister',
    detail: 'Ein Jahr: Dein Herzinfarkt-Risiko ist etwa halbiert.',
    titleEn: 'World Champion',
    detailEn: 'One year: your risk of a heart attack is roughly halved.',
  ),

  // ---- Cigarettes avoided ------------------------------------------------
  Milestone(
    key: 'avoid_10',
    kind: MilestoneKind.avoided,
    threshold: 10,
    title: '10 Boxenstopps gespart',
    detail: 'Zehn Zigaretten, die du nicht geraucht hast.',
    titleEn: '10 Pit Stops Saved',
    detailEn: 'Ten cigarettes you didn\'t smoke.',
  ),
  Milestone(
    key: 'avoid_50',
    kind: MilestoneKind.avoided,
    threshold: 50,
    title: 'Halbe Stange vorbei',
    detail: '50 Zigaretten weniger in deiner Lunge.',
    titleEn: 'Half a Carton Down',
    detailEn: '50 fewer cigarettes in your lungs.',
  ),
  Milestone(
    key: 'avoid_100',
    kind: MilestoneKind.avoided,
    threshold: 100,
    title: 'Hunderter-Marke',
    detail: '100 Zigaretten vermieden. Stark.',
    titleEn: 'The Hundred Mark',
    detailEn: '100 cigarettes avoided. Strong.',
  ),
  Milestone(
    key: 'avoid_250',
    kind: MilestoneKind.avoided,
    threshold: 250,
    title: 'Viertel-Tausend',
    detail: '250 Zigaretten, an denen du vorbeigefahren bist.',
    titleEn: 'Quarter Thousand',
    detailEn: '250 cigarettes you blew right past.',
  ),
  Milestone(
    key: 'avoid_500',
    kind: MilestoneKind.avoided,
    threshold: 500,
    title: 'Pole Position',
    detail: '500 vermiedene Zigaretten.',
    titleEn: 'Pole Position',
    detailEn: '500 cigarettes avoided.',
  ),
  Milestone(
    key: 'avoid_1000',
    kind: MilestoneKind.avoided,
    threshold: 1000,
    title: 'Rekordjagd',
    detail: '1000 Zigaretten nie geraucht. Legendär.',
    titleEn: 'Record Chase',
    detailEn: '1000 cigarettes never smoked. Legendary.',
  ),

  // ---- Money saved (mirrors the car budget) ------------------------------
  Milestone(
    key: 'money_500',
    kind: MilestoneKind.money,
    threshold: 500,
    title: 'Erste Tankfüllung',
    detail: '5 € gespart — das erste Tuning-Teil ist drin.',
    titleEn: 'First Tank of Fuel',
    detailEn: '€5 saved — your first tuning part is in.',
  ),
  Milestone(
    key: 'money_2500',
    kind: MilestoneKind.money,
    threshold: 2500,
    title: 'Werkstatt-Budget',
    detail: '25 € gespart.',
    titleEn: 'Garage Budget',
    detailEn: '€25 saved.',
  ),
  Milestone(
    key: 'money_10000',
    kind: MilestoneKind.money,
    threshold: 10000,
    title: 'Sponsoren-Deal',
    detail: '100 € gespart.',
    titleEn: 'Sponsor Deal',
    detailEn: '€100 saved.',
  ),
  Milestone(
    key: 'money_50000',
    kind: MilestoneKind.money,
    threshold: 50000,
    title: 'Renn-Etat',
    detail: '500 € gespart.',
    titleEn: 'Racing Budget',
    detailEn: '€500 saved.',
  ),
];

/// NFS-style garage. You buy your way up with money *not* spent on cigarettes.
const List<CarTier> kCarTiers = [
  CarTier(
    name: 'Rostlaube',
    unlockCents: 0,
    tagline: 'Läuft. Irgendwie.',
    nameEn: 'Rust Bucket',
    taglineEn: 'Runs. Somehow.',
  ),
  CarTier(
    name: 'Tuned Hatchback',
    unlockCents: 1500,
    tagline: 'Erster Boost.',
    nameEn: 'Tuned Hatchback',
    taglineEn: 'First boost.',
  ),
  CarTier(
    name: 'Street Coupé',
    unlockCents: 5000,
    tagline: 'Underground-tauglich.',
    nameEn: 'Street Coupé',
    taglineEn: 'Underground-ready.',
  ),
  CarTier(
    name: 'Drift Machine',
    unlockCents: 15000,
    tagline: 'Heck raus, Style an.',
    nameEn: 'Drift Machine',
    taglineEn: 'Tail out, style on.',
  ),
  CarTier(
    name: 'Muscle Car',
    unlockCents: 30000,
    tagline: 'Pures Drehmoment.',
    nameEn: 'Muscle Car',
    taglineEn: 'Pure torque.',
  ),
  CarTier(
    name: 'GT-Renner',
    unlockCents: 60000,
    tagline: 'Most-Wanted-Material.',
    nameEn: 'GT Racer',
    taglineEn: 'Most-Wanted material.',
  ),
  CarTier(
    name: 'Hypercar',
    unlockCents: 120000,
    tagline: 'Die Blacklist ruft.',
    nameEn: 'Hypercar',
    taglineEn: 'The Blacklist is calling.',
  ),
];

abstract final class MilestoneEvaluator {
  /// All milestones currently met by the given progress. Time milestones are
  /// measured against the longest clean stretch ([bestClean]), not total time —
  /// you earn "8 h" by actually going 8 h without a cigarette.
  static List<Milestone> achieved({
    required Duration bestClean,
    required int savedCents,
    required int avoided,
  }) {
    return kMilestones.where((m) {
      return switch (m.kind) {
        MilestoneKind.time => bestClean.inSeconds >= m.threshold,
        MilestoneKind.money => savedCents >= m.threshold,
        MilestoneKind.avoided => avoided >= m.threshold,
      };
    }).toList();
  }

  /// Highest car unlocked for the money saved so far.
  static CarTier currentCar(int savedCents) {
    var car = kCarTiers.first;
    for (final tier in kCarTiers) {
      if (savedCents >= tier.unlockCents) car = tier;
    }
    return car;
  }

  /// Next car to chase, or null once everything is unlocked.
  static CarTier? nextCar(int savedCents) {
    for (final tier in kCarTiers) {
      if (savedCents < tier.unlockCents) return tier;
    }
    return null;
  }
}
