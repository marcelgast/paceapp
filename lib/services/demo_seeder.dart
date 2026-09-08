import '../data/database.dart';
import '../domain/milestones.dart';

/// Fills the database with realistic demo data for App Store screenshots.
/// Only ever runs behind `--dart-define=SEED_DEMO=true`; never in production.
Future<void> seedDemoData(AppDatabase db) async {
  final now = DateTime.now();

  await db.resetEverything();
  await db.saveOnboarding(
    packPriceCents: 800,
    cigarettesPerPack: 20,
    baselineCigsPerDay: 20,
    startedAt: now.subtract(const Duration(days: 30)),
  );
  // A live target so the cockpit shows a running stint, not the measuring phase.
  // [at] = now so no weekly proposal overlay is due during screenshots.
  await db.acceptProposal(
    targetSeconds: 90 * 60,
    growthPermille: 100,
    at: now,
  );

  final situations = await db.watchActiveSituations().first;
  String situationAt(int i) => situations[i % situations.length].id;

  // Decreasing daily count over the last 14 days → a visible downward trend.
  const perDay = [7, 7, 6, 6, 6, 5, 5, 4, 4, 4, 3, 3, 3, 2];
  final midnightToday = DateTime(now.year, now.month, now.day);
  var k = 0;
  for (var daysAgo = 13; daysAgo >= 0; daysAgo--) {
    final day = midnightToday.subtract(Duration(days: daysAgo));
    final count = perDay[13 - daysAgo];
    for (var j = 0; j < count; j++) {
      // Spread across waking hours 08:00–22:00.
      final minute = 8 * 60 + (j * (14 * 60) ~/ count);
      var ts = day.add(Duration(minutes: minute));
      // Today's last pit sits ~55 min back so the cockpit shows a mid-stint.
      if (daysAgo == 0 && j == count - 1) {
        ts = now.subtract(const Duration(minutes: 55));
      }
      if (ts.isAfter(now)) ts = now.subtract(const Duration(minutes: 55));
      await db.addPitStop(
        occurredAt: ts,
        cravingLevel: 2 + (k % 4),
        stressLevel: 2 + ((k + 1) % 4),
        situationId: situationAt(k),
        targetIntervalSeconds: 90 * 60,
      );
      k++;
    }
  }

  // Pre-mark every milestone as celebrated so no congratulation overlay pops
  // over the screenshots.
  await db.markCelebrated(kMilestones.map((m) => m.key), now);
}
