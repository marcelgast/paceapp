// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Pace';

  @override
  String get tabCockpit => 'Cockpit';

  @override
  String get tabAnalysis => 'Analyse';

  @override
  String get tabBody => 'Körper';

  @override
  String get tabTrophies => 'Pokale';

  @override
  String get tabJournal => 'Journal';

  @override
  String get boxenstopp => 'Boxenstopp';

  @override
  String get onboardingInvalidValue => 'Trag bitte einen gültigen Wert ein.';

  @override
  String get onboardingTagline => 'Kein Stopp-Datum. Nur dein Tempo.';

  @override
  String get onboardingPitCheck1of3 => 'BOXEN-CHECK · 1/3';

  @override
  String get onboardingPitCheck2of3 => 'BOXEN-CHECK · 2/3';

  @override
  String get onboardingPitCheck3of3 => 'BOXEN-CHECK · 3/3';

  @override
  String get onboardingPackPriceHeadline => 'Was kostet dich eine Schachtel?';

  @override
  String get onboardingPackPriceSub =>
      'Damit zählen wir jeden Euro, den du zurückholst.';

  @override
  String get onboardingPerPackHeadline => 'Wie viele Kippen sind drin?';

  @override
  String get onboardingPerPackSub =>
      'Standard sind 20 — pass es an deine Marke an.';

  @override
  String get onboardingPerDayHeadline => 'Wie viele am Tag — ehrlich?';

  @override
  String get onboardingPerDaySub =>
      'Keine Wertung. Das ist nur deine Startlinie.';

  @override
  String get onboardingNext => 'WEITER';

  @override
  String get onboardingCountdown => '3 · 2 · 1 …';

  @override
  String get onboardingWelcomeEyebrow => 'WILLKOMMEN BEI PACE';

  @override
  String get onboardingWelcomeHeadline => 'Dein Rennen, dein Tempo';

  @override
  String get onboardingWelcomeBody =>
      'Pace bringt dich rauchfrei — Schritt für Schritt, ohne kalten Entzug. Lass dich drauf ein, und das Programm trägt dich in deinem Tempo.';

  @override
  String get onboardingFeatureObserveTitle => 'Erst beobachten';

  @override
  String get onboardingFeatureObserveDetail =>
      'Einen Tag fährst du wie immer — wir lernen still dein Tempo.';

  @override
  String get onboardingFeatureStretchTitle => 'Dann dehnen';

  @override
  String get onboardingFeatureStretchDetail =>
      'Woche für Woche etwas mehr Zeit zwischen zwei Zigaretten — immer nur, wenn du bereit bist.';

  @override
  String get onboardingFeatureCelebrateTitle => 'Unterwegs feiern';

  @override
  String get onboardingFeatureCelebrateDetail =>
      'Schalte Erfolge frei und fahr dir vom gesparten Geld bessere Autos frei.';

  @override
  String get onboardingFeatureEmergencyTitle => 'Für den Notfall';

  @override
  String get onboardingFeatureEmergencyDetail =>
      'Akutes Verlangen? Die bewährte Atemübung holt dich da durch.';

  @override
  String get onboardingWelcomeClosing => 'Jeder schafft das. In seinem Tempo.';

  @override
  String get onboardingLetsGo => 'LOS GEHT\'S';

  @override
  String get onboardingSleepEyebrow => 'DEIN SCHLAF';

  @override
  String get onboardingSleepHeadline => 'Wann schläfst du ungefähr?';

  @override
  String get onboardingSleepBody =>
      'Schlaf zählt nicht für Stints und Bestzeiten — sonst wäre die Nacht immer deine längste Strecke. Später in den Einstellungen änderbar.';

  @override
  String get onboardingSleepFrom => 'Von';

  @override
  String get onboardingSleepTo => 'Bis';

  @override
  String get onboardingMeasureEyebrow => 'SO LÄUFT DEIN START';

  @override
  String get onboardingMeasureHeadline => 'Erst messen, dann dehnen';

  @override
  String get onboardingMeasureBody =>
      'Kein kalter Entzug. Am ersten Tag fährst du ganz normal weiter — wir schauen nur zu und lernen dein Tempo.';

  @override
  String get onboardingStepMeasureTitle => 'Messrunde · 1 Tag';

  @override
  String get onboardingStepMeasureDetail =>
      'Logg jede Zigarette als Boxenstopp. Kein Ziel, kein Druck.';

  @override
  String get onboardingStepTargetTitle => 'Dein erstes Ziel';

  @override
  String get onboardingStepTargetDetail =>
      'Wir werten dein Muster aus und schlagen dir dein Stint-Intervall vor.';

  @override
  String get onboardingStepRaceTitle => 'Das Rennen läuft';

  @override
  String get onboardingStepRaceDetail =>
      'Stints dehnen, Streak bauen, Wagen freifahren.';

  @override
  String get onboardingStartMeasuringLap => 'MESSRUNDE STARTEN';

  @override
  String get cockpitBaselineMeasuring => 'Wir messen dein Tempo';

  @override
  String get cockpitBaselineEndsToday => 'endet heute';

  @override
  String get cockpitBaselineEndsTomorrow => 'endet morgen';

  @override
  String cockpitBaselineDaysLeft(Object days) {
    return 'noch $days Tage';
  }

  @override
  String get cockpitStatSaved => 'Gespart';

  @override
  String get cockpitStatAvoided => 'Vermieden';

  @override
  String get cockpitStatInRace => 'Im Rennen';

  @override
  String get cockpitGaugeMeasuringLap => 'MESSRUNDE';

  @override
  String get cockpitGaugeNextStint => 'NÄCHSTER STINT';

  @override
  String cockpitGaugeTarget(Object target) {
    return 'Ziel: $target';
  }

  @override
  String get cockpitGaugeOvertime => 'OVERTIME';

  @override
  String cockpitGaugeBonusLap(Object lap) {
    return 'Bonus-Runde $lap — du fährst vorne! 🔥';
  }

  @override
  String get cockpitGaugeBonusTime => 'geschenkte Zeit — du fährst vorne!';

  @override
  String get cockpitPitButtonTitle => 'BOXENSTOPP';

  @override
  String get cockpitPitButtonSubtitle => 'Zigarette geraucht  ·  +1';

  @override
  String get cockpitSosButton => 'VERLANGEN? DURCHATMEN';

  @override
  String cockpitStreakDay(Object days) {
    return '$days Tag';
  }

  @override
  String cockpitStreakDays(Object days) {
    return '$days Tage';
  }

  @override
  String get cockpitStreakLabel => 'Streak';

  @override
  String get cockpitPitStopTitle => 'Boxenstopp';

  @override
  String get cockpitPitStopSubtitle =>
      'Kurz festhalten — daraus lernt deine Analyse.';

  @override
  String get cockpitCraving => 'Verlangen';

  @override
  String get cockpitStress => 'Stress';

  @override
  String get cockpitSituation => 'Situation';

  @override
  String get cockpitSituationNew => '+ Neu';

  @override
  String cockpitLevelValue(Object value) {
    return '$value/5';
  }

  @override
  String get cockpitNoteHint => 'Notiz (optional)';

  @override
  String get cockpitSubmit => 'EINTRAGEN';

  @override
  String get cockpitNewSituationTitle => 'Neue Situation';

  @override
  String get cockpitNewSituationHint => 'z. B. Pause, Telefonat …';

  @override
  String get cockpitCancel => 'Abbrechen';

  @override
  String get cockpitCreate => 'Anlegen';

  @override
  String get sosInhale => 'Einatmen';

  @override
  String get sosHold => 'Halten';

  @override
  String get sosExhale => 'Ausatmen';

  @override
  String get sosCravingPassing => 'VERLANGEN REITET VORBEI';

  @override
  String get sosBreatheAlong => 'Atme mit. Du musst nichts tun.';

  @override
  String get sosNoBreathYet => 'Noch kein voller Atemzug';

  @override
  String sosBreathsDone(Object count) {
    return '$count Atemzüge geschafft';
  }

  @override
  String get sosStopButton => 'GEHT WIEDER — STOPP';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsPriceIntro =>
      'Preis oder Packungsgröße geändert? Neue Werte gelten ab jetzt — bisher Gespartes bleibt zum alten Preis erhalten.';

  @override
  String get settingsPricePerPack => 'Preis pro Schachtel';

  @override
  String get settingsCigarettesPerPack => 'Kippen pro Schachtel';

  @override
  String get settingsCigarettesPerDay => 'Kippen pro Tag (vorher)';

  @override
  String get settingsBaselineHint =>
      'Deine Vergleichsbasis. Ändern verfälscht Gespart & Vermieden — nur korrigieren, wenn du dich vertippt hast.';

  @override
  String get settingsSleepTime => 'SCHLAFENSZEIT';

  @override
  String get settingsSleepHint => 'Schlaf zählt nicht für Stints & Bestzeiten.';

  @override
  String get settingsFrom => 'Von';

  @override
  String get settingsTo => 'Bis';

  @override
  String get settingsHistory => 'VERLAUF';

  @override
  String get settingsSaveButton => 'SPEICHERN';

  @override
  String get settingsSave => 'Speichern';

  @override
  String get settingsCancel => 'Abbrechen';

  @override
  String get settingsResetEverything => 'ALLES ZURÜCKSETZEN';

  @override
  String get settingsResetTitle => 'Alles zurücksetzen?';

  @override
  String get settingsResetBody =>
      'Alle Daten werden gelöscht: Einstellungen, Boxenstopps, Erfolge und Autos. Du startest wieder beim Welcome-Screen. Das lässt sich nicht rückgängig machen.';

  @override
  String get settingsResetConfirm => 'Zurücksetzen';

  @override
  String get settingsBaselineChangeTitle => 'Tageskonsum ändern?';

  @override
  String get settingsBaselineChangeBody =>
      'Dein Tageskonsum ist die Vergleichsbasis. Ihn zu ändern verfälscht deine angezeigten Werte (Gespart, Vermieden) deutlich. Trotzdem speichern?';

  @override
  String get settingsInvalidValues => 'Trag bitte gültige Werte ein.';

  @override
  String get settingsSaved => 'Gespeichert.';

  @override
  String settingsHistorySince(Object date) {
    return 'seit $date';
  }

  @override
  String settingsHistoryPriceLine(Object price, Object count) {
    return '$price · $count/Schachtel';
  }

  @override
  String get journalTitle => 'Journal';

  @override
  String get journalSituations => 'Situationen';

  @override
  String journalRaceReportWeek(Object week) {
    return 'RENNBERICHT · WOCHE $week';
  }

  @override
  String journalEvery(Object duration) {
    return 'alle $duration';
  }

  @override
  String get journalMedianPace => 'Median-Pace';

  @override
  String get journalCigarettes => 'Kippen';

  @override
  String get journalSpin => 'Dreher';

  @override
  String journalFewer(Object count) {
    return '$count weniger 🏁';
  }

  @override
  String get journalDeletePitStopTitle => 'Boxenstopp löschen?';

  @override
  String get journalDeletePitStopBody =>
      'Versehentlich doppelt erfasst? Löschen verändert deine angezeigten Werte (Gespart, Vermieden, Streak).';

  @override
  String get journalCancel => 'Abbrechen';

  @override
  String get journalDelete => 'Löschen';

  @override
  String get journalSpinBadge => 'DREHER';

  @override
  String get journalCraving => 'Verlangen';

  @override
  String get journalStress => 'Stress';

  @override
  String get journalEmptyTitle => 'Noch keine Boxenstopps';

  @override
  String get journalEmptyBody =>
      'Und das ist gut so. Sobald du einen Boxenstopp einträgst, siehst du hier dein Muster.';

  @override
  String get situationsIntro => 'Lege an, was zu deinem Alltag passt.';

  @override
  String get situationsNewHint => 'Neue Situation';

  @override
  String get trophiesTitle => 'Pokalvitrine';

  @override
  String get trophiesGarageSection => 'GARAGE';

  @override
  String get trophiesMilestonesSection => 'MEILENSTEINE';

  @override
  String get trophiesUnlocked => 'freigeschaltet';

  @override
  String get trophiesGarageComplete =>
      'Garage komplett — alles freigeschaltet!';

  @override
  String trophiesGarageRemaining(Object amount, Object car) {
    return 'Noch $amount bis $car';
  }

  @override
  String get trophiesYourRide => 'DEIN WAGEN';

  @override
  String trophiesCigsCount(Object count) {
    return '$count Kippen';
  }

  @override
  String get shareLabel => 'Teilen';

  @override
  String get shareButton => 'TEILEN';

  @override
  String get shareCurrentLap => 'AKTUELLE RUNDE';

  @override
  String shareCurrentLapText(Object clock) {
    return 'Aktuelle Runde: $clock ohne Zigarette. 🏁';
  }

  @override
  String get shareMilestone => 'MEILENSTEIN';

  @override
  String shareMilestoneText(Object title) {
    return 'Meilenstein geknackt: $title 🏁';
  }

  @override
  String get sharePitStopReport => 'BOXENSTOPP-\nREPORT';

  @override
  String get shareSaved => 'GESPART';

  @override
  String get shareAvoided => 'VERMIEDEN';

  @override
  String get shareStreak => 'STREAK';

  @override
  String shareStreakDays(Object days) {
    return '$days T';
  }

  @override
  String get analysisTitle => 'Race Analysis';

  @override
  String get analysisTriggers => 'Deine Auslöser';

  @override
  String get analysisLast7Days => 'Letzte 7 Tage';

  @override
  String get analysisMedianPace => 'MEDIAN-PACE';

  @override
  String analysisEvery(Object duration) {
    return 'alle $duration';
  }

  @override
  String get analysisCollecting => 'sammelt noch …';

  @override
  String get analysisMedianHint =>
      'Typischer Abstand zwischen zwei Kippen — je größer, desto besser 🏁';

  @override
  String get analysisMedianEmptyHint =>
      'Trag ein paar Boxenstopps ein, dann erscheint dein Schnitt.';

  @override
  String get analysisSameAsLastWeek => '= Vorwoche';

  @override
  String get analysisAvgCraving => '⌀ Verlangen';

  @override
  String get analysisAvgStress => '⌀ Stress';

  @override
  String get analysisSpins => 'Dreher';

  @override
  String get analysisWeekdayMon => 'M';

  @override
  String get analysisWeekdayTue => 'D';

  @override
  String get analysisWeekdayWed => 'M';

  @override
  String get analysisWeekdayThu => 'D';

  @override
  String get analysisWeekdayFri => 'F';

  @override
  String get analysisWeekdaySat => 'S';

  @override
  String get analysisWeekdaySun => 'S';

  @override
  String get analysisEmptyTitle => 'Noch keine Telemetrie';

  @override
  String get analysisEmptyBody =>
      'Sobald du Boxenstopps einträgst, erkennen wir hier dein Muster — wann, wo und wie stark dein Verlangen ist.';

  @override
  String get proposalStretchCheck => 'STRECKEN-CHECK';

  @override
  String get proposalWeekDone => 'Woche geschafft!';

  @override
  String get proposalFirstTargetPrompt =>
      'Die Messrunde ist rum. Setzen wir dein erstes Ziel-Intervall?';

  @override
  String get proposalStretchPrompt =>
      'Stark gefahren. Dehnen wir den Abstand zwischen zwei Kippen?';

  @override
  String get proposalNewTarget => 'NEUES ZIEL';

  @override
  String proposalEvery(Object duration) {
    return 'alle $duration';
  }

  @override
  String proposalMoreRoom(Object duration) {
    return '+$duration mehr Luft pro Stint';
  }

  @override
  String get proposalStretchBy => 'Dehnen um';

  @override
  String proposalPercent(Object pct) {
    return '+$pct %';
  }

  @override
  String get proposalApply => 'ÜBERNEHMEN';

  @override
  String get proposalKeepIt => 'Bleibt so';

  @override
  String get proposalTargetSet => 'Ziel gesetzt!';

  @override
  String get proposalAcceptedHint => 'Auf geht\'s. Du fährst das jetzt.';

  @override
  String get celebrationMilestone => 'MEILENSTEIN';

  @override
  String get celebrationLetsGo => 'LASS KRACHEN';

  @override
  String get celebrationShareAsCard => 'Als Karte teilen';

  @override
  String get recoveryTitle => 'Recovery';

  @override
  String get recoverySubtitle => 'So heilt dein Körper, wenn du nicht rauchst.';

  @override
  String get recoveryEveryStintHeals => 'Jeder Stint heilt';

  @override
  String recoveryCurrentStint(Object duration) {
    return 'Aktueller Stint: $duration';
  }

  @override
  String get recoveryLongTerm => 'Langzeit — wenn du rauchfrei wirst';

  @override
  String get recoverySources =>
      'Quellen: American Cancer Society, NHS / US Surgeon General.';
}
