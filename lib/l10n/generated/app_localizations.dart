import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('si'),
    Locale('ta')
  ];

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @moreTab.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTab;

  /// No description provided for @settingsSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSemanticLabel;

  /// No description provided for @settingsHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to open Settings'**
  String get settingsHint;

  /// No description provided for @openItemHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to open {label}'**
  String openItemHint(String label);

  /// No description provided for @openHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to open'**
  String get openHint;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @saveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// No description provided for @closeLabel.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeLabel;

  /// No description provided for @closeDialogSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Close dialog'**
  String get closeDialogSemanticLabel;

  /// No description provided for @tasbihScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get tasbihScreenTitle;

  /// No description provided for @tasbihCounterSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Tasbih counter'**
  String get tasbihCounterSemanticLabel;

  /// No description provided for @tasbihResetSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset tasbih count'**
  String get tasbihResetSemanticLabel;

  /// No description provided for @resetLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetLabel;

  /// No description provided for @tasbihResetHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to reset the count to zero'**
  String get tasbihResetHint;

  /// No description provided for @tasbihIncrementHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to increment'**
  String get tasbihIncrementHint;

  /// No description provided for @dhikrSelectorSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Dhikr to count'**
  String get dhikrSelectorSemanticLabel;

  /// No description provided for @currentlyCountingLabel.
  ///
  /// In en, this message translates to:
  /// **'Currently counting {dhikr}'**
  String currentlyCountingLabel(String dhikr);

  /// No description provided for @prayerTimesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimesScreenTitle;

  /// No description provided for @openMonthlyTimetableSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Open monthly prayer timetable'**
  String get openMonthlyTimetableSemanticLabel;

  /// No description provided for @monthlyTimetableScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Timetable'**
  String get monthlyTimetableScreenTitle;

  /// No description provided for @useGpsSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get useGpsSemanticLabel;

  /// No description provided for @useGpsHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to resolve your location via GPS'**
  String get useGpsHint;

  /// No description provided for @locatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Locating…'**
  String get locatingLabel;

  /// No description provided for @useMyLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocationLabel;

  /// No description provided for @latitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitudeLabel;

  /// No description provided for @longitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitudeLabel;

  /// No description provided for @applyManualLocationSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply manual coordinates'**
  String get applyManualLocationSemanticLabel;

  /// No description provided for @applyCoordinatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply coordinates'**
  String get applyCoordinatesLabel;

  /// No description provided for @manualLatitudeSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Manual latitude entry'**
  String get manualLatitudeSemanticLabel;

  /// No description provided for @manualLongitudeSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Manual longitude entry'**
  String get manualLongitudeSemanticLabel;

  /// No description provided for @calculationMethodSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Calculation method'**
  String get calculationMethodSemanticLabel;

  /// No description provided for @asrMadhabSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Asr madhab'**
  String get asrMadhabSemanticLabel;

  /// No description provided for @highLatitudeRuleSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'High latitude rule'**
  String get highLatitudeRuleSemanticLabel;

  /// No description provided for @highLatitudeUnresolvedMessage.
  ///
  /// In en, this message translates to:
  /// **'No genuine Isha (or Fajr) time exists for this location and date — the sun does not reach the required angle. Showing an estimated clock time here would be misleading, so none is shown.'**
  String get highLatitudeUnresolvedMessage;

  /// No description provided for @districtSelectorSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Select a Sri Lankan district'**
  String get districtSelectorSemanticLabel;

  /// No description provided for @districtFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Sri Lankan district (optional)'**
  String get districtFieldLabel;

  /// No description provided for @chooseDistrictHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a district'**
  String get chooseDistrictHint;

  /// No description provided for @noneSelectedLabel.
  ///
  /// In en, this message translates to:
  /// **'None selected'**
  String get noneSelectedLabel;

  /// No description provided for @enterLocationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your location to see prayer times.'**
  String get enterLocationPrompt;

  /// No description provided for @activeCalculationSettingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Active calculation settings: {text}'**
  String activeCalculationSettingsLabel(String text);

  /// No description provided for @qiblaScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qiblaScreenTitle;

  /// No description provided for @qiblaNeedleSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Qibla direction needle'**
  String get qiblaNeedleSemanticLabel;

  /// No description provided for @recentreCompassLabel.
  ///
  /// In en, this message translates to:
  /// **'Recentre compass'**
  String get recentreCompassLabel;

  /// No description provided for @qiblaCalibrationPromptMessage.
  ///
  /// In en, this message translates to:
  /// **'Compass reading is uncalibrated or unreliable — move your device in a figure-eight motion to calibrate. The needle is dimmed until then so it is never shown pointing confidently in a wrong direction.'**
  String get qiblaCalibrationPromptMessage;

  /// No description provided for @qiblaNoCompassMessage.
  ///
  /// In en, this message translates to:
  /// **'This device has no compass — showing the qibla bearing as a number only.'**
  String get qiblaNoCompassMessage;

  /// No description provided for @quranScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quranScreenTitle;

  /// No description provided for @bookmarksLabel.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarksLabel;

  /// No description provided for @noBookmarksMessage.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet — tap the bookmark icon on any ayah while reading to save it here.'**
  String get noBookmarksMessage;

  /// No description provided for @searchQuranSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Search the Quran'**
  String get searchQuranSemanticLabel;

  /// No description provided for @searchHintText.
  ///
  /// In en, this message translates to:
  /// **'Search…'**
  String get searchHintText;

  /// No description provided for @searchResultSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Search result: Surah {surahId}, Ayah {ayahNumber}'**
  String searchResultSemanticLabel(int surahId, int ayahNumber);

  /// No description provided for @surahAyahLabel.
  ///
  /// In en, this message translates to:
  /// **'Surah {surahId}, Ayah {ayahNumber}'**
  String surahAyahLabel(int surahId, int ayahNumber);

  /// No description provided for @surahReaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Surah {surahId}'**
  String surahReaderTitle(int surahId);

  /// No description provided for @quranAssetMissingMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a Quran source file to enable this feature.'**
  String get quranAssetMissingMessage;

  /// No description provided for @quranVerificationFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Reinstall or update the app to restore the Quran text — the file on this device did not pass verification.'**
  String get quranVerificationFailedMessage;

  /// No description provided for @importingQuranProgressSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Importing Quran text, {percent} percent complete'**
  String importingQuranProgressSemanticLabel(int percent);

  /// No description provided for @importingQuranLabel.
  ///
  /// In en, this message translates to:
  /// **'Importing Quran text…'**
  String get importingQuranLabel;

  /// No description provided for @azkarScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get azkarScreenTitle;

  /// No description provided for @dhikrCountSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Count for this dhikr: {count} of {total}'**
  String dhikrCountSemanticLabel(int count, int total);

  /// No description provided for @countHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to count one repetition'**
  String get countHint;

  /// No description provided for @sourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source: {source}'**
  String sourceLabel(String source);

  /// No description provided for @nextPrayerLabel.
  ///
  /// In en, this message translates to:
  /// **'Next prayer'**
  String get nextPrayerLabel;

  /// No description provided for @nextPrayerAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Next prayer: {name} at {time}'**
  String nextPrayerAnnouncement(String name, String time);

  /// No description provided for @ishaPassedAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Isha has passed; next prayer is tomorrow\'s Fajr'**
  String get ishaPassedAnnouncement;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @setLocationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Set your location on the Prayer Times tab to see today\'s schedule here.'**
  String get setLocationPrompt;

  /// No description provided for @notificationsSectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSectionHeader;

  /// No description provided for @locationNameDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Location name'**
  String get locationNameDialogTitle;

  /// No description provided for @locationNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Amman, Jordan'**
  String get locationNameHint;

  /// No description provided for @qiblaLabel.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qiblaLabel;

  /// No description provided for @calendarLabel.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarLabel;

  /// No description provided for @zakatCalculatorLabel.
  ///
  /// In en, this message translates to:
  /// **'Zakat calculator'**
  String get zakatCalculatorLabel;

  /// No description provided for @aboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutLabel;

  /// No description provided for @calculationSectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Calculation'**
  String get calculationSectionHeader;

  /// No description provided for @manualAdjustmentsSectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Manual adjustments (minutes)'**
  String get manualAdjustmentsSectionHeader;

  /// No description provided for @iqamathOffsetsSectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Iqamath offsets (minutes after adhan)'**
  String get iqamathOffsetsSectionHeader;

  /// No description provided for @silentModeSectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Silent mode'**
  String get silentModeSectionHeader;

  /// No description provided for @displaySectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get displaySectionHeader;

  /// No description provided for @languageSectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionHeader;

  /// No description provided for @themeSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSemanticLabel;

  /// No description provided for @arabicTextSizeSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Arabic text size'**
  String get arabicTextSizeSemanticLabel;

  /// No description provided for @hijriOffsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Hijri offset'**
  String get hijriOffsetLabel;

  /// No description provided for @decreaseHijriOffsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Decrease Hijri offset'**
  String get decreaseHijriOffsetLabel;

  /// No description provided for @increaseHijriOffsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Increase Hijri offset'**
  String get increaseHijriOffsetLabel;

  /// No description provided for @decreaseOffsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Decrease {label} offset'**
  String decreaseOffsetLabel(String label);

  /// No description provided for @increaseOffsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Increase {label} offset'**
  String increaseOffsetLabel(String label);

  /// No description provided for @decreaseIqamathOffsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Decrease {label} iqamath offset'**
  String decreaseIqamathOffsetLabel(String label);

  /// No description provided for @increaseIqamathOffsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Increase {label} iqamath offset'**
  String increaseIqamathOffsetLabel(String label);

  /// No description provided for @extraMinutesAfterIqamathLabel.
  ///
  /// In en, this message translates to:
  /// **'Extra minutes after iqamath'**
  String get extraMinutesAfterIqamathLabel;

  /// No description provided for @decreaseExtraSilentMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Decrease extra silent minutes'**
  String get decreaseExtraSilentMinutesLabel;

  /// No description provided for @increaseExtraSilentMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Increase extra silent minutes'**
  String get increaseExtraSilentMinutesLabel;

  /// No description provided for @grantDndAccessLabel.
  ///
  /// In en, this message translates to:
  /// **'Grant Do Not Disturb access'**
  String get grantDndAccessLabel;

  /// No description provided for @grantDndAccessHint.
  ///
  /// In en, this message translates to:
  /// **'Required for Silent Mode to change the ringer automatically'**
  String get grantDndAccessHint;

  /// No description provided for @silentModeToggleSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'{label} silent mode'**
  String silentModeToggleSemanticLabel(String label);

  /// No description provided for @notificationToggleSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'{label} notification'**
  String notificationToggleSemanticLabel(String label);

  /// No description provided for @aboutNoorSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'About noor'**
  String get aboutNoorSemanticLabel;

  /// No description provided for @donateLabel.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donateLabel;

  /// No description provided for @donateHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap for ways to support this project'**
  String get donateHint;

  /// No description provided for @supportNoorTitle.
  ///
  /// In en, this message translates to:
  /// **'Support noor'**
  String get supportNoorTitle;

  /// No description provided for @supportNoorMessage.
  ///
  /// In en, this message translates to:
  /// **'noor will always be free, offline, and ad-free. If you would like to support its development, details are on the project page. JazakAllahu khairan.'**
  String get supportNoorMessage;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'A clean, privacy-first, ad-free Islamic utility app. Fully offline: no ads, no analytics, no remote telemetry.'**
  String get appTagline;

  /// No description provided for @typefacesHeader.
  ///
  /// In en, this message translates to:
  /// **'Typefaces'**
  String get typefacesHeader;

  /// No description provided for @fontRoleDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display — prayer times, the Bismillah, headers'**
  String get fontRoleDisplay;

  /// No description provided for @fontRoleBody.
  ///
  /// In en, this message translates to:
  /// **'Body — labels, settings, controls'**
  String get fontRoleBody;

  /// No description provided for @fontRoleArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic text'**
  String get fontRoleArabic;

  /// No description provided for @fontRoleTamil.
  ///
  /// In en, this message translates to:
  /// **'Tamil UI text'**
  String get fontRoleTamil;

  /// No description provided for @fontRoleSinhala.
  ///
  /// In en, this message translates to:
  /// **'Sinhala UI text'**
  String get fontRoleSinhala;

  /// No description provided for @fontLicenceNotice.
  ///
  /// In en, this message translates to:
  /// **'Each is licensed under the SIL Open Font Licence 1.1 and bundled with the app for fully offline use.'**
  String get fontLicenceNotice;

  /// No description provided for @openSourceLicencesLabel.
  ///
  /// In en, this message translates to:
  /// **'Open source licences'**
  String get openSourceLicencesLabel;

  /// No description provided for @openLicencesHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to view third-party licences'**
  String get openLicencesHint;

  /// No description provided for @noLicencesMessage.
  ///
  /// In en, this message translates to:
  /// **'No third-party licences to show.'**
  String get noLicencesMessage;

  /// No description provided for @licenceExpandHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to expand'**
  String get licenceExpandHint;

  /// No description provided for @licenceCollapseHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to collapse'**
  String get licenceCollapseHint;

  /// No description provided for @packageLicenceSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'{package} licence'**
  String packageLicenceSemanticLabel(String package);

  /// No description provided for @textSourcesHeader.
  ///
  /// In en, this message translates to:
  /// **'Text sources'**
  String get textSourcesHeader;

  /// No description provided for @quranSourceAttribution.
  ///
  /// In en, this message translates to:
  /// **'Quran text: Tanzil Quran Text (Uthmani, version 1.0.2), Copyright © Tanzil.net, licensed under Creative Commons Attribution 3.0. Unmodified verbatim copy; see assets/quran/README.md for full provenance and verification details.'**
  String get quranSourceAttribution;

  /// No description provided for @copyTanzilLinkSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Copy tanzil.net link'**
  String get copyTanzilLinkSemanticLabel;

  /// No description provided for @copyTanzilLinkHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to copy the Tanzil Project web address'**
  String get copyTanzilLinkHint;

  /// No description provided for @copiedTanzilMessage.
  ///
  /// In en, this message translates to:
  /// **'Copied tanzil.net'**
  String get copiedTanzilMessage;

  /// No description provided for @goldSilverHeader.
  ///
  /// In en, this message translates to:
  /// **'Gold & silver'**
  String get goldSilverHeader;

  /// No description provided for @goldGramsLabel.
  ///
  /// In en, this message translates to:
  /// **'Gold (grams)'**
  String get goldGramsLabel;

  /// No description provided for @goldPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Gold price per gram (today)'**
  String get goldPriceLabel;

  /// No description provided for @silverGramsLabel.
  ///
  /// In en, this message translates to:
  /// **'Silver (grams)'**
  String get silverGramsLabel;

  /// No description provided for @silverPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Silver price per gram (today)'**
  String get silverPriceLabel;

  /// No description provided for @otherAssetsHeader.
  ///
  /// In en, this message translates to:
  /// **'Other assets & liabilities'**
  String get otherAssetsHeader;

  /// No description provided for @cashSavingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash & savings'**
  String get cashSavingsLabel;

  /// No description provided for @receivablesLabel.
  ///
  /// In en, this message translates to:
  /// **'Receivables owed to you'**
  String get receivablesLabel;

  /// No description provided for @businessInventoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Business inventory value'**
  String get businessInventoryLabel;

  /// No description provided for @liabilitiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Liabilities (debts due now)'**
  String get liabilitiesLabel;

  /// No description provided for @netWealthLabel.
  ///
  /// In en, this message translates to:
  /// **'Net wealth'**
  String get netWealthLabel;

  /// No description provided for @zakatDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Zakat due (2.5%)'**
  String get zakatDueLabel;

  /// No description provided for @nisabPromptMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter a gold or silver price to see the nisab threshold.'**
  String get nisabPromptMessage;

  /// No description provided for @nisabThresholdMessage.
  ///
  /// In en, this message translates to:
  /// **'Nisab threshold: {threshold} — {met}.'**
  String nisabThresholdMessage(String threshold, String met);

  /// No description provided for @nisabMetLabel.
  ///
  /// In en, this message translates to:
  /// **'met'**
  String get nisabMetLabel;

  /// No description provided for @nisabNotMetLabel.
  ///
  /// In en, this message translates to:
  /// **'not yet met'**
  String get nisabNotMetLabel;

  /// No description provided for @zakatSummarySemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Net wealth {netWealth}. {nisabLabel} Zakat due: {zakatDue}.'**
  String zakatSummarySemanticLabel(
      String netWealth, String nisabLabel, String zakatDue);

  /// No description provided for @previousMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonthLabel;

  /// No description provided for @nextMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonthLabel;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageTamil.
  ///
  /// In en, this message translates to:
  /// **'தமிழ்'**
  String get languageTamil;

  /// No description provided for @languageSinhala.
  ///
  /// In en, this message translates to:
  /// **'සිංහල'**
  String get languageSinhala;

  /// No description provided for @languagePickerSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get languagePickerSemanticLabel;
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
      <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
