// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTab => 'Home';

  @override
  String get moreTab => 'More';

  @override
  String get quranTabLabel => 'Al Quran';

  @override
  String get duasTabLabel => 'Duas & Dhikr';

  @override
  String get settingsSemanticLabel => 'Settings';

  @override
  String get settingsHint => 'Double tap to open Settings';

  @override
  String openItemHint(String label) {
    return 'Double tap to open $label';
  }

  @override
  String get openHint => 'Double tap to open';

  @override
  String get comingSoonHint => 'Double tap for details';

  @override
  String comingSoonMessage(String feature) {
    return '$feature is being rebuilt and will be back soon.';
  }

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get saveLabel => 'Save';

  @override
  String get closeLabel => 'Close';

  @override
  String get closeDialogSemanticLabel => 'Close dialog';

  @override
  String get tasbihScreenTitle => 'Tasbih';

  @override
  String get tasbihCounterSemanticLabel => 'Tasbih counter';

  @override
  String get tasbihResetSemanticLabel => 'Reset tasbih count';

  @override
  String get resetLabel => 'Reset';

  @override
  String get tasbihResetHint => 'Double tap to reset the count to zero';

  @override
  String get tasbihIncrementHint => 'Double tap to increment';

  @override
  String get tasbihVibrationLabel => 'Vibration';

  @override
  String get dhikrSelectorSemanticLabel => 'Dhikr to count';

  @override
  String currentlyCountingLabel(String dhikr) {
    return 'Currently counting $dhikr';
  }

  @override
  String selectDhikrHint(String dhikr) {
    return 'Double tap to count $dhikr instead';
  }

  @override
  String get prayerTimesScreenTitle => 'Prayer Times';

  @override
  String get openMonthlyTimetableSemanticLabel =>
      'Open monthly prayer timetable';

  @override
  String get monthlyTimetableScreenTitle => 'Monthly Timetable';

  @override
  String get useGpsSemanticLabel => 'Use my current location';

  @override
  String get useGpsHint => 'Double tap to resolve your location via GPS';

  @override
  String get locatingLabel => 'Locating…';

  @override
  String get useMyLocationLabel => 'Use my location';

  @override
  String get latitudeLabel => 'Latitude';

  @override
  String get longitudeLabel => 'Longitude';

  @override
  String get applyManualLocationSemanticLabel => 'Apply manual coordinates';

  @override
  String get applyCoordinatesLabel => 'Apply coordinates';

  @override
  String get manualLatitudeSemanticLabel => 'Manual latitude entry';

  @override
  String get manualLongitudeSemanticLabel => 'Manual longitude entry';

  @override
  String get calculationMethodSemanticLabel => 'Calculation method';

  @override
  String get asrMadhabSemanticLabel => 'Asr madhab';

  @override
  String get highLatitudeRuleSemanticLabel => 'High latitude rule';

  @override
  String get highLatitudeUnresolvedMessage =>
      'No genuine Isha (or Fajr) time exists for this location and date — the sun does not reach the required angle. Showing an estimated clock time here would be misleading, so none is shown.';

  @override
  String get districtSelectorSemanticLabel => 'Select a Sri Lankan district';

  @override
  String get districtFieldLabel => 'Sri Lankan district (optional)';

  @override
  String get chooseDistrictHint => 'Choose a district';

  @override
  String get noneSelectedLabel => 'None selected';

  @override
  String get enterLocationPrompt => 'Enter your location to see prayer times.';

  @override
  String activeCalculationSettingsLabel(String text) {
    return 'Active calculation settings: $text';
  }

  @override
  String get qiblaScreenTitle => 'Qibla';

  @override
  String get qiblaNeedleSemanticLabel => 'Qibla direction needle';

  @override
  String get recentreCompassLabel => 'Recentre compass';

  @override
  String get qiblaCalibrationPromptMessage =>
      'Compass reading is uncalibrated or unreliable — move your device in a figure-eight motion to calibrate. The needle is dimmed until then so it is never shown pointing confidently in a wrong direction.';

  @override
  String get qiblaNoCompassMessage =>
      'This device has no compass — showing the qibla bearing as a number only.';

  @override
  String get qiblaAlignedMessage => 'Alhamdulillah — Qibla found';

  @override
  String get qiblaRotateMessage => 'Rotate to find Qibla';

  @override
  String get qiblaAlignedPillLabel => 'Qibla Aligned';

  @override
  String get qiblaYourLocationLabel => 'Your location';

  @override
  String qiblaRouteCaption(String origin) {
    return '$origin to the Kaaba';
  }

  @override
  String get qiblaFlyingLabel => 'flying';

  @override
  String get qiblaCamelLabel => 'by camel';

  @override
  String get qiblaFootLabel => 'on foot';

  @override
  String qiblaHoursAbbrev(int hours) {
    return '≈ $hours hrs';
  }

  @override
  String qiblaDaysAbbrev(int days) {
    return '≈ $days days';
  }

  @override
  String qiblaMonthsAbbrev(int months) {
    return '≈ $months months';
  }

  @override
  String get qiblaFacingReadoutLabel => 'FACING';

  @override
  String get qiblaBearingReadoutLabel => 'QIBLA';

  @override
  String get qiblaHoldLevelLabel => 'Hold level';

  @override
  String get qiblaFlatSurfaceCaption => 'Keep phone flat, away from metal.';

  @override
  String qiblaTravelEstimateSemanticLabel(int hours, int days, int months) {
    return 'Rough travel time estimates: $hours hours flying, $days days by camel, $months months on foot';
  }

  @override
  String get quranScreenTitle => 'Quran';

  @override
  String get bookmarksLabel => 'Bookmarks';

  @override
  String get quranCoverTapToBegin => 'Tap or swipe to begin';

  @override
  String get quranCoverSemanticsLabel => 'Quran';

  @override
  String get quranCoverSemanticsHint =>
      'Double tap or swipe to open the surah index';

  @override
  String get noBookmarksMessage =>
      'No bookmarks yet — tap the bookmark icon on any ayah while reading to save it here.';

  @override
  String get noAzkarBookmarksMessage =>
      'No bookmarks yet — tap the bookmark icon on any dua to save it here.';

  @override
  String get searchQuranSemanticLabel => 'Search the Quran';

  @override
  String get searchHintText => 'Search…';

  @override
  String searchResultSemanticLabel(int surahId, int ayahNumber) {
    return 'Search result: Surah $surahId, Ayah $ayahNumber';
  }

  @override
  String surahAyahLabel(int surahId, int ayahNumber) {
    return 'Surah $surahId, Ayah $ayahNumber';
  }

  @override
  String surahReaderTitle(int surahId) {
    return 'Surah $surahId';
  }

  @override
  String get quranAssetMissingMessage =>
      'Add a Quran source file to enable this feature.';

  @override
  String get quranVerificationFailedMessage =>
      'Reinstall or update the app to restore the Quran text — the file on this device did not pass verification.';

  @override
  String importingQuranProgressSemanticLabel(int percent) {
    return 'Importing Quran text, $percent percent complete';
  }

  @override
  String get importingQuranLabel => 'Importing Quran text…';

  @override
  String get azkarScreenTitle => 'Azkar';

  @override
  String dhikrCountSemanticLabel(int count, int total) {
    return 'Count for this dhikr: $count of $total';
  }

  @override
  String get countHint => 'Double tap to count one repetition';

  @override
  String sourceLabel(String source) {
    return 'Source: $source';
  }

  @override
  String get nextPrayerLabel => 'Next prayer';

  @override
  String nextPrayerAnnouncement(String name, String time) {
    return 'Next prayer: $name at $time';
  }

  @override
  String get ishaPassedAnnouncement =>
      'Isha has passed; next prayer is tomorrow\'s Fajr';

  @override
  String get todayLabel => 'Today';

  @override
  String get setLocationPrompt =>
      'Set your location on the Prayer Times tab to see today\'s schedule here.';

  @override
  String get notificationsSectionHeader => 'Notifications';

  @override
  String get locationNameDialogTitle => 'Location name';

  @override
  String get editLocationNameHint => 'Double tap to edit your location name';

  @override
  String locationLabelSemanticValue(String label) {
    return 'Location: $label';
  }

  @override
  String get locationNameHint => 'e.g. Amman, Jordan';

  @override
  String get qiblaLabel => 'Qibla';

  @override
  String get calendarLabel => 'Calendar';

  @override
  String get calendarRemindersTitle => 'Reminders';

  @override
  String get calendarReminderEmptyMessage => 'No reminders on this day yet.';

  @override
  String get calendarReminderNoteHint => 'What\'s this reminder for?';

  @override
  String get calendarReminderAddButton => 'Add reminder';

  @override
  String get calendarReminderDeleteHint => 'Double tap to delete this reminder';

  @override
  String get zakatCalculatorLabel => 'Zakat calculator';

  @override
  String get aboutLabel => 'About';

  @override
  String get calculationSectionHeader => 'Calculation';

  @override
  String get manualAdjustmentsSectionHeader => 'Manual adjustments (minutes)';

  @override
  String get iqamathOffsetsSectionHeader =>
      'Iqamath offsets (minutes after adhan)';

  @override
  String get preReminderSectionHeader => 'Pre-adhan reminder';

  @override
  String get batteryOptimizationSectionHeader => 'Reliable notifications';

  @override
  String get batteryOptimizationExemptedMessage =>
      'This app is exempt from battery optimization — prayer notifications can fire reliably even when the app is closed.';

  @override
  String get batteryOptimizationNotExemptedMessage =>
      'Some phones (especially Samsung, Xiaomi, and Huawei) silently stop scheduled prayer notifications to save battery unless this app is exempted.';

  @override
  String get grantBatteryOptimizationExemptionLabel =>
      'Allow unrestricted battery use';

  @override
  String get sunnahFastingCardTitle => 'Sunnah Fasting Today';

  @override
  String get sunnahFastingWeekdayReason =>
      'Fasting today is a recommended Sunnah — Mondays and Thursdays are among the Prophet\'s ﷺ regular fasting days.';

  @override
  String get sunnahFastingWhiteDayReason =>
      'Today is a White Day (the 13th-15th of the Hijri month) — a recommended day to fast.';

  @override
  String get sunnahFastingWhiteDayAndWeekdayReason =>
      'Today is both a White Day and a recommended weekday fast — an especially favoured day to fast.';

  @override
  String get locationSectionHeader => 'Location';

  @override
  String get manageLocationInSettingsLabel => 'Manage location in Settings';

  @override
  String get locationResolveFailedMessage =>
      'Could not resolve your location. Try again, or pick a district below.';

  @override
  String get usingGpsAutoResolveMessage =>
      'Using GPS — resolves automatically each time you open the app.';

  @override
  String get silentModeSectionHeader => 'Silent mode';

  @override
  String get displaySectionHeader => 'Display';

  @override
  String get languageSectionHeader => 'Language';

  @override
  String get countrySectionHeader => 'Country';

  @override
  String get countryPickerSemanticLabel => 'Country';

  @override
  String get comingSoonLabel => 'Coming soon';

  @override
  String get countryComingSoonHint =>
      'Not available yet — Sri Lanka is the only fully working country right now';

  @override
  String get countrySriLanka => 'Sri Lanka';

  @override
  String get countryIndia => 'India';

  @override
  String get countryMalaysia => 'Malaysia';

  @override
  String get countryUnitedKingdom => 'United Kingdom';

  @override
  String get countryUnitedStates => 'United States';

  @override
  String get themeSemanticLabel => 'Theme';

  @override
  String get arabicTextSizeSemanticLabel => 'Arabic text size';

  @override
  String get hijriOffsetLabel => 'Hijri offset';

  @override
  String get decreaseHijriOffsetLabel => 'Decrease Hijri offset';

  @override
  String get increaseHijriOffsetLabel => 'Increase Hijri offset';

  @override
  String decreaseOffsetLabel(String label) {
    return 'Decrease $label offset';
  }

  @override
  String increaseOffsetLabel(String label) {
    return 'Increase $label offset';
  }

  @override
  String decreaseIqamathOffsetLabel(String label) {
    return 'Decrease $label iqamath offset';
  }

  @override
  String increaseIqamathOffsetLabel(String label) {
    return 'Increase $label iqamath offset';
  }

  @override
  String get extraMinutesAfterIqamathLabel => 'Extra minutes after iqamath';

  @override
  String get decreaseExtraSilentMinutesLabel => 'Decrease extra silent minutes';

  @override
  String get increaseExtraSilentMinutesLabel => 'Increase extra silent minutes';

  @override
  String get grantDndAccessLabel => 'Grant Do Not Disturb access';

  @override
  String get grantDndAccessHint =>
      'Required for Silent Mode to change the ringer automatically';

  @override
  String silentModeToggleSemanticLabel(String label) {
    return '$label silent mode';
  }

  @override
  String notificationToggleSemanticLabel(String label) {
    return '$label notification';
  }

  @override
  String previewAdhanSemanticLabel(String label) {
    return 'Preview $label Adhan';
  }

  @override
  String get playPreviewHint => 'Double tap to play';

  @override
  String get stopPreviewHint => 'Double tap to stop';

  @override
  String get aboutNoorSemanticLabel => 'About noor';

  @override
  String get donateLabel => 'Donate';

  @override
  String get donateHint => 'Double tap for ways to support this project';

  @override
  String get supportNoorTitle => 'Support noor';

  @override
  String get supportNoorMessage =>
      'noor is offline and ad-free — always. If you would like to support its development, details are on the project page. JazakAllahu khairan.';

  @override
  String get appTagline =>
      'A clean, privacy-first, ad-free Islamic utility app. Fully offline: no ads, no analytics, no remote telemetry.';

  @override
  String get typefacesHeader => 'Typefaces';

  @override
  String get fontRoleDisplay =>
      'Display — prayer times, the Bismillah, headers';

  @override
  String get fontRoleBody => 'Body — labels, settings, controls';

  @override
  String get fontRoleArabic => 'Arabic text';

  @override
  String get fontRoleTamil => 'Tamil UI text';

  @override
  String get fontRoleSinhala => 'Sinhala UI text';

  @override
  String get fontLicenceNotice =>
      'Each is licensed under the SIL Open Font Licence 1.1 and bundled with the app for fully offline use.';

  @override
  String get openSourceLicencesLabel => 'Open source licences';

  @override
  String get openLicencesHint => 'Double tap to view third-party licences';

  @override
  String get noLicencesMessage => 'No third-party licences to show.';

  @override
  String get licenceExpandHint => 'Double tap to expand';

  @override
  String get licenceCollapseHint => 'Double tap to collapse';

  @override
  String packageLicenceSemanticLabel(String package) {
    return '$package licence';
  }

  @override
  String get textSourcesHeader => 'Text sources';

  @override
  String get quranSourceAttribution =>
      'Quran text: Tanzil Quran Text (Uthmani, version 1.0.2), Copyright © Tanzil.net, licensed under Creative Commons Attribution 3.0. Unmodified verbatim copy; see assets/quran/README.md for full provenance and verification details.';

  @override
  String get copyTanzilLinkSemanticLabel => 'Copy tanzil.net link';

  @override
  String get copyTanzilLinkHint =>
      'Double tap to copy the Tanzil Project web address';

  @override
  String get copiedTanzilMessage => 'Copied tanzil.net';

  @override
  String get englishTranslationAttribution =>
      'English translation: Saheeh International (Umm Muhammad), via Tanzil.net. Tanzil restricts translations to non-commercial use; see assets/quran_translations/README.md for full provenance and license detail.';

  @override
  String get goldSilverHeader => 'Gold & silver';

  @override
  String get goldGramsLabel => 'Gold (grams)';

  @override
  String get goldPriceLabel => 'Gold price per gram (today)';

  @override
  String get silverGramsLabel => 'Silver (grams)';

  @override
  String get silverPriceLabel => 'Silver price per gram (today)';

  @override
  String get otherAssetsHeader => 'Other assets & liabilities';

  @override
  String get cashSavingsLabel => 'Cash & savings';

  @override
  String get receivablesLabel => 'Receivables owed to you';

  @override
  String get businessInventoryLabel => 'Business inventory value';

  @override
  String get liabilitiesLabel => 'Liabilities (debts due now)';

  @override
  String get netWealthLabel => 'Net wealth';

  @override
  String get zakatDueLabel => 'Zakat due (2.5%)';

  @override
  String get nisabPromptMessage =>
      'Enter a gold or silver price to see the nisab threshold.';

  @override
  String nisabThresholdMessage(String threshold, String met) {
    return 'Nisab threshold: $threshold — $met.';
  }

  @override
  String get nisabMetLabel => 'met';

  @override
  String get nisabNotMetLabel => 'not yet met';

  @override
  String zakatSummarySemanticLabel(
      String netWealth, String nisabLabel, String zakatDue) {
    return 'Net wealth $netWealth. $nisabLabel Zakat due: $zakatDue.';
  }

  @override
  String get previousMonthLabel => 'Previous month';

  @override
  String get nextMonthLabel => 'Next month';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get languageSinhala => 'සිංහල';

  @override
  String get languagePickerSemanticLabel => 'App language';

  @override
  String get switchLanguageHint =>
      'Double tap to switch the app\'s language to this';

  @override
  String get themeToggleSemanticLabel => 'Theme';

  @override
  String get themeToggleHint =>
      'Double tap to switch between dark, light, and system theme';

  @override
  String get pilgrimageLabel => 'Hajj & Umrah';

  @override
  String get pilgrimageMoreRowHint =>
      'Double tap to open the Hajj and Umrah tracker';

  @override
  String get profilePickerTitle => 'Choose a pilgrim';

  @override
  String get profilePickerEmptyMessage =>
      'No profiles yet. Add one to begin tracking.';

  @override
  String get addProfileLabel => 'Add pilgrim';

  @override
  String get addProfileHint => 'Double tap to add a new pilgrim profile';

  @override
  String get profileNameFieldLabel => 'Name';

  @override
  String get profileNameFieldHint => 'Enter a name for this profile';

  @override
  String get experienceLevelLabel => 'Experience level';

  @override
  String get beginnerLabel => 'Beginner';

  @override
  String get experiencedLabel => 'Experienced';

  @override
  String get createProfileButtonLabel => 'Create profile';

  @override
  String get createProfileButtonHint => 'Double tap to save this profile';

  @override
  String selectProfileHint(String name) {
    return 'Double tap to continue as $name';
  }

  @override
  String get sessionSetupTitle => 'Start a session';

  @override
  String get pilgrimageTypeLabel => 'Type';

  @override
  String get umrahLabel => 'Umrah';

  @override
  String get hajjLabel => 'Hajj';

  @override
  String get genderLabel => 'Gender';

  @override
  String get maleLabel => 'Male';

  @override
  String get femaleLabel => 'Female';

  @override
  String get startSessionButtonLabel => 'Start';

  @override
  String get startSessionButtonHint => 'Double tap to begin a new session';

  @override
  String get resumeSessionMessage =>
      'You have an unfinished session in progress.';

  @override
  String get resumeSessionButtonLabel => 'Resume';

  @override
  String get resumeSessionButtonHint =>
      'Double tap to continue your unfinished session';

  @override
  String get tawafScreenTitle => 'Tawaf';

  @override
  String get tawafCounterSemanticLabel => 'Tawaf circuit';

  @override
  String get tawafIncrementHint => 'Double tap to count one circuit';

  @override
  String circuitProgressLabel(int count) {
    return 'Circuit $count of 7';
  }

  @override
  String get tawafCompleteMessage => 'Tawaf complete.';

  @override
  String get continueToSaiButtonLabel => 'Continue to Sa\'i';

  @override
  String get continueToSaiButtonHint => 'Double tap to move on to Sa\'i';

  @override
  String get idtibaTitle => 'Idtiba';

  @override
  String get idtibaExplanation =>
      'Men keep the right shoulder uncovered throughout Tawaf, re-covering it once the 7th circuit is complete.';

  @override
  String get idtibaBadgeLabel => 'Idtiba: shoulder bare';

  @override
  String get ramalTitle => 'Ramal';

  @override
  String get ramalExplanation =>
      'Men walk briskly with short steps for the first three circuits, then return to a normal pace from the fourth circuit onward.';

  @override
  String get ramalBadgeLabel => 'Ramal: brisk pace';

  @override
  String get saiScreenTitle => 'Sa\'i';

  @override
  String get saiCounterSemanticLabel => 'Sa\'i round';

  @override
  String get saiIncrementHint => 'Double tap to count one round';

  @override
  String roundProgressLabel(int count) {
    return 'Round $count of 7';
  }

  @override
  String get saiDirectionSafaToMarwah => 'Safa to Marwah';

  @override
  String get saiDirectionMarwahToSafa => 'Marwah to Safa';

  @override
  String get saiDirectionExplanation =>
      'Sa\'i is walking seven times between the hills of Safa and Marwah, alternating direction each round.';

  @override
  String get completeSessionButtonLabel => 'Complete';

  @override
  String get completeSessionButtonHint => 'Double tap to finish this session';

  @override
  String get completionScreenTitle => 'Alhamdulillah';

  @override
  String completionMessage(String type) {
    return 'May Allah accept your $type.';
  }

  @override
  String completionUmrahCountLabel(int count) {
    return 'Umrah completed: $count';
  }

  @override
  String completionHajjCountLabel(int count) {
    return 'Hajj completed: $count';
  }

  @override
  String get doneButtonLabel => 'Done';

  @override
  String get doneButtonHint => 'Double tap to return';

  @override
  String get ofSevenSuffix => 'of 7';

  @override
  String get selectOptionHint => 'Double tap to select';

  @override
  String get umrahGuideLabel => 'Umrah Guide';

  @override
  String get umrahGuideMoreRowHint => 'Double tap to open the Umrah guide';

  @override
  String get hajjGuideLabel => 'Hajj Guide';

  @override
  String get hajjGuideMoreRowHint => 'Double tap to open the Hajj guide';

  @override
  String get scholarConfirmationNotice =>
      'Confirm all ritual details with your scholar or Hajj group.';

  @override
  String get guideTextNotLoadedMessage =>
      'Guide text not yet loaded from a verified source';

  @override
  String get guideBodyEnglishOnlyNote =>
      'Full description available in English only for now';

  @override
  String get umrahStep1Title => '1. Ghusl and ihram';

  @override
  String get umrahStep2Title => '2. Niyyah (intention)';

  @override
  String get umrahStep3Title => '3. Talbiyah';

  @override
  String get umrahStep4Title => '4. Tawaf (seven circuits)';

  @override
  String get umrahStep5Title => '5. Prayer at Maqam Ibrahim';

  @override
  String get umrahStep6Title => '6. Zamzam water';

  @override
  String get umrahStep7Title => '7. Sa\'i (seven passages)';

  @override
  String get umrahStep8Title => '8. Halq or taqsir';

  @override
  String guideStepLabel(int number) {
    return 'Step $number';
  }

  @override
  String guideDayLabel(int number) {
    return 'Day $number';
  }

  @override
  String get talbiyahSectionTitle => 'Talbiyah';

  @override
  String get guideReferenceLabel => 'Reference';

  @override
  String get rabbanaSectionTitle => 'Suggested supplication — Qur\'an 2:201';

  @override
  String get womenTawafNote =>
      'Women walk at a normal pace throughout Tawaf, with both shoulders covered — Idtiba and Ramal do not apply to them.';

  @override
  String get tawafDuaSectionTitle => 'Dua to recite';

  @override
  String get saiDuaSectionTitle => 'Dhikr to recite';

  @override
  String reciteCountLabel(int count) {
    return 'Recite ×$count';
  }

  @override
  String get todaysPrayersLabel => 'Today\'s prayers';

  @override
  String get assalamuAlaikumGreeting => 'Assalamu Alaikum';

  @override
  String dayStreakBadgeLabel(int days) {
    return '$days DAY STREAK';
  }

  @override
  String goalsProgressLabel(int completed, int total, int percent) {
    return '$completed/$total goals · $percent%';
  }

  @override
  String get suhoorLabel => 'Suhoor';

  @override
  String get iftarLabel => 'Iftar';

  @override
  String get ayahOfTheDayTitle => 'Ayah of the Day';

  @override
  String get copyLabel => 'Copy';

  @override
  String get copiedConfirmationLabel => 'Copied to clipboard';

  @override
  String get fullQuranCtaLabel => 'Full Quran';

  @override
  String get dailyGoalsSectionTitle => 'Today\'s Spiritual Goals';

  @override
  String get noPrayerStreakMessage => 'No current prayer streak';

  @override
  String prayerStreakLabel(int count) {
    return 'Prayer streak: ${count}d';
  }

  @override
  String get fastingTodayLabel => 'Fasting today';

  @override
  String get markFastingHint => 'Double tap to mark today as fasted';

  @override
  String get unmarkFastingHint => 'Double tap to unmark today as fasted';

  @override
  String get noFastingStreakMessage => 'No current fasting streak';

  @override
  String fastingStreakLabel(int count) {
    return 'Fasting streak: ${count}d';
  }

  @override
  String markPrayerDoneHint(String label) {
    return 'Double tap to mark $label done';
  }

  @override
  String unmarkPrayerHint(String label) {
    return 'Double tap to unmark $label';
  }

  @override
  String get locationSetViaGpsLabel => 'Location: current (GPS)';

  @override
  String get locationSetLabel => 'Location set';

  @override
  String get changeLocationSemanticLabel => 'Change location';

  @override
  String get changeLocationHint =>
      'Double tap to change how your location is set';

  @override
  String get changeLabel => 'Change';

  @override
  String get enterManuallyLabel => 'Enter manually (advanced)';

  @override
  String get hideManualEntryLabel => 'Hide manual entry';

  @override
  String get turnOffNotificationHint => 'Double tap to turn off';

  @override
  String get turnOnNotificationHint => 'Double tap to turn on';

  @override
  String get setLocationOnPrayerTabMessage =>
      'Set your location on the Prayer Times tab to see today\'s schedule here.';

  @override
  String get religiousContentNoteHeader => 'A note on religious content';

  @override
  String get religiousContentNoteBody =>
      'Qur\'an text is sourced from the Tanzil Project, and Azkar text from Hisn al-Muslim. Both are checked against those sources and remain under ongoing scholarly review. If you notice anything that needs correction, please contact us via Support noor.';

  @override
  String get religiousContentQuietNote =>
      'This content is sourced and checked carefully, and is under continuing scholarly review. Found something that needs correcting? Please let us know.';

  @override
  String get themeMushaf => 'Mushaf';

  @override
  String get themeEmeraldNight => 'Emerald Night';

  @override
  String get progressCardTitle => 'Prayer progress';

  @override
  String get progressHelpButton => 'How is this calculated?';

  @override
  String get progressHelpHint => 'Double tap to open an explanation';

  @override
  String get progressHelpTitle => 'How your progress is worked out';

  @override
  String get progressHelpBody =>
      'The percentage is the prayers you ticked in the last 7 days divided by the prayers possible in those days (5 per day). If you only started recently, only the days since your first tick count, so a new install does not start at 0%.';

  @override
  String get progressHelpStreak =>
      'A streak is the number of days in a row with all five prayers ticked. Today does not break your streak while it is still in progress. Best streak is your longest run ever.';

  @override
  String get progressHelpPrivacy =>
      'Everything here is worked out on your phone from your own ticks. Nothing is sent anywhere.';

  @override
  String get progressHelpClose => 'Got it';

  @override
  String get progressPercentCaption => 'of prayers kept, last 7 days';

  @override
  String get progressCurrentStreak => 'Current streak (days)';

  @override
  String get progressBestStreak => 'Best streak (days)';

  @override
  String get progressPrayersKept => 'Prayers kept this week';

  @override
  String get progressMsgStart =>
      'Every journey begins with one prayer. Start with the next one.';

  @override
  String get progressMsgKeepGoing => 'Keep going, every prayer counts.';

  @override
  String get progressMsgAlmost => 'Almost there, you are doing well today.';

  @override
  String get progressMsgPerfect =>
      'All five prayers today. May Allah accept them.';

  @override
  String progressMsgStreak(int count) {
    return '$count days in a row. Keep it going.';
  }

  @override
  String progressTodaySemantics(int count) {
    return '$count of 5 prayers done today';
  }

  @override
  String progressPercentSemantics(int percent) {
    return '$percent percent of prayers kept in the last 7 days';
  }

  @override
  String progressBarSemantics(String day, int count) {
    return '$day: $count of 5 prayers';
  }

  @override
  String get trackerPreviousDay => 'Previous day';

  @override
  String get trackerNextDay => 'Next day';

  @override
  String get trackerViewProgress => 'View your progress';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get settingsQuranTextSize => 'Quran text size';

  @override
  String get settingsHijriOffset => 'Hijri offset';

  @override
  String get settingsHijriDecrease => 'Decrease Hijri offset';

  @override
  String get settingsHijriIncrease => 'Increase Hijri offset';

  @override
  String get themeNebula => 'Nebula';

  @override
  String get themeDawn => 'Dawn';

  @override
  String get themeFollowSystem => 'Follow system';

  @override
  String get quickSilentMode => 'Silent Mode';

  @override
  String get supportHomeMessage =>
      'noor stays free for everyone. If it helps you, consider supporting its upkeep.';

  @override
  String get supportHomeSemantics =>
      'noor stays free for everyone. If it helps you, consider supporting its upkeep. Opens Support screen.';

  @override
  String get supportHomeDismiss => 'Dismiss support message';

  @override
  String get loadingPrayerTimes => 'Loading prayer times';

  @override
  String get loadingGeneric => 'Loading';

  @override
  String get exactAlarmTitle => 'Allow exact prayer alarms';

  @override
  String get exactAlarmBody =>
      'So the adhan sounds at the exact prayer time, allow \"Alarms & reminders\" for noor on the next screen.';

  @override
  String get commonNotNow => 'Not now';

  @override
  String get exactAlarmOpenSettings => 'Open settings';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingNotNowLocation =>
      'Not now — I\'ll enable location in Settings';

  @override
  String get azkarNoMatches => 'No matching duas found.';

  @override
  String get nudgeSupportNoor => 'Support noor';

  @override
  String get downloadedAudioTitle => 'Downloaded Audio';

  @override
  String get downloadedAudioChecking => 'Checking...';

  @override
  String get downloadedAudioDelete => 'Delete downloaded audio';

  @override
  String get downloadedAudioDeleting => 'Deleting...';

  @override
  String get downloadedAudioDeleteHint =>
      'Frees the storage used by downloaded surah recitations — bundled audio is unaffected';

  @override
  String currentTimeSemantics(String time) {
    return 'Current time $time';
  }

  @override
  String downloadedAudioSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloaded surahs',
      one: '1 downloaded surah',
    );
    return '$_temp0 — $size of storage';
  }

  @override
  String get privacyStatement =>
      'No ads, no tracking. Your data stays on your phone.';

  @override
  String get helpFaqLabel => 'Help & FAQ';

  @override
  String get helpFaqHint => 'Double tap for answers to common questions';

  @override
  String get privacyPolicyLabel => 'Privacy Policy';

  @override
  String get privacyPolicyHint => 'Double tap to read the privacy policy';

  @override
  String get licencesLabel => 'Open source licences';

  @override
  String get licencesHint => 'Double tap to view third-party licences';

  @override
  String get helpQ1 => 'Does noor need the internet?';

  @override
  String get helpA1 =>
      'No. Everything works offline. The only exception is optional Quran audio downloads, which start only when you tap a download icon.';

  @override
  String get helpQ2 => 'Where does my data go?';

  @override
  String get helpA2 =>
      'Nowhere. Your ticked prayers, bookmarks, settings and location stay on your phone in an encrypted database. There are no ads and no tracking.';

  @override
  String get helpQ3 => 'Why did the adhan not sound?';

  @override
  String get helpA3 =>
      'Check that notifications are allowed for noor, that \"Alarms & reminders\" is allowed, that battery optimisation is off for noor, and that the phone is not in Do Not Disturb. Settings has a test button for the adhan.';

  @override
  String get helpQ4 => 'How are prayer times calculated?';

  @override
  String get helpA4 =>
      'On your phone, from your location, using the calculation method and madhab chosen in Settings. You can change them there at any time.';

  @override
  String get helpQ5 => 'Why does noor ask for location?';

  @override
  String get helpA5 =>
      'Only to work out prayer times for where you are. It is used on your phone and never sent anywhere. If location is off, noor uses a default location and tells you so.';

  @override
  String get helpQ6 => 'How do I back up my data?';

  @override
  String get helpA6 =>
      'Open Settings, then Backup & Restore. It creates an encrypted file that you keep. Only you know the passphrase, so keep it safe.';

  @override
  String get helpQ7 => 'How is the progress percentage worked out?';

  @override
  String get helpA7 =>
      'It is the prayers you ticked in the last 7 days divided by the prayers possible (5 per day), counting only days since your first tick. Tap the ? on the progress card for details.';

  @override
  String get helpQ8 => 'How do I change the theme?';

  @override
  String get helpA8 =>
      'Open Settings, then Display, and choose Nebula, Dawn, Mushaf or Emerald Night, or follow the system setting.';

  @override
  String get helpQ9 => 'How do I report a problem?';

  @override
  String get helpA9 =>
      'Open Settings, then Send Feedback. Describe what happened and what you expected.';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get prayerNotYetDueHint => 'Not yet due today';
}
