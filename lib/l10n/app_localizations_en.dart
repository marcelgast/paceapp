// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pace';

  @override
  String get tabCockpit => 'Cockpit';

  @override
  String get tabAnalysis => 'Analysis';

  @override
  String get tabBody => 'Body';

  @override
  String get tabTrophies => 'Trophies';

  @override
  String get tabJournal => 'Journal';

  @override
  String get boxenstopp => 'Pit stop';

  @override
  String get onboardingInvalidValue => 'Enter a valid value.';

  @override
  String get onboardingTagline => 'No quit date. Just your pace.';

  @override
  String get onboardingPitCheck1of3 => 'PIT CHECK · 1/3';

  @override
  String get onboardingPitCheck2of3 => 'PIT CHECK · 2/3';

  @override
  String get onboardingPitCheck3of3 => 'PIT CHECK · 3/3';

  @override
  String get onboardingPackPriceHeadline => 'What does a pack cost you?';

  @override
  String get onboardingPackPriceSub =>
      'So we can count every euro you win back.';

  @override
  String get onboardingPerPackHeadline => 'How many cigarettes per pack?';

  @override
  String get onboardingPerPackSub => 'Standard is 20 — tune it to your brand.';

  @override
  String get onboardingPerDayHeadline => 'How many a day — honestly?';

  @override
  String get onboardingPerDaySub =>
      'No judgment. This is just your starting line.';

  @override
  String get onboardingNext => 'NEXT';

  @override
  String get onboardingCountdown => '3 · 2 · 1 …';

  @override
  String get onboardingWelcomeEyebrow => 'WELCOME TO PACE';

  @override
  String get onboardingWelcomeHeadline => 'Your race, your pace';

  @override
  String get onboardingWelcomeBody =>
      'Pace gets you smoke-free — step by step, no cold turkey. Lean in, and the program carries you at your own pace.';

  @override
  String get onboardingFeatureObserveTitle => 'First watch';

  @override
  String get onboardingFeatureObserveDetail =>
      'For one day you drive like always — we quietly learn your pace.';

  @override
  String get onboardingFeatureStretchTitle => 'Then stretch';

  @override
  String get onboardingFeatureStretchDetail =>
      'Week by week, a little more time between two cigarettes — only ever when you\'re ready.';

  @override
  String get onboardingFeatureCelebrateTitle => 'Celebrate on the way';

  @override
  String get onboardingFeatureCelebrateDetail =>
      'Unlock achievements and use the money you saved to unlock better cars.';

  @override
  String get onboardingFeatureEmergencyTitle => 'For emergencies';

  @override
  String get onboardingFeatureEmergencyDetail =>
      'Acute craving? The proven breathing exercise gets you through it.';

  @override
  String get onboardingWelcomeClosing =>
      'Anyone can do this. At their own pace.';

  @override
  String get onboardingLetsGo => 'LET\'S GO';

  @override
  String get onboardingSleepEyebrow => 'YOUR SLEEP';

  @override
  String get onboardingSleepHeadline => 'When do you roughly sleep?';

  @override
  String get onboardingSleepBody =>
      'Sleep doesn\'t count toward stints and best times — otherwise the night would always be your longest stretch. Changeable later in settings.';

  @override
  String get onboardingSleepFrom => 'From';

  @override
  String get onboardingSleepTo => 'To';

  @override
  String get onboardingMeasureEyebrow => 'HOW YOUR START WORKS';

  @override
  String get onboardingMeasureHeadline => 'First measure, then stretch';

  @override
  String get onboardingMeasureBody =>
      'No cold turkey. On the first day you keep driving as normal — we just watch and learn your pace.';

  @override
  String get onboardingStepMeasureTitle => 'Measuring lap · 1 day';

  @override
  String get onboardingStepMeasureDetail =>
      'Log every cigarette as a pit stop. No target, no pressure.';

  @override
  String get onboardingStepTargetTitle => 'Your first target';

  @override
  String get onboardingStepTargetDetail =>
      'We analyze your pattern and suggest your stint interval.';

  @override
  String get onboardingStepRaceTitle => 'The race is on';

  @override
  String get onboardingStepRaceDetail =>
      'Stretch stints, build your streak, unlock cars.';

  @override
  String get onboardingStartMeasuringLap => 'START MEASURING LAP';

  @override
  String get cockpitBaselineMeasuring => 'Measuring your pace';

  @override
  String get cockpitBaselineEndsToday => 'ends today';

  @override
  String get cockpitBaselineEndsTomorrow => 'ends tomorrow';

  @override
  String cockpitBaselineDaysLeft(Object days) {
    return '$days days left';
  }

  @override
  String get cockpitStatSaved => 'Saved';

  @override
  String get cockpitStatAvoided => 'Avoided';

  @override
  String get cockpitStatInRace => 'In the race';

  @override
  String get cockpitGaugeMeasuringLap => 'MEASURING LAP';

  @override
  String get cockpitGaugeNextStint => 'NEXT STINT';

  @override
  String cockpitGaugeTarget(Object target) {
    return 'Target: $target';
  }

  @override
  String get cockpitGaugeOvertime => 'OVERTIME';

  @override
  String cockpitGaugeBonusLap(Object lap) {
    return 'Bonus lap $lap — you\'re out in front! 🔥';
  }

  @override
  String get cockpitGaugeBonusTime => 'bonus time — you\'re out in front!';

  @override
  String get cockpitPitButtonTitle => 'PIT STOP';

  @override
  String get cockpitPitButtonSubtitle => 'Cigarette smoked  ·  +1';

  @override
  String get cockpitSosButton => 'CRAVING? BREATHE';

  @override
  String cockpitStreakDay(Object days) {
    return '$days day';
  }

  @override
  String cockpitStreakDays(Object days) {
    return '$days days';
  }

  @override
  String get cockpitStreakLabel => 'Streak';

  @override
  String get cockpitPitStopTitle => 'Pit stop';

  @override
  String get cockpitPitStopSubtitle =>
      'Jot it down — your analysis learns from it.';

  @override
  String get cockpitCraving => 'Craving';

  @override
  String get cockpitStress => 'Stress';

  @override
  String get cockpitSituation => 'Situation';

  @override
  String get cockpitSituationNew => '+ New';

  @override
  String cockpitLevelValue(Object value) {
    return '$value/5';
  }

  @override
  String get cockpitNoteHint => 'Note (optional)';

  @override
  String get cockpitSubmit => 'LOG IT';

  @override
  String get cockpitNewSituationTitle => 'New situation';

  @override
  String get cockpitNewSituationHint => 'e.g. break, phone call …';

  @override
  String get cockpitCancel => 'Cancel';

  @override
  String get cockpitCreate => 'Create';

  @override
  String get sosInhale => 'Breathe in';

  @override
  String get sosHold => 'Hold';

  @override
  String get sosExhale => 'Breathe out';

  @override
  String get sosCravingPassing => 'CRAVING RIDES PAST';

  @override
  String get sosBreatheAlong => 'Breathe along. You don\'t have to do a thing.';

  @override
  String get sosNoBreathYet => 'No full breath yet';

  @override
  String sosBreathsDone(Object count) {
    return '$count breaths done';
  }

  @override
  String get sosStopButton => 'FEELING BETTER — STOP';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPriceIntro =>
      'Changed the price or pack size? New values kick in from now — what you\'ve already Saved keeps its old price.';

  @override
  String get settingsPricePerPack => 'Price per pack';

  @override
  String get settingsCigarettesPerPack => 'Cigarettes per pack';

  @override
  String get settingsCigarettesPerDay => 'Cigarettes per day (before)';

  @override
  String get settingsBaselineHint =>
      'Your baseline. Changing it skews Saved & Avoided — only fix it if you fat-fingered the number.';

  @override
  String get settingsSleepTime => 'SLEEP TIME';

  @override
  String get settingsSleepHint =>
      'Sleep doesn\'t count toward stints & best times.';

  @override
  String get settingsFrom => 'From';

  @override
  String get settingsTo => 'To';

  @override
  String get settingsHistory => 'HISTORY';

  @override
  String get settingsSaveButton => 'SAVE';

  @override
  String get settingsSave => 'Save';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsResetEverything => 'RESET EVERYTHING';

  @override
  String get settingsResetTitle => 'Reset everything?';

  @override
  String get settingsResetBody =>
      'Every bit of data gets wiped: settings, pit stops, trophies and cars. You\'re back at the welcome screen. No way to undo this.';

  @override
  String get settingsResetConfirm => 'Reset';

  @override
  String get settingsBaselineChangeTitle => 'Change daily consumption?';

  @override
  String get settingsBaselineChangeBody =>
      'Your daily consumption is the baseline. Changing it badly skews the numbers you see (Saved, Avoided). Save anyway?';

  @override
  String get settingsInvalidValues => 'Enter valid values, please.';

  @override
  String get settingsSaved => 'Saved.';

  @override
  String settingsHistorySince(Object date) {
    return 'since $date';
  }

  @override
  String settingsHistoryPriceLine(Object price, Object count) {
    return '$price · $count/pack';
  }

  @override
  String get journalTitle => 'Journal';

  @override
  String get journalSituations => 'Situations';

  @override
  String journalRaceReportWeek(Object week) {
    return 'RACE REPORT · WEEK $week';
  }

  @override
  String journalEvery(Object duration) {
    return 'every $duration';
  }

  @override
  String get journalMedianPace => 'Median pace';

  @override
  String get journalCigarettes => 'Cigarettes';

  @override
  String get journalSpin => 'Spin';

  @override
  String journalFewer(Object count) {
    return '$count fewer 🏁';
  }

  @override
  String get journalDeletePitStopTitle => 'Delete pit stop?';

  @override
  String get journalDeletePitStopBody =>
      'Logged it twice by accident? Deleting it shifts the numbers you see (Saved, Avoided, Streak).';

  @override
  String get journalCancel => 'Cancel';

  @override
  String get journalDelete => 'Delete';

  @override
  String get journalSpinBadge => 'SPIN';

  @override
  String get journalCraving => 'Craving';

  @override
  String get journalStress => 'Stress';

  @override
  String get journalEmptyTitle => 'No pit stops yet';

  @override
  String get journalEmptyBody =>
      'And that\'s a good thing. The moment you log a pit stop, your pattern shows up here.';

  @override
  String get situationsIntro => 'Set up whatever fits your everyday.';

  @override
  String get situationsNewHint => 'New situation';

  @override
  String get trophiesTitle => 'Trophy case';

  @override
  String get trophiesGarageSection => 'GARAGE';

  @override
  String get trophiesMilestonesSection => 'MILESTONES';

  @override
  String get trophiesUnlocked => 'unlocked';

  @override
  String get trophiesGarageComplete => 'Garage complete — everything unlocked!';

  @override
  String trophiesGarageRemaining(Object amount, Object car) {
    return '$amount to go until $car';
  }

  @override
  String get trophiesYourRide => 'YOUR RIDE';

  @override
  String trophiesCigsCount(Object count) {
    return '$count Cigs';
  }

  @override
  String get shareLabel => 'Share';

  @override
  String get shareButton => 'SHARE';

  @override
  String get shareCurrentLap => 'CURRENT LAP';

  @override
  String shareCurrentLapText(Object clock) {
    return 'Current lap: $clock smoke-free. 🏁';
  }

  @override
  String get shareMilestone => 'MILESTONE';

  @override
  String shareMilestoneText(Object title) {
    return 'Milestone cracked: $title 🏁';
  }

  @override
  String get sharePitStopReport => 'PIT-STOP\nREPORT';

  @override
  String get shareSaved => 'SAVED';

  @override
  String get shareAvoided => 'AVOIDED';

  @override
  String get shareStreak => 'STREAK';

  @override
  String shareStreakDays(Object days) {
    return '$days d';
  }

  @override
  String get analysisTitle => 'Race Analysis';

  @override
  String get analysisTriggers => 'Your triggers';

  @override
  String get analysisLast7Days => 'Last 7 days';

  @override
  String get analysisMedianPace => 'MEDIAN PACE';

  @override
  String analysisEvery(Object duration) {
    return 'every $duration';
  }

  @override
  String get analysisCollecting => 'still gathering …';

  @override
  String get analysisMedianHint =>
      'Typical gap between two cigs — the bigger, the better 🏁';

  @override
  String get analysisMedianEmptyHint =>
      'Log a few pit stops and your average shows up here.';

  @override
  String get analysisSameAsLastWeek => '= last week';

  @override
  String get analysisAvgCraving => '⌀ Craving';

  @override
  String get analysisAvgStress => '⌀ Stress';

  @override
  String get analysisSpins => 'Spins';

  @override
  String get analysisWeekdayMon => 'M';

  @override
  String get analysisWeekdayTue => 'T';

  @override
  String get analysisWeekdayWed => 'W';

  @override
  String get analysisWeekdayThu => 'T';

  @override
  String get analysisWeekdayFri => 'F';

  @override
  String get analysisWeekdaySat => 'S';

  @override
  String get analysisWeekdaySun => 'S';

  @override
  String get analysisEmptyTitle => 'No telemetry yet';

  @override
  String get analysisEmptyBody =>
      'Once you log pit stops, we\'ll spot your pattern here — when, where and how hard your craving hits.';

  @override
  String get proposalStretchCheck => 'STRETCH CHECK';

  @override
  String get proposalWeekDone => 'Week done!';

  @override
  String get proposalFirstTargetPrompt =>
      'The qualifying lap is over. Shall we set your first target interval?';

  @override
  String get proposalStretchPrompt =>
      'Strong driving. Shall we stretch the gap between two cigs?';

  @override
  String get proposalNewTarget => 'NEW TARGET';

  @override
  String proposalEvery(Object duration) {
    return 'every $duration';
  }

  @override
  String proposalMoreRoom(Object duration) {
    return '+$duration more room per stint';
  }

  @override
  String get proposalStretchBy => 'Stretch by';

  @override
  String proposalPercent(Object pct) {
    return '+$pct %';
  }

  @override
  String get proposalApply => 'APPLY';

  @override
  String get proposalKeepIt => 'Keep it';

  @override
  String get proposalTargetSet => 'Target set!';

  @override
  String get proposalAcceptedHint => 'Let\'s roll. You\'re driving this now.';

  @override
  String get celebrationMilestone => 'MILESTONE';

  @override
  String get celebrationLetsGo => 'LET\'S GO';

  @override
  String get celebrationShareAsCard => 'Share as card';

  @override
  String get recoveryTitle => 'Recovery';

  @override
  String get recoverySubtitle => 'How your body heals when you don\'t smoke.';

  @override
  String get recoveryEveryStintHeals => 'Every stint heals';

  @override
  String recoveryCurrentStint(Object duration) {
    return 'Current stint: $duration';
  }

  @override
  String get recoveryLongTerm => 'Long term — once you stay smoke-free';

  @override
  String get recoverySources =>
      'Sources: American Cancer Society, NHS / US Surgeon General.';

  @override
  String get analysisNoSituation => 'Not specified';

  @override
  String get raceEngineerTitle => 'Race Engineer';

  @override
  String get raceEngineerSubtitle =>
      'When, where and how hard the craving hits — and your trend.';

  @override
  String get raceEngineerByHour => 'TIME OF DAY';

  @override
  String raceEngineerPeakHour(Object hour) {
    return 'Peak time: $hour:00';
  }

  @override
  String get raceEngineerByWeekday => 'WEEKDAYS';

  @override
  String get raceEngineerTriggers => 'TOP TRIGGERS';

  @override
  String get raceEngineerTrend => 'TREND';

  @override
  String raceEngineerTrendDown(Object amount) {
    return '↓ $amount fewer per day since the start';
  }

  @override
  String get raceEngineerTrendFlat => 'Keep at it — the trend is coming.';

  @override
  String get raceEngineerTrendAxis => 'Cigarettes/day · week by week';

  @override
  String get raceEngineerEmptyTitle => 'No data yet';

  @override
  String get raceEngineerEmptyBody =>
      'Log a few pit stops and the Race Engineer reads your pattern.';

  @override
  String get settingsProSection => 'PACE PRO';

  @override
  String get settingsProRaceEngineer => 'Race Engineer';

  @override
  String get settingsProRaceEngineerSub =>
      'Deep analytics — patterns, triggers, trend.';

  @override
  String get settingsProSkin => 'SKIN';

  @override
  String get settingsProLiveActivity => 'Live Activity';

  @override
  String get settingsProLiveActivitySub =>
      'Stint timer in the Dynamic Island & on the lock screen.';

  @override
  String get proBadge => 'PRO';

  @override
  String get settingsProActive => 'Pace Pro active';

  @override
  String get settingsProActiveSub => 'Thanks! All Pro features are unlocked.';

  @override
  String get settingsProRestore => 'Restore purchases';

  @override
  String get paywallSubtitle => 'Get more out of your race.';

  @override
  String get paywallThemesTitle => 'Neon skins';

  @override
  String get paywallThemesSub => '10 skins that recolour the whole app.';

  @override
  String paywallUnlock(Object price) {
    return 'Unlock · $price';
  }

  @override
  String get paywallUnlockNoPrice => 'Unlock Pace Pro';

  @override
  String get paywallRestore => 'Restore purchases';

  @override
  String get paywallOneTime =>
      'One-time purchase · no subscription · no hidden fees';

  @override
  String get paywallError => 'That didn\'t work. Please try again.';

  @override
  String get paywallUnavailable => 'The App Store isn\'t reachable right now.';

  @override
  String get raceEngineerUnlock => 'Unlock with Pace Pro';

  @override
  String get quitTitle => 'Quit date';

  @override
  String get quitPickDate => 'Pick your quit day';

  @override
  String get quitHonestTitle => 'Stretching is the path — not the finish';

  @override
  String get quitHonestBody =>
      'Stretching your stints gets you far. But at some point comes the honest step: stopping entirely. A fixed date makes that moment real — and Pace walks you there.';

  @override
  String get quitTriggersTitle => 'Arm yourself against your triggers';

  @override
  String quitTriggersBody(Object triggers) {
    return 'Your most common triggers: $triggers. Have a plan ready for each one — so cravings don\'t catch you off guard.';
  }

  @override
  String get quitTriggersBodyGeneric =>
      'Think about the moments you\'re most likely to reach for a cigarette — and have a plan ready for each.';

  @override
  String get quitTriggersTip =>
      'E.g. a breathing exercise, a glass of water, a short walk, or calling someone.';

  @override
  String get quitCompanionTitle => 'Pace has your back';

  @override
  String get quitCompanionBody =>
      'From that day, Pace counts your smoke-free days, brings the breathing exercise front and centre, and celebrates every step with you.';

  @override
  String get quitSetButton => 'Set the date';

  @override
  String get quitChangeDate => 'Change date';

  @override
  String get quitRemoveDate => 'Remove date';

  @override
  String get quitYourDate => 'Your quit day';

  @override
  String get proposalSetQuitDate => 'Ready for a quit date?';

  @override
  String get settingsQuitRowTitle => 'Set a quit date';

  @override
  String get settingsQuitRowSub =>
      'Optional — Pace walks you through the stop.';

  @override
  String get quitCountdownLabel => 'YOUR QUIT DAY';

  @override
  String get quitCountdownTomorrow => 'Tomorrow\'s the day!';

  @override
  String quitCountdownDays(Object days) {
    return '$days days to go';
  }

  @override
  String get smokeFreeRaceKicker => 'THE REAL RACE IS ON';

  @override
  String get smokeFreeFreeWord => 'smoke-free';

  @override
  String smokeFreeDaysWord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String get smokeFreeEncouragement =>
      'Full throttle. Every hour is ground gained — your body\'s coming with you.';

  @override
  String get cockpitBreathePrimaryTitle => 'Take a breath';

  @override
  String get cockpitBreathePrimarySub =>
      'Cravings come in waves — breathe through it.';

  @override
  String get cockpitRelapse => 'Slipped up? No drama — log it.';

  @override
  String get tabGoals => 'Goals';

  @override
  String get goalsTitle => 'Goals';

  @override
  String goalsSavedPool(Object amount) {
    return 'Saved so far: $amount';
  }

  @override
  String get goalsReachedBadge => 'Reached';

  @override
  String get goalsAdd => 'Add goal';

  @override
  String get goalsNameLabel => 'Name';

  @override
  String get goalsNameHint => 'e.g. New headphones';

  @override
  String get goalsPriceLabel => 'Price';

  @override
  String get goalsSave => 'Save';

  @override
  String get goalsEmptyTitle => 'No goals yet';

  @override
  String get goalsEmptyBody =>
      'Set a goal — e.g. headphones for €79. Your saved money fills it up bit by bit.';

  @override
  String get notifGoalTitle => 'Goal reached! 🎉';

  @override
  String notifGoalBody(Object name) {
    return '\"$name\" is yours — your saved money made it happen.';
  }

  @override
  String get notifQuitBeforeTitle => 'Tomorrow is your quit day 🏁';

  @override
  String get notifQuitBeforeBody =>
      'Get your trigger plan ready today — so you start prepared.';

  @override
  String get notifQuitDayTitle => 'Today\'s the day 🏁';

  @override
  String get notifQuitDayBody =>
      'Your quit day. You prepared for this — now go for it. Pace is with you.';
}
