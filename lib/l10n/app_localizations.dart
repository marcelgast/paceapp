import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Pace'**
  String get appTitle;

  /// No description provided for @tabCockpit.
  ///
  /// In de, this message translates to:
  /// **'Cockpit'**
  String get tabCockpit;

  /// No description provided for @tabAnalysis.
  ///
  /// In de, this message translates to:
  /// **'Analyse'**
  String get tabAnalysis;

  /// No description provided for @tabBody.
  ///
  /// In de, this message translates to:
  /// **'Körper'**
  String get tabBody;

  /// No description provided for @tabTrophies.
  ///
  /// In de, this message translates to:
  /// **'Pokale'**
  String get tabTrophies;

  /// No description provided for @tabJournal.
  ///
  /// In de, this message translates to:
  /// **'Journal'**
  String get tabJournal;

  /// No description provided for @boxenstopp.
  ///
  /// In de, this message translates to:
  /// **'Boxenstopp'**
  String get boxenstopp;

  /// No description provided for @onboardingInvalidValue.
  ///
  /// In de, this message translates to:
  /// **'Trag bitte einen gültigen Wert ein.'**
  String get onboardingInvalidValue;

  /// No description provided for @onboardingTagline.
  ///
  /// In de, this message translates to:
  /// **'Kein Stopp-Datum. Nur dein Tempo.'**
  String get onboardingTagline;

  /// No description provided for @onboardingPitCheck1of3.
  ///
  /// In de, this message translates to:
  /// **'BOXEN-CHECK · 1/3'**
  String get onboardingPitCheck1of3;

  /// No description provided for @onboardingPitCheck2of3.
  ///
  /// In de, this message translates to:
  /// **'BOXEN-CHECK · 2/3'**
  String get onboardingPitCheck2of3;

  /// No description provided for @onboardingPitCheck3of3.
  ///
  /// In de, this message translates to:
  /// **'BOXEN-CHECK · 3/3'**
  String get onboardingPitCheck3of3;

  /// No description provided for @onboardingPackPriceHeadline.
  ///
  /// In de, this message translates to:
  /// **'Was kostet dich eine Schachtel?'**
  String get onboardingPackPriceHeadline;

  /// No description provided for @onboardingPackPriceSub.
  ///
  /// In de, this message translates to:
  /// **'Damit zählen wir jeden Euro, den du zurückholst.'**
  String get onboardingPackPriceSub;

  /// No description provided for @onboardingPerPackHeadline.
  ///
  /// In de, this message translates to:
  /// **'Wie viele Kippen sind drin?'**
  String get onboardingPerPackHeadline;

  /// No description provided for @onboardingPerPackSub.
  ///
  /// In de, this message translates to:
  /// **'Standard sind 20 — pass es an deine Marke an.'**
  String get onboardingPerPackSub;

  /// No description provided for @onboardingPerDayHeadline.
  ///
  /// In de, this message translates to:
  /// **'Wie viele am Tag — ehrlich?'**
  String get onboardingPerDayHeadline;

  /// No description provided for @onboardingPerDaySub.
  ///
  /// In de, this message translates to:
  /// **'Keine Wertung. Das ist nur deine Startlinie.'**
  String get onboardingPerDaySub;

  /// No description provided for @onboardingNext.
  ///
  /// In de, this message translates to:
  /// **'WEITER'**
  String get onboardingNext;

  /// No description provided for @onboardingCountdown.
  ///
  /// In de, this message translates to:
  /// **'3 · 2 · 1 …'**
  String get onboardingCountdown;

  /// No description provided for @onboardingWelcomeEyebrow.
  ///
  /// In de, this message translates to:
  /// **'WILLKOMMEN BEI PACE'**
  String get onboardingWelcomeEyebrow;

  /// No description provided for @onboardingWelcomeHeadline.
  ///
  /// In de, this message translates to:
  /// **'Dein Rennen, dein Tempo'**
  String get onboardingWelcomeHeadline;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In de, this message translates to:
  /// **'Pace bringt dich rauchfrei — Schritt für Schritt, ohne kalten Entzug. Lass dich drauf ein, und das Programm trägt dich in deinem Tempo.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingFeatureObserveTitle.
  ///
  /// In de, this message translates to:
  /// **'Erst beobachten'**
  String get onboardingFeatureObserveTitle;

  /// No description provided for @onboardingFeatureObserveDetail.
  ///
  /// In de, this message translates to:
  /// **'Einen Tag fährst du wie immer — wir lernen still dein Tempo.'**
  String get onboardingFeatureObserveDetail;

  /// No description provided for @onboardingFeatureStretchTitle.
  ///
  /// In de, this message translates to:
  /// **'Dann dehnen'**
  String get onboardingFeatureStretchTitle;

  /// No description provided for @onboardingFeatureStretchDetail.
  ///
  /// In de, this message translates to:
  /// **'Woche für Woche etwas mehr Zeit zwischen zwei Zigaretten — immer nur, wenn du bereit bist.'**
  String get onboardingFeatureStretchDetail;

  /// No description provided for @onboardingFeatureCelebrateTitle.
  ///
  /// In de, this message translates to:
  /// **'Unterwegs feiern'**
  String get onboardingFeatureCelebrateTitle;

  /// No description provided for @onboardingFeatureCelebrateDetail.
  ///
  /// In de, this message translates to:
  /// **'Schalte Erfolge frei und fahr dir vom gesparten Geld bessere Autos frei.'**
  String get onboardingFeatureCelebrateDetail;

  /// No description provided for @onboardingFeatureEmergencyTitle.
  ///
  /// In de, this message translates to:
  /// **'Für den Notfall'**
  String get onboardingFeatureEmergencyTitle;

  /// No description provided for @onboardingFeatureEmergencyDetail.
  ///
  /// In de, this message translates to:
  /// **'Akutes Verlangen? Die bewährte Atemübung holt dich da durch.'**
  String get onboardingFeatureEmergencyDetail;

  /// No description provided for @onboardingWelcomeClosing.
  ///
  /// In de, this message translates to:
  /// **'Jeder schafft das. In seinem Tempo.'**
  String get onboardingWelcomeClosing;

  /// No description provided for @onboardingLetsGo.
  ///
  /// In de, this message translates to:
  /// **'LOS GEHT\'S'**
  String get onboardingLetsGo;

  /// No description provided for @onboardingSleepEyebrow.
  ///
  /// In de, this message translates to:
  /// **'DEIN SCHLAF'**
  String get onboardingSleepEyebrow;

  /// No description provided for @onboardingSleepHeadline.
  ///
  /// In de, this message translates to:
  /// **'Wann schläfst du ungefähr?'**
  String get onboardingSleepHeadline;

  /// No description provided for @onboardingSleepBody.
  ///
  /// In de, this message translates to:
  /// **'Schlaf zählt nicht für Stints und Bestzeiten — sonst wäre die Nacht immer deine längste Strecke. Später in den Einstellungen änderbar.'**
  String get onboardingSleepBody;

  /// No description provided for @onboardingSleepFrom.
  ///
  /// In de, this message translates to:
  /// **'Von'**
  String get onboardingSleepFrom;

  /// No description provided for @onboardingSleepTo.
  ///
  /// In de, this message translates to:
  /// **'Bis'**
  String get onboardingSleepTo;

  /// No description provided for @onboardingMeasureEyebrow.
  ///
  /// In de, this message translates to:
  /// **'SO LÄUFT DEIN START'**
  String get onboardingMeasureEyebrow;

  /// No description provided for @onboardingMeasureHeadline.
  ///
  /// In de, this message translates to:
  /// **'Erst messen, dann dehnen'**
  String get onboardingMeasureHeadline;

  /// No description provided for @onboardingMeasureBody.
  ///
  /// In de, this message translates to:
  /// **'Kein kalter Entzug. Am ersten Tag fährst du ganz normal weiter — wir schauen nur zu und lernen dein Tempo.'**
  String get onboardingMeasureBody;

  /// No description provided for @onboardingStepMeasureTitle.
  ///
  /// In de, this message translates to:
  /// **'Messrunde · 1 Tag'**
  String get onboardingStepMeasureTitle;

  /// No description provided for @onboardingStepMeasureDetail.
  ///
  /// In de, this message translates to:
  /// **'Logg jede Zigarette als Boxenstopp. Kein Ziel, kein Druck.'**
  String get onboardingStepMeasureDetail;

  /// No description provided for @onboardingStepTargetTitle.
  ///
  /// In de, this message translates to:
  /// **'Dein erstes Ziel'**
  String get onboardingStepTargetTitle;

  /// No description provided for @onboardingStepTargetDetail.
  ///
  /// In de, this message translates to:
  /// **'Wir werten dein Muster aus und schlagen dir dein Stint-Intervall vor.'**
  String get onboardingStepTargetDetail;

  /// No description provided for @onboardingStepRaceTitle.
  ///
  /// In de, this message translates to:
  /// **'Das Rennen läuft'**
  String get onboardingStepRaceTitle;

  /// No description provided for @onboardingStepRaceDetail.
  ///
  /// In de, this message translates to:
  /// **'Stints dehnen, Streak bauen, Wagen freifahren.'**
  String get onboardingStepRaceDetail;

  /// No description provided for @onboardingStartMeasuringLap.
  ///
  /// In de, this message translates to:
  /// **'MESSRUNDE STARTEN'**
  String get onboardingStartMeasuringLap;

  /// No description provided for @cockpitBaselineMeasuring.
  ///
  /// In de, this message translates to:
  /// **'Wir messen dein Tempo'**
  String get cockpitBaselineMeasuring;

  /// No description provided for @cockpitBaselineEndsToday.
  ///
  /// In de, this message translates to:
  /// **'endet heute'**
  String get cockpitBaselineEndsToday;

  /// No description provided for @cockpitBaselineEndsTomorrow.
  ///
  /// In de, this message translates to:
  /// **'endet morgen'**
  String get cockpitBaselineEndsTomorrow;

  /// No description provided for @cockpitBaselineDaysLeft.
  ///
  /// In de, this message translates to:
  /// **'noch {days} Tage'**
  String cockpitBaselineDaysLeft(Object days);

  /// No description provided for @cockpitStatSaved.
  ///
  /// In de, this message translates to:
  /// **'Gespart'**
  String get cockpitStatSaved;

  /// No description provided for @cockpitStatAvoided.
  ///
  /// In de, this message translates to:
  /// **'Vermieden'**
  String get cockpitStatAvoided;

  /// No description provided for @cockpitStatInRace.
  ///
  /// In de, this message translates to:
  /// **'Im Rennen'**
  String get cockpitStatInRace;

  /// No description provided for @cockpitGaugeMeasuringLap.
  ///
  /// In de, this message translates to:
  /// **'MESSRUNDE'**
  String get cockpitGaugeMeasuringLap;

  /// No description provided for @cockpitGaugeNextStint.
  ///
  /// In de, this message translates to:
  /// **'NÄCHSTER STINT'**
  String get cockpitGaugeNextStint;

  /// No description provided for @cockpitGaugeTarget.
  ///
  /// In de, this message translates to:
  /// **'Ziel: {target}'**
  String cockpitGaugeTarget(Object target);

  /// No description provided for @cockpitGaugeOvertime.
  ///
  /// In de, this message translates to:
  /// **'OVERTIME'**
  String get cockpitGaugeOvertime;

  /// No description provided for @cockpitGaugeBonusLap.
  ///
  /// In de, this message translates to:
  /// **'Bonus-Runde {lap} — du fährst vorne! 🔥'**
  String cockpitGaugeBonusLap(Object lap);

  /// No description provided for @cockpitGaugeBonusTime.
  ///
  /// In de, this message translates to:
  /// **'geschenkte Zeit — du fährst vorne!'**
  String get cockpitGaugeBonusTime;

  /// No description provided for @cockpitPitButtonTitle.
  ///
  /// In de, this message translates to:
  /// **'BOXENSTOPP'**
  String get cockpitPitButtonTitle;

  /// No description provided for @cockpitPitButtonSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Zigarette geraucht  ·  +1'**
  String get cockpitPitButtonSubtitle;

  /// No description provided for @cockpitSosButton.
  ///
  /// In de, this message translates to:
  /// **'VERLANGEN? DURCHATMEN'**
  String get cockpitSosButton;

  /// No description provided for @cockpitStreakDay.
  ///
  /// In de, this message translates to:
  /// **'{days} Tag'**
  String cockpitStreakDay(Object days);

  /// No description provided for @cockpitStreakDays.
  ///
  /// In de, this message translates to:
  /// **'{days} Tage'**
  String cockpitStreakDays(Object days);

  /// No description provided for @cockpitStreakLabel.
  ///
  /// In de, this message translates to:
  /// **'Streak'**
  String get cockpitStreakLabel;

  /// No description provided for @cockpitPitStopTitle.
  ///
  /// In de, this message translates to:
  /// **'Boxenstopp'**
  String get cockpitPitStopTitle;

  /// No description provided for @cockpitPitStopSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Kurz festhalten — daraus lernt deine Analyse.'**
  String get cockpitPitStopSubtitle;

  /// No description provided for @cockpitCraving.
  ///
  /// In de, this message translates to:
  /// **'Verlangen'**
  String get cockpitCraving;

  /// No description provided for @cockpitStress.
  ///
  /// In de, this message translates to:
  /// **'Stress'**
  String get cockpitStress;

  /// No description provided for @cockpitSituation.
  ///
  /// In de, this message translates to:
  /// **'Situation'**
  String get cockpitSituation;

  /// No description provided for @cockpitSituationNew.
  ///
  /// In de, this message translates to:
  /// **'+ Neu'**
  String get cockpitSituationNew;

  /// No description provided for @cockpitLevelValue.
  ///
  /// In de, this message translates to:
  /// **'{value}/5'**
  String cockpitLevelValue(Object value);

  /// No description provided for @cockpitNoteHint.
  ///
  /// In de, this message translates to:
  /// **'Notiz (optional)'**
  String get cockpitNoteHint;

  /// No description provided for @cockpitSubmit.
  ///
  /// In de, this message translates to:
  /// **'EINTRAGEN'**
  String get cockpitSubmit;

  /// No description provided for @cockpitNewSituationTitle.
  ///
  /// In de, this message translates to:
  /// **'Neue Situation'**
  String get cockpitNewSituationTitle;

  /// No description provided for @cockpitNewSituationHint.
  ///
  /// In de, this message translates to:
  /// **'z. B. Pause, Telefonat …'**
  String get cockpitNewSituationHint;

  /// No description provided for @cockpitCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cockpitCancel;

  /// No description provided for @cockpitCreate.
  ///
  /// In de, this message translates to:
  /// **'Anlegen'**
  String get cockpitCreate;

  /// No description provided for @sosInhale.
  ///
  /// In de, this message translates to:
  /// **'Einatmen'**
  String get sosInhale;

  /// No description provided for @sosHold.
  ///
  /// In de, this message translates to:
  /// **'Halten'**
  String get sosHold;

  /// No description provided for @sosExhale.
  ///
  /// In de, this message translates to:
  /// **'Ausatmen'**
  String get sosExhale;

  /// No description provided for @sosCravingPassing.
  ///
  /// In de, this message translates to:
  /// **'VERLANGEN REITET VORBEI'**
  String get sosCravingPassing;

  /// No description provided for @sosBreatheAlong.
  ///
  /// In de, this message translates to:
  /// **'Atme mit. Du musst nichts tun.'**
  String get sosBreatheAlong;

  /// No description provided for @sosNoBreathYet.
  ///
  /// In de, this message translates to:
  /// **'Noch kein voller Atemzug'**
  String get sosNoBreathYet;

  /// No description provided for @sosBreathsDone.
  ///
  /// In de, this message translates to:
  /// **'{count} Atemzüge geschafft'**
  String sosBreathsDone(Object count);

  /// No description provided for @sosStopButton.
  ///
  /// In de, this message translates to:
  /// **'GEHT WIEDER — STOPP'**
  String get sosStopButton;

  /// No description provided for @settingsTitle.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settingsTitle;

  /// No description provided for @settingsPriceIntro.
  ///
  /// In de, this message translates to:
  /// **'Preis oder Packungsgröße geändert? Neue Werte gelten ab jetzt — bisher Gespartes bleibt zum alten Preis erhalten.'**
  String get settingsPriceIntro;

  /// No description provided for @settingsPricePerPack.
  ///
  /// In de, this message translates to:
  /// **'Preis pro Schachtel'**
  String get settingsPricePerPack;

  /// No description provided for @settingsCigarettesPerPack.
  ///
  /// In de, this message translates to:
  /// **'Kippen pro Schachtel'**
  String get settingsCigarettesPerPack;

  /// No description provided for @settingsCigarettesPerDay.
  ///
  /// In de, this message translates to:
  /// **'Kippen pro Tag (vorher)'**
  String get settingsCigarettesPerDay;

  /// No description provided for @settingsBaselineHint.
  ///
  /// In de, this message translates to:
  /// **'Deine Vergleichsbasis. Ändern verfälscht Gespart & Vermieden — nur korrigieren, wenn du dich vertippt hast.'**
  String get settingsBaselineHint;

  /// No description provided for @settingsSleepTime.
  ///
  /// In de, this message translates to:
  /// **'SCHLAFENSZEIT'**
  String get settingsSleepTime;

  /// No description provided for @settingsSleepHint.
  ///
  /// In de, this message translates to:
  /// **'Schlaf zählt nicht für Stints & Bestzeiten.'**
  String get settingsSleepHint;

  /// No description provided for @settingsFrom.
  ///
  /// In de, this message translates to:
  /// **'Von'**
  String get settingsFrom;

  /// No description provided for @settingsTo.
  ///
  /// In de, this message translates to:
  /// **'Bis'**
  String get settingsTo;

  /// No description provided for @settingsHistory.
  ///
  /// In de, this message translates to:
  /// **'VERLAUF'**
  String get settingsHistory;

  /// No description provided for @settingsSaveButton.
  ///
  /// In de, this message translates to:
  /// **'SPEICHERN'**
  String get settingsSaveButton;

  /// No description provided for @settingsSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get settingsSave;

  /// No description provided for @settingsCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get settingsCancel;

  /// No description provided for @settingsResetEverything.
  ///
  /// In de, this message translates to:
  /// **'ALLES ZURÜCKSETZEN'**
  String get settingsResetEverything;

  /// No description provided for @settingsResetTitle.
  ///
  /// In de, this message translates to:
  /// **'Alles zurücksetzen?'**
  String get settingsResetTitle;

  /// No description provided for @settingsResetBody.
  ///
  /// In de, this message translates to:
  /// **'Alle Daten werden gelöscht: Einstellungen, Boxenstopps, Erfolge und Autos. Du startest wieder beim Welcome-Screen. Das lässt sich nicht rückgängig machen.'**
  String get settingsResetBody;

  /// No description provided for @settingsResetConfirm.
  ///
  /// In de, this message translates to:
  /// **'Zurücksetzen'**
  String get settingsResetConfirm;

  /// No description provided for @settingsBaselineChangeTitle.
  ///
  /// In de, this message translates to:
  /// **'Tageskonsum ändern?'**
  String get settingsBaselineChangeTitle;

  /// No description provided for @settingsBaselineChangeBody.
  ///
  /// In de, this message translates to:
  /// **'Dein Tageskonsum ist die Vergleichsbasis. Ihn zu ändern verfälscht deine angezeigten Werte (Gespart, Vermieden) deutlich. Trotzdem speichern?'**
  String get settingsBaselineChangeBody;

  /// No description provided for @settingsInvalidValues.
  ///
  /// In de, this message translates to:
  /// **'Trag bitte gültige Werte ein.'**
  String get settingsInvalidValues;

  /// No description provided for @settingsSaved.
  ///
  /// In de, this message translates to:
  /// **'Gespeichert.'**
  String get settingsSaved;

  /// No description provided for @settingsHistorySince.
  ///
  /// In de, this message translates to:
  /// **'seit {date}'**
  String settingsHistorySince(Object date);

  /// No description provided for @settingsHistoryPriceLine.
  ///
  /// In de, this message translates to:
  /// **'{price} · {count}/Schachtel'**
  String settingsHistoryPriceLine(Object price, Object count);

  /// No description provided for @journalTitle.
  ///
  /// In de, this message translates to:
  /// **'Journal'**
  String get journalTitle;

  /// No description provided for @journalSituations.
  ///
  /// In de, this message translates to:
  /// **'Situationen'**
  String get journalSituations;

  /// No description provided for @journalRaceReportWeek.
  ///
  /// In de, this message translates to:
  /// **'RENNBERICHT · WOCHE {week}'**
  String journalRaceReportWeek(Object week);

  /// No description provided for @journalEvery.
  ///
  /// In de, this message translates to:
  /// **'alle {duration}'**
  String journalEvery(Object duration);

  /// No description provided for @journalMedianPace.
  ///
  /// In de, this message translates to:
  /// **'Median-Pace'**
  String get journalMedianPace;

  /// No description provided for @journalCigarettes.
  ///
  /// In de, this message translates to:
  /// **'Kippen'**
  String get journalCigarettes;

  /// No description provided for @journalSpin.
  ///
  /// In de, this message translates to:
  /// **'Dreher'**
  String get journalSpin;

  /// No description provided for @journalFewer.
  ///
  /// In de, this message translates to:
  /// **'{count} weniger 🏁'**
  String journalFewer(Object count);

  /// No description provided for @journalDeletePitStopTitle.
  ///
  /// In de, this message translates to:
  /// **'Boxenstopp löschen?'**
  String get journalDeletePitStopTitle;

  /// No description provided for @journalDeletePitStopBody.
  ///
  /// In de, this message translates to:
  /// **'Versehentlich doppelt erfasst? Löschen verändert deine angezeigten Werte (Gespart, Vermieden, Streak).'**
  String get journalDeletePitStopBody;

  /// No description provided for @journalCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get journalCancel;

  /// No description provided for @journalDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get journalDelete;

  /// No description provided for @journalSpinBadge.
  ///
  /// In de, this message translates to:
  /// **'DREHER'**
  String get journalSpinBadge;

  /// No description provided for @journalCraving.
  ///
  /// In de, this message translates to:
  /// **'Verlangen'**
  String get journalCraving;

  /// No description provided for @journalStress.
  ///
  /// In de, this message translates to:
  /// **'Stress'**
  String get journalStress;

  /// No description provided for @journalEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Boxenstopps'**
  String get journalEmptyTitle;

  /// No description provided for @journalEmptyBody.
  ///
  /// In de, this message translates to:
  /// **'Und das ist gut so. Sobald du einen Boxenstopp einträgst, siehst du hier dein Muster.'**
  String get journalEmptyBody;

  /// No description provided for @situationsIntro.
  ///
  /// In de, this message translates to:
  /// **'Lege an, was zu deinem Alltag passt.'**
  String get situationsIntro;

  /// No description provided for @situationsNewHint.
  ///
  /// In de, this message translates to:
  /// **'Neue Situation'**
  String get situationsNewHint;

  /// No description provided for @trophiesTitle.
  ///
  /// In de, this message translates to:
  /// **'Pokalvitrine'**
  String get trophiesTitle;

  /// No description provided for @trophiesGarageSection.
  ///
  /// In de, this message translates to:
  /// **'GARAGE'**
  String get trophiesGarageSection;

  /// No description provided for @trophiesMilestonesSection.
  ///
  /// In de, this message translates to:
  /// **'MEILENSTEINE'**
  String get trophiesMilestonesSection;

  /// No description provided for @trophiesUnlocked.
  ///
  /// In de, this message translates to:
  /// **'freigeschaltet'**
  String get trophiesUnlocked;

  /// No description provided for @trophiesGarageComplete.
  ///
  /// In de, this message translates to:
  /// **'Garage komplett — alles freigeschaltet!'**
  String get trophiesGarageComplete;

  /// No description provided for @trophiesGarageRemaining.
  ///
  /// In de, this message translates to:
  /// **'Noch {amount} bis {car}'**
  String trophiesGarageRemaining(Object amount, Object car);

  /// No description provided for @trophiesYourRide.
  ///
  /// In de, this message translates to:
  /// **'DEIN WAGEN'**
  String get trophiesYourRide;

  /// No description provided for @trophiesCigsCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Kippen'**
  String trophiesCigsCount(Object count);

  /// No description provided for @shareLabel.
  ///
  /// In de, this message translates to:
  /// **'Teilen'**
  String get shareLabel;

  /// No description provided for @shareButton.
  ///
  /// In de, this message translates to:
  /// **'TEILEN'**
  String get shareButton;

  /// No description provided for @shareCurrentLap.
  ///
  /// In de, this message translates to:
  /// **'AKTUELLE RUNDE'**
  String get shareCurrentLap;

  /// No description provided for @shareCurrentLapText.
  ///
  /// In de, this message translates to:
  /// **'Aktuelle Runde: {clock} ohne Zigarette. 🏁'**
  String shareCurrentLapText(Object clock);

  /// No description provided for @shareMilestone.
  ///
  /// In de, this message translates to:
  /// **'MEILENSTEIN'**
  String get shareMilestone;

  /// No description provided for @shareMilestoneText.
  ///
  /// In de, this message translates to:
  /// **'Meilenstein geknackt: {title} 🏁'**
  String shareMilestoneText(Object title);

  /// No description provided for @sharePitStopReport.
  ///
  /// In de, this message translates to:
  /// **'BOXENSTOPP-\nREPORT'**
  String get sharePitStopReport;

  /// No description provided for @shareSaved.
  ///
  /// In de, this message translates to:
  /// **'GESPART'**
  String get shareSaved;

  /// No description provided for @shareAvoided.
  ///
  /// In de, this message translates to:
  /// **'VERMIEDEN'**
  String get shareAvoided;

  /// No description provided for @shareStreak.
  ///
  /// In de, this message translates to:
  /// **'STREAK'**
  String get shareStreak;

  /// No description provided for @shareStreakDays.
  ///
  /// In de, this message translates to:
  /// **'{days} T'**
  String shareStreakDays(Object days);

  /// No description provided for @analysisTitle.
  ///
  /// In de, this message translates to:
  /// **'Race Analysis'**
  String get analysisTitle;

  /// No description provided for @analysisTriggers.
  ///
  /// In de, this message translates to:
  /// **'Deine Auslöser'**
  String get analysisTriggers;

  /// No description provided for @analysisLast7Days.
  ///
  /// In de, this message translates to:
  /// **'Letzte 7 Tage'**
  String get analysisLast7Days;

  /// No description provided for @analysisMedianPace.
  ///
  /// In de, this message translates to:
  /// **'MEDIAN-PACE'**
  String get analysisMedianPace;

  /// No description provided for @analysisEvery.
  ///
  /// In de, this message translates to:
  /// **'alle {duration}'**
  String analysisEvery(Object duration);

  /// No description provided for @analysisCollecting.
  ///
  /// In de, this message translates to:
  /// **'sammelt noch …'**
  String get analysisCollecting;

  /// No description provided for @analysisMedianHint.
  ///
  /// In de, this message translates to:
  /// **'Typischer Abstand zwischen zwei Kippen — je größer, desto besser 🏁'**
  String get analysisMedianHint;

  /// No description provided for @analysisMedianEmptyHint.
  ///
  /// In de, this message translates to:
  /// **'Trag ein paar Boxenstopps ein, dann erscheint dein Schnitt.'**
  String get analysisMedianEmptyHint;

  /// No description provided for @analysisSameAsLastWeek.
  ///
  /// In de, this message translates to:
  /// **'= Vorwoche'**
  String get analysisSameAsLastWeek;

  /// No description provided for @analysisAvgCraving.
  ///
  /// In de, this message translates to:
  /// **'⌀ Verlangen'**
  String get analysisAvgCraving;

  /// No description provided for @analysisAvgStress.
  ///
  /// In de, this message translates to:
  /// **'⌀ Stress'**
  String get analysisAvgStress;

  /// No description provided for @analysisSpins.
  ///
  /// In de, this message translates to:
  /// **'Dreher'**
  String get analysisSpins;

  /// No description provided for @analysisWeekdayMon.
  ///
  /// In de, this message translates to:
  /// **'M'**
  String get analysisWeekdayMon;

  /// No description provided for @analysisWeekdayTue.
  ///
  /// In de, this message translates to:
  /// **'D'**
  String get analysisWeekdayTue;

  /// No description provided for @analysisWeekdayWed.
  ///
  /// In de, this message translates to:
  /// **'M'**
  String get analysisWeekdayWed;

  /// No description provided for @analysisWeekdayThu.
  ///
  /// In de, this message translates to:
  /// **'D'**
  String get analysisWeekdayThu;

  /// No description provided for @analysisWeekdayFri.
  ///
  /// In de, this message translates to:
  /// **'F'**
  String get analysisWeekdayFri;

  /// No description provided for @analysisWeekdaySat.
  ///
  /// In de, this message translates to:
  /// **'S'**
  String get analysisWeekdaySat;

  /// No description provided for @analysisWeekdaySun.
  ///
  /// In de, this message translates to:
  /// **'S'**
  String get analysisWeekdaySun;

  /// No description provided for @analysisEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Telemetrie'**
  String get analysisEmptyTitle;

  /// No description provided for @analysisEmptyBody.
  ///
  /// In de, this message translates to:
  /// **'Sobald du Boxenstopps einträgst, erkennen wir hier dein Muster — wann, wo und wie stark dein Verlangen ist.'**
  String get analysisEmptyBody;

  /// No description provided for @proposalStretchCheck.
  ///
  /// In de, this message translates to:
  /// **'STRECKEN-CHECK'**
  String get proposalStretchCheck;

  /// No description provided for @proposalWeekDone.
  ///
  /// In de, this message translates to:
  /// **'Woche geschafft!'**
  String get proposalWeekDone;

  /// No description provided for @proposalFirstTargetPrompt.
  ///
  /// In de, this message translates to:
  /// **'Die Messrunde ist rum. Setzen wir dein erstes Ziel-Intervall?'**
  String get proposalFirstTargetPrompt;

  /// No description provided for @proposalStretchPrompt.
  ///
  /// In de, this message translates to:
  /// **'Stark gefahren. Dehnen wir den Abstand zwischen zwei Kippen?'**
  String get proposalStretchPrompt;

  /// No description provided for @proposalNewTarget.
  ///
  /// In de, this message translates to:
  /// **'NEUES ZIEL'**
  String get proposalNewTarget;

  /// No description provided for @proposalEvery.
  ///
  /// In de, this message translates to:
  /// **'alle {duration}'**
  String proposalEvery(Object duration);

  /// No description provided for @proposalMoreRoom.
  ///
  /// In de, this message translates to:
  /// **'+{duration} mehr Luft pro Stint'**
  String proposalMoreRoom(Object duration);

  /// No description provided for @proposalStretchBy.
  ///
  /// In de, this message translates to:
  /// **'Dehnen um'**
  String get proposalStretchBy;

  /// No description provided for @proposalPercent.
  ///
  /// In de, this message translates to:
  /// **'+{pct} %'**
  String proposalPercent(Object pct);

  /// No description provided for @proposalApply.
  ///
  /// In de, this message translates to:
  /// **'ÜBERNEHMEN'**
  String get proposalApply;

  /// No description provided for @proposalKeepIt.
  ///
  /// In de, this message translates to:
  /// **'Bleibt so'**
  String get proposalKeepIt;

  /// No description provided for @proposalTargetSet.
  ///
  /// In de, this message translates to:
  /// **'Ziel gesetzt!'**
  String get proposalTargetSet;

  /// No description provided for @proposalAcceptedHint.
  ///
  /// In de, this message translates to:
  /// **'Auf geht\'s. Du fährst das jetzt.'**
  String get proposalAcceptedHint;

  /// No description provided for @celebrationMilestone.
  ///
  /// In de, this message translates to:
  /// **'MEILENSTEIN'**
  String get celebrationMilestone;

  /// No description provided for @celebrationLetsGo.
  ///
  /// In de, this message translates to:
  /// **'LASS KRACHEN'**
  String get celebrationLetsGo;

  /// No description provided for @celebrationShareAsCard.
  ///
  /// In de, this message translates to:
  /// **'Als Karte teilen'**
  String get celebrationShareAsCard;

  /// No description provided for @recoveryTitle.
  ///
  /// In de, this message translates to:
  /// **'Recovery'**
  String get recoveryTitle;

  /// No description provided for @recoverySubtitle.
  ///
  /// In de, this message translates to:
  /// **'So heilt dein Körper, wenn du nicht rauchst.'**
  String get recoverySubtitle;

  /// No description provided for @recoveryEveryStintHeals.
  ///
  /// In de, this message translates to:
  /// **'Jeder Stint heilt'**
  String get recoveryEveryStintHeals;

  /// No description provided for @recoveryCurrentStint.
  ///
  /// In de, this message translates to:
  /// **'Aktueller Stint: {duration}'**
  String recoveryCurrentStint(Object duration);

  /// No description provided for @recoveryLongTerm.
  ///
  /// In de, this message translates to:
  /// **'Langzeit — wenn du rauchfrei wirst'**
  String get recoveryLongTerm;

  /// No description provided for @recoverySources.
  ///
  /// In de, this message translates to:
  /// **'Quellen: American Cancer Society, NHS / US Surgeon General.'**
  String get recoverySources;

  /// No description provided for @analysisNoSituation.
  ///
  /// In de, this message translates to:
  /// **'Ohne Angabe'**
  String get analysisNoSituation;

  /// No description provided for @raceEngineerTitle.
  ///
  /// In de, this message translates to:
  /// **'Race Engineer'**
  String get raceEngineerTitle;

  /// No description provided for @raceEngineerSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Wann, wo und wie stark dich das Verlangen trifft — und dein Trend.'**
  String get raceEngineerSubtitle;

  /// No description provided for @raceEngineerByHour.
  ///
  /// In de, this message translates to:
  /// **'TAGESZEIT'**
  String get raceEngineerByHour;

  /// No description provided for @raceEngineerPeakHour.
  ///
  /// In de, this message translates to:
  /// **'Spitzenzeit: {hour} Uhr'**
  String raceEngineerPeakHour(Object hour);

  /// No description provided for @raceEngineerByWeekday.
  ///
  /// In de, this message translates to:
  /// **'WOCHENTAGE'**
  String get raceEngineerByWeekday;

  /// No description provided for @raceEngineerTriggers.
  ///
  /// In de, this message translates to:
  /// **'TOP-AUSLÖSER'**
  String get raceEngineerTriggers;

  /// No description provided for @raceEngineerTrend.
  ///
  /// In de, this message translates to:
  /// **'TREND'**
  String get raceEngineerTrend;

  /// No description provided for @raceEngineerTrendDown.
  ///
  /// In de, this message translates to:
  /// **'↓ {amount} weniger pro Tag seit dem Start'**
  String raceEngineerTrendDown(Object amount);

  /// No description provided for @raceEngineerTrendFlat.
  ///
  /// In de, this message translates to:
  /// **'Halte dran — der Trend kommt.'**
  String get raceEngineerTrendFlat;

  /// No description provided for @raceEngineerTrendAxis.
  ///
  /// In de, this message translates to:
  /// **'Zigaretten/Tag · Woche für Woche'**
  String get raceEngineerTrendAxis;

  /// No description provided for @raceEngineerEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Daten'**
  String get raceEngineerEmptyTitle;

  /// No description provided for @raceEngineerEmptyBody.
  ///
  /// In de, this message translates to:
  /// **'Trag ein paar Boxenstopps ein, dann liest der Race Engineer dein Muster aus.'**
  String get raceEngineerEmptyBody;

  /// No description provided for @settingsProSection.
  ///
  /// In de, this message translates to:
  /// **'PACE PRO'**
  String get settingsProSection;

  /// No description provided for @settingsProRaceEngineer.
  ///
  /// In de, this message translates to:
  /// **'Race Engineer'**
  String get settingsProRaceEngineer;

  /// No description provided for @settingsProRaceEngineerSub.
  ///
  /// In de, this message translates to:
  /// **'Deep Analytics — Muster, Auslöser, Trend.'**
  String get settingsProRaceEngineerSub;

  /// No description provided for @settingsProSkin.
  ///
  /// In de, this message translates to:
  /// **'SKIN'**
  String get settingsProSkin;

  /// No description provided for @settingsProLiveActivity.
  ///
  /// In de, this message translates to:
  /// **'Live Activity'**
  String get settingsProLiveActivity;

  /// No description provided for @settingsProLiveActivitySub.
  ///
  /// In de, this message translates to:
  /// **'Stint-Timer in der Dynamic Island & am Lockscreen.'**
  String get settingsProLiveActivitySub;

  /// No description provided for @proBadge.
  ///
  /// In de, this message translates to:
  /// **'PRO'**
  String get proBadge;

  /// No description provided for @settingsProActive.
  ///
  /// In de, this message translates to:
  /// **'Pace Pro aktiv'**
  String get settingsProActive;

  /// No description provided for @settingsProActiveSub.
  ///
  /// In de, this message translates to:
  /// **'Danke! Alle Pro-Features sind freigeschaltet.'**
  String get settingsProActiveSub;

  /// No description provided for @settingsProRestore.
  ///
  /// In de, this message translates to:
  /// **'Käufe wiederherstellen'**
  String get settingsProRestore;

  /// No description provided for @paywallSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Mehr aus deinem Rennen rausholen.'**
  String get paywallSubtitle;

  /// No description provided for @paywallThemesTitle.
  ///
  /// In de, this message translates to:
  /// **'Neon-Skins'**
  String get paywallThemesTitle;

  /// No description provided for @paywallThemesSub.
  ///
  /// In de, this message translates to:
  /// **'10 Skins, die die ganze App umfärben.'**
  String get paywallThemesSub;

  /// No description provided for @paywallUnlock.
  ///
  /// In de, this message translates to:
  /// **'Freischalten · {price}'**
  String paywallUnlock(Object price);

  /// No description provided for @paywallUnlockNoPrice.
  ///
  /// In de, this message translates to:
  /// **'Pace Pro freischalten'**
  String get paywallUnlockNoPrice;

  /// No description provided for @paywallRestore.
  ///
  /// In de, this message translates to:
  /// **'Käufe wiederherstellen'**
  String get paywallRestore;

  /// No description provided for @paywallOneTime.
  ///
  /// In de, this message translates to:
  /// **'Einmalkauf · kein Abo · keine versteckten Kosten'**
  String get paywallOneTime;

  /// No description provided for @paywallError.
  ///
  /// In de, this message translates to:
  /// **'Das hat nicht geklappt. Bitte versuch es nochmal.'**
  String get paywallError;

  /// No description provided for @paywallUnavailable.
  ///
  /// In de, this message translates to:
  /// **'Der App Store ist gerade nicht erreichbar.'**
  String get paywallUnavailable;

  /// No description provided for @raceEngineerUnlock.
  ///
  /// In de, this message translates to:
  /// **'Mit Pace Pro freischalten'**
  String get raceEngineerUnlock;

  /// No description provided for @quitTitle.
  ///
  /// In de, this message translates to:
  /// **'Rauchstopp-Datum'**
  String get quitTitle;

  /// No description provided for @quitPickDate.
  ///
  /// In de, this message translates to:
  /// **'Rauchstopp-Tag wählen'**
  String get quitPickDate;

  /// No description provided for @quitHonestTitle.
  ///
  /// In de, this message translates to:
  /// **'Verlängern ist der Weg — nicht das Ziel'**
  String get quitHonestTitle;

  /// No description provided for @quitHonestBody.
  ///
  /// In de, this message translates to:
  /// **'Die Stints zu dehnen bringt dich weit. Aber irgendwann kommt der ehrlichste Schritt: ganz aufzuhören. Ein festes Datum macht diesen Moment greifbar — und Pace begleitet dich hin.'**
  String get quitHonestBody;

  /// No description provided for @quitTriggersTitle.
  ///
  /// In de, this message translates to:
  /// **'Wappne dich gegen deine Auslöser'**
  String get quitTriggersTitle;

  /// No description provided for @quitTriggersBody.
  ///
  /// In de, this message translates to:
  /// **'Deine häufigsten Auslöser: {triggers}. Leg dir für jeden vorher eine Lösung bereit — dann überrumpelt dich das Verlangen nicht.'**
  String quitTriggersBody(Object triggers);

  /// No description provided for @quitTriggersBodyGeneric.
  ///
  /// In de, this message translates to:
  /// **'Überleg dir, in welchen Momenten du am ehesten zur Zigarette greifst — und leg dir für jeden vorher eine Lösung bereit.'**
  String get quitTriggersBodyGeneric;

  /// No description provided for @quitTriggersTip.
  ///
  /// In de, this message translates to:
  /// **'Z. B. Atemübung, ein Glas Wasser, ein kurzer Gang oder jemanden anrufen.'**
  String get quitTriggersTip;

  /// No description provided for @quitCompanionTitle.
  ///
  /// In de, this message translates to:
  /// **'Pace begleitet dich'**
  String get quitCompanionTitle;

  /// No description provided for @quitCompanionBody.
  ///
  /// In de, this message translates to:
  /// **'Ab dem Tag zählt Pace deine rauchfreien Tage, rückt die Atemübung nach vorn und feiert jeden Schritt mit dir.'**
  String get quitCompanionBody;

  /// No description provided for @quitSetButton.
  ///
  /// In de, this message translates to:
  /// **'Datum festlegen'**
  String get quitSetButton;

  /// No description provided for @quitChangeDate.
  ///
  /// In de, this message translates to:
  /// **'Datum ändern'**
  String get quitChangeDate;

  /// No description provided for @quitRemoveDate.
  ///
  /// In de, this message translates to:
  /// **'Datum entfernen'**
  String get quitRemoveDate;

  /// No description provided for @quitYourDate.
  ///
  /// In de, this message translates to:
  /// **'Dein Rauchstopp-Tag'**
  String get quitYourDate;

  /// No description provided for @proposalSetQuitDate.
  ///
  /// In de, this message translates to:
  /// **'Bereit für ein Rauchstopp-Datum?'**
  String get proposalSetQuitDate;

  /// No description provided for @settingsQuitRowTitle.
  ///
  /// In de, this message translates to:
  /// **'Rauchstopp-Datum setzen'**
  String get settingsQuitRowTitle;

  /// No description provided for @settingsQuitRowSub.
  ///
  /// In de, this message translates to:
  /// **'Optional — Pace begleitet dich durch den Stopp.'**
  String get settingsQuitRowSub;

  /// No description provided for @quitCountdownLabel.
  ///
  /// In de, this message translates to:
  /// **'DEIN RAUCHSTOPP'**
  String get quitCountdownLabel;

  /// No description provided for @quitCountdownTomorrow.
  ///
  /// In de, this message translates to:
  /// **'Morgen ist es soweit!'**
  String get quitCountdownTomorrow;

  /// No description provided for @quitCountdownDays.
  ///
  /// In de, this message translates to:
  /// **'Noch {days} Tage'**
  String quitCountdownDays(Object days);

  /// No description provided for @smokeFreeDayLabel.
  ///
  /// In de, this message translates to:
  /// **'RAUCHFREI SEIT'**
  String get smokeFreeDayLabel;

  /// No description provided for @smokeFreeDaysWord.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{Tag} other{Tagen}}'**
  String smokeFreeDaysWord(int count);

  /// No description provided for @smokeFreeEncouragement.
  ///
  /// In de, this message translates to:
  /// **'Stark. Halt den Kurs — dein Körper erholt sich gerade mit jeder Stunde.'**
  String get smokeFreeEncouragement;

  /// No description provided for @cockpitBreathePrimaryTitle.
  ///
  /// In de, this message translates to:
  /// **'Durchatmen'**
  String get cockpitBreathePrimaryTitle;

  /// No description provided for @cockpitBreathePrimarySub.
  ///
  /// In de, this message translates to:
  /// **'Verlangen kommt in Wellen — atme es weg.'**
  String get cockpitBreathePrimarySub;

  /// No description provided for @cockpitRelapse.
  ///
  /// In de, this message translates to:
  /// **'Doch geraucht? Kein Drama — eintragen.'**
  String get cockpitRelapse;

  /// No description provided for @tabGoals.
  ///
  /// In de, this message translates to:
  /// **'Ziele'**
  String get tabGoals;

  /// No description provided for @goalsTitle.
  ///
  /// In de, this message translates to:
  /// **'Ziele'**
  String get goalsTitle;

  /// No description provided for @goalsSavedPool.
  ///
  /// In de, this message translates to:
  /// **'Gespart bisher: {amount}'**
  String goalsSavedPool(Object amount);

  /// No description provided for @goalsReachedBadge.
  ///
  /// In de, this message translates to:
  /// **'Erreicht'**
  String get goalsReachedBadge;

  /// No description provided for @goalsAdd.
  ///
  /// In de, this message translates to:
  /// **'Ziel hinzufügen'**
  String get goalsAdd;

  /// No description provided for @goalsNameLabel.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get goalsNameLabel;

  /// No description provided for @goalsNameHint.
  ///
  /// In de, this message translates to:
  /// **'z. B. Neue Kopfhörer'**
  String get goalsNameHint;

  /// No description provided for @goalsPriceLabel.
  ///
  /// In de, this message translates to:
  /// **'Preis'**
  String get goalsPriceLabel;

  /// No description provided for @goalsSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get goalsSave;

  /// No description provided for @goalsEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Ziele'**
  String get goalsEmptyTitle;

  /// No description provided for @goalsEmptyBody.
  ///
  /// In de, this message translates to:
  /// **'Setz dir ein Ziel — z. B. Kopfhörer für 79 €. Dein gespartes Geld füllt es Stück für Stück.'**
  String get goalsEmptyBody;

  /// No description provided for @notifGoalTitle.
  ///
  /// In de, this message translates to:
  /// **'Ziel erreicht! 🎉'**
  String get notifGoalTitle;

  /// No description provided for @notifGoalBody.
  ///
  /// In de, this message translates to:
  /// **'„{name}“ ist drin — dein gespartes Geld hat\'s möglich gemacht.'**
  String notifGoalBody(Object name);

  /// No description provided for @notifQuitBeforeTitle.
  ///
  /// In de, this message translates to:
  /// **'Morgen ist dein Rauchstopp-Tag 🏁'**
  String get notifQuitBeforeTitle;

  /// No description provided for @notifQuitBeforeBody.
  ///
  /// In de, this message translates to:
  /// **'Leg dir heute deine Trigger-Lösungen bereit — dann startest du vorbereitet.'**
  String get notifQuitBeforeBody;

  /// No description provided for @notifQuitDayTitle.
  ///
  /// In de, this message translates to:
  /// **'Heute geht\'s los 🏁'**
  String get notifQuitDayTitle;

  /// No description provided for @notifQuitDayBody.
  ///
  /// In de, this message translates to:
  /// **'Dein Rauchstopp-Tag. Du hast das vorbereitet — jetzt zieh\'s durch. Pace ist dabei.'**
  String get notifQuitDayBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
