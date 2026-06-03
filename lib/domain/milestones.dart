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
  });

  final String key;
  final MilestoneKind kind;

  /// Seconds (time), cents (money) or count (avoided).
  final num threshold;
  final String title;
  final String detail;
}

class CarTier {
  const CarTier({
    required this.name,
    required this.unlockCents,
    required this.tagline,
  });

  final String name;
  final int unlockCents;
  final String tagline;
}

const List<Milestone> kMilestones = [
  // ---- Time: racing flavour + recovery facts -----------------------------
  Milestone(
    key: 'time_1m',
    kind: MilestoneKind.time,
    threshold: 60,
    title: 'Zündung',
    detail: 'Der Motor läuft. Deine Reise beginnt genau jetzt.',
  ),
  Milestone(
    key: 'time_20m',
    kind: MilestoneKind.time,
    threshold: 20 * 60,
    title: 'Aufwärmrunde',
    detail: '20 Minuten: Puls und Blutdruck normalisieren sich bereits.',
  ),
  Milestone(
    key: 'time_8h',
    kind: MilestoneKind.time,
    threshold: 8 * 3600,
    title: 'Halbe Renndistanz',
    detail: '8 Stunden: Der Kohlenmonoxid-Spiegel im Blut halbiert sich.',
  ),
  Milestone(
    key: 'time_24h',
    kind: MilestoneKind.time,
    threshold: 24 * 3600,
    title: '24-Stunden-Pace',
    detail: 'Ein ganzer Tag: Dein Herzinfarkt-Risiko beginnt zu sinken.',
  ),
  Milestone(
    key: 'time_48h',
    kind: MilestoneKind.time,
    threshold: 48 * 3600,
    title: 'Boxencrew feiert',
    detail: '48 Stunden: Geschmack und Geruch kommen zurück.',
  ),
  Milestone(
    key: 'time_72h',
    kind: MilestoneKind.time,
    threshold: 72 * 3600,
    title: 'Freie Fahrt',
    detail: '72 Stunden: Die Bronchien entspannen, Atmen fällt leichter.',
  ),
  Milestone(
    key: 'time_1w',
    kind: MilestoneKind.time,
    threshold: 7 * 24 * 3600,
    title: 'Erstes Podium',
    detail: 'Eine Woche durchgezogen — der schwerste Teil liegt hinter dir.',
  ),
  Milestone(
    key: 'time_2w',
    kind: MilestoneKind.time,
    threshold: 14 * 24 * 3600,
    title: 'Kreislauf auf Touren',
    detail: '2 Wochen: Durchblutung und Kondition verbessern sich spürbar.',
  ),
  Milestone(
    key: 'time_1mo',
    kind: MilestoneKind.time,
    threshold: 30 * 24 * 3600,
    title: 'Monats-Champion',
    detail: 'Ein Monat: Die Lungenfunktion steigt deutlich.',
  ),
  Milestone(
    key: 'time_3mo',
    kind: MilestoneKind.time,
    threshold: 90 * 24 * 3600,
    title: 'Saisonsieg',
    detail: '3 Monate: Husten und Kurzatmigkeit lassen nach.',
  ),
  Milestone(
    key: 'time_1y',
    kind: MilestoneKind.time,
    threshold: 365 * 24 * 3600,
    title: 'Weltmeister',
    detail: 'Ein Jahr: Dein Herzinfarkt-Risiko ist etwa halbiert.',
  ),

  // ---- Cigarettes avoided ------------------------------------------------
  Milestone(
    key: 'avoid_10',
    kind: MilestoneKind.avoided,
    threshold: 10,
    title: '10 Boxenstopps gespart',
    detail: 'Zehn Zigaretten, die du nicht geraucht hast.',
  ),
  Milestone(
    key: 'avoid_50',
    kind: MilestoneKind.avoided,
    threshold: 50,
    title: 'Halbe Stange vorbei',
    detail: '50 Zigaretten weniger in deiner Lunge.',
  ),
  Milestone(
    key: 'avoid_100',
    kind: MilestoneKind.avoided,
    threshold: 100,
    title: 'Hunderter-Marke',
    detail: '100 Zigaretten vermieden. Stark.',
  ),
  Milestone(
    key: 'avoid_250',
    kind: MilestoneKind.avoided,
    threshold: 250,
    title: 'Viertel-Tausend',
    detail: '250 Zigaretten, an denen du vorbeigefahren bist.',
  ),
  Milestone(
    key: 'avoid_500',
    kind: MilestoneKind.avoided,
    threshold: 500,
    title: 'Pole Position',
    detail: '500 vermiedene Zigaretten.',
  ),
  Milestone(
    key: 'avoid_1000',
    kind: MilestoneKind.avoided,
    threshold: 1000,
    title: 'Rekordjagd',
    detail: '1000 Zigaretten nie geraucht. Legendär.',
  ),

  // ---- Money saved (mirrors the car budget) ------------------------------
  Milestone(
    key: 'money_500',
    kind: MilestoneKind.money,
    threshold: 500,
    title: 'Erste Tankfüllung',
    detail: '5 € gespart — das erste Tuning-Teil ist drin.',
  ),
  Milestone(
    key: 'money_2500',
    kind: MilestoneKind.money,
    threshold: 2500,
    title: 'Werkstatt-Budget',
    detail: '25 € gespart.',
  ),
  Milestone(
    key: 'money_10000',
    kind: MilestoneKind.money,
    threshold: 10000,
    title: 'Sponsoren-Deal',
    detail: '100 € gespart.',
  ),
  Milestone(
    key: 'money_50000',
    kind: MilestoneKind.money,
    threshold: 50000,
    title: 'Renn-Etat',
    detail: '500 € gespart.',
  ),
];

/// NFS-style garage. You buy your way up with money *not* spent on cigarettes.
const List<CarTier> kCarTiers = [
  CarTier(name: 'Rostlaube', unlockCents: 0, tagline: 'Läuft. Irgendwie.'),
  CarTier(name: 'Tuned Hatchback', unlockCents: 1500, tagline: 'Erster Boost.'),
  CarTier(name: 'Street Coupé', unlockCents: 5000, tagline: 'Underground-tauglich.'),
  CarTier(name: 'Drift Machine', unlockCents: 15000, tagline: 'Heck raus, Style an.'),
  CarTier(name: 'Muscle Car', unlockCents: 30000, tagline: 'Pures Drehmoment.'),
  CarTier(name: 'GT-Renner', unlockCents: 60000, tagline: 'Most-Wanted-Material.'),
  CarTier(name: 'Hypercar', unlockCents: 120000, tagline: 'Die Blacklist ruft.'),
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
