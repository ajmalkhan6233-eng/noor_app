// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get homeTab => 'முகப்பு';

  @override
  String get moreTab => 'மேலும்';

  @override
  String get settingsSemanticLabel => 'அமைப்புகள்';

  @override
  String get settingsHint => 'அமைப்புகளைத் திறக்க இருமுறை தட்டவும்';

  @override
  String openItemHint(String label) {
    return '$label திறக்க இருமுறை தட்டவும்';
  }

  @override
  String get openHint => 'திறக்க இருமுறை தட்டவும்';

  @override
  String get cancelLabel => 'ரத்துசெய்';

  @override
  String get saveLabel => 'சேமி';

  @override
  String get closeLabel => 'மூடு';

  @override
  String get closeDialogSemanticLabel => 'உரையாடலை மூடு';

  @override
  String get tasbihScreenTitle => 'தஸ்பீஹ்';

  @override
  String get tasbihCounterSemanticLabel => 'தஸ்பீஹ் எண்ணிக்கை';

  @override
  String get tasbihResetSemanticLabel => 'தஸ்பீஹ் எண்ணிக்கையை மீட்டமை';

  @override
  String get resetLabel => 'மீட்டமை';

  @override
  String get tasbihResetHint =>
      'எண்ணிக்கையை பூஜ்ஜியமாக மீட்டமைக்க இருமுறை தட்டவும்';

  @override
  String get tasbihIncrementHint => 'எண்ணிக்கையை அதிகரிக்க இருமுறை தட்டவும்';

  @override
  String get dhikrSelectorSemanticLabel => 'எண்ண வேண்டிய திக்ர்';

  @override
  String currentlyCountingLabel(String dhikr) {
    return 'தற்போது எண்ணப்படுவது: $dhikr';
  }

  @override
  String get prayerTimesScreenTitle => 'தொழுகை நேரங்கள்';

  @override
  String get openMonthlyTimetableSemanticLabel =>
      'மாதாந்திர தொழுகை அட்டவணையைத் திற';

  @override
  String get monthlyTimetableScreenTitle => 'மாதாந்திர அட்டவணை';

  @override
  String get useGpsSemanticLabel => 'என் தற்போதைய இருப்பிடத்தைப் பயன்படுத்து';

  @override
  String get useGpsHint =>
      'GPS மூலம் உங்கள் இருப்பிடத்தைக் கண்டறிய இருமுறை தட்டவும்';

  @override
  String get locatingLabel => 'கண்டறிகிறது…';

  @override
  String get useMyLocationLabel => 'என் இருப்பிடத்தைப் பயன்படுத்து';

  @override
  String get latitudeLabel => 'அட்சரேகை';

  @override
  String get longitudeLabel => 'தீர்க்கரேகை';

  @override
  String get applyManualLocationSemanticLabel =>
      'கைமுறை ஆயத்தொலைவுகளைப் பயன்படுத்து';

  @override
  String get applyCoordinatesLabel => 'ஆயத்தொலைவுகளைப் பயன்படுத்து';

  @override
  String get manualLatitudeSemanticLabel => 'கைமுறை அட்சரேகை உள்ளீடு';

  @override
  String get manualLongitudeSemanticLabel => 'கைமுறை தீர்க்கரேகை உள்ளீடு';

  @override
  String get calculationMethodSemanticLabel => 'கணக்கீட்டு முறை';

  @override
  String get asrMadhabSemanticLabel => 'அஸ்ர் மத்ஹப்';

  @override
  String get highLatitudeRuleSemanticLabel => 'உயர் அட்சரேகை விதி';

  @override
  String get highLatitudeUnresolvedMessage =>
      'இந்த இருப்பிடத்திற்கும் தேதிக்கும் உண்மையான இஷா (அல்லது ஃபஜ்ர்) நேரம் இல்லை — சூரியன் தேவையான கோணத்தை அடையவில்லை. இங்கு ஒரு கணிக்கப்பட்ட நேரத்தைக் காட்டுவது தவறாக வழிநடத்தும் என்பதால், எதுவும் காட்டப்படவில்லை.';

  @override
  String get districtSelectorSemanticLabel =>
      'இலங்கை மாவட்டத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get districtFieldLabel => 'இலங்கை மாவட்டம் (விருப்பத்தேர்வு)';

  @override
  String get chooseDistrictHint => 'ஒரு மாவட்டத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get noneSelectedLabel => 'எதுவும் தேர்ந்தெடுக்கப்படவில்லை';

  @override
  String get enterLocationPrompt =>
      'தொழுகை நேரங்களைக் காண உங்கள் இருப்பிடத்தை உள்ளிடவும்.';

  @override
  String activeCalculationSettingsLabel(String text) {
    return 'செயலில் உள்ள கணக்கீட்டு அமைப்புகள்: $text';
  }

  @override
  String get qiblaScreenTitle => 'கிப்லா';

  @override
  String get qiblaNeedleSemanticLabel => 'கிப்லா திசை ஊசி';

  @override
  String get recentreCompassLabel => 'திசைகாட்டியை மீண்டும் மையப்படுத்து';

  @override
  String get qiblaCalibrationPromptMessage =>
      'திசைகாட்டி அளவீடு அளவீடு செய்யப்படாதது அல்லது நம்பகமற்றது — அளவீடு செய்ய உங்கள் சாதனத்தை எட்டு வடிவ அசைவில் நகர்த்தவும். தவறான திசையில் நம்பிக்கையுடன் காட்டப்படாதவாறு, அது வரை ஊசி மங்கலாக்கப்பட்டுள்ளது.';

  @override
  String get qiblaNoCompassMessage =>
      'இந்த சாதனத்தில் திசைகாட்டி இல்லை — கிப்லா திசையை எண்ணாக மட்டும் காட்டுகிறது.';

  @override
  String get quranScreenTitle => 'குர்ஆன்';

  @override
  String get bookmarksLabel => 'புத்தகக்குறிகள்';

  @override
  String get noBookmarksMessage =>
      'இன்னும் புத்தகக்குறிகள் இல்லை — படிக்கும்போது எந்த ஆயத்திலும் புத்தகக்குறி ஐகானைத் தட்டி இங்கு சேமிக்கவும்.';

  @override
  String get searchQuranSemanticLabel => 'குர்ஆனில் தேடு';

  @override
  String get searchHintText => 'தேடு…';

  @override
  String searchResultSemanticLabel(int surahId, int ayahNumber) {
    return 'தேடல் முடிவு: சூரா $surahId, ஆயத் $ayahNumber';
  }

  @override
  String surahAyahLabel(int surahId, int ayahNumber) {
    return 'சூரா $surahId, ஆயத் $ayahNumber';
  }

  @override
  String surahReaderTitle(int surahId) {
    return 'சூரா $surahId';
  }

  @override
  String get quranAssetMissingMessage =>
      'இந்த அம்சத்தைச் செயல்படுத்த குர்ஆன் மூல கோப்பைச் சேர்க்கவும்.';

  @override
  String get quranVerificationFailedMessage =>
      'குர்ஆன் உரையை மீட்டெடுக்க பயன்பாட்டை மீண்டும் நிறுவவும் அல்லது புதுப்பிக்கவும் — இந்த சாதனத்தில் உள்ள கோப்பு சரிபார்ப்பில் தேர்ச்சி பெறவில்லை.';

  @override
  String importingQuranProgressSemanticLabel(int percent) {
    return 'குர்ஆன் உரை இறக்குமதி செய்யப்படுகிறது, $percent சதவீதம் முடிந்தது';
  }

  @override
  String get importingQuranLabel => 'குர்ஆன் உரை இறக்குமதி செய்யப்படுகிறது…';

  @override
  String get azkarScreenTitle => 'அஃதுகார்';

  @override
  String dhikrCountSemanticLabel(int count, int total) {
    return 'இந்த திக்ருக்கான எண்ணிக்கை: $total இல் $count';
  }

  @override
  String get countHint => 'ஒரு முறை எண்ண இருமுறை தட்டவும்';

  @override
  String sourceLabel(String source) {
    return 'மூலம்: $source';
  }

  @override
  String get nextPrayerLabel => 'அடுத்த தொழுகை';

  @override
  String nextPrayerAnnouncement(String name, String time) {
    return 'அடுத்த தொழுகை: $name, $time மணிக்கு';
  }

  @override
  String get ishaPassedAnnouncement =>
      'இஷா முடிந்துவிட்டது; அடுத்த தொழுகை நாளைய ஃபஜ்ர்';

  @override
  String get todayLabel => 'இன்று';

  @override
  String get setLocationPrompt =>
      'இன்றைய அட்டவணையை இங்கு காண தொழுகை நேரங்கள் தாவலில் உங்கள் இருப்பிடத்தை அமைக்கவும்.';

  @override
  String get notificationsSectionHeader => 'அறிவிப்புகள்';

  @override
  String get locationNameDialogTitle => 'இருப்பிடப் பெயர்';

  @override
  String get locationNameHint => 'எ.கா. அம்மான், ஜோர்டான்';

  @override
  String get qiblaLabel => 'கிப்லா';

  @override
  String get calendarLabel => 'நாட்காட்டி';

  @override
  String get zakatCalculatorLabel => 'ஜகாத் கணிப்பான்';

  @override
  String get aboutLabel => 'பற்றி';

  @override
  String get calculationSectionHeader => 'கணக்கீடு';

  @override
  String get manualAdjustmentsSectionHeader =>
      'கைமுறை சரிசெய்தல்கள் (நிமிடங்கள்)';

  @override
  String get iqamathOffsetsSectionHeader =>
      'இகாமத் இடைவெளிகள் (அதான் பின் நிமிடங்கள்)';

  @override
  String get silentModeSectionHeader => 'மௌன பயன்முறை';

  @override
  String get displaySectionHeader => 'காட்சி';

  @override
  String get languageSectionHeader => 'மொழி';

  @override
  String get themeSemanticLabel => 'தீம்';

  @override
  String get arabicTextSizeSemanticLabel => 'அரபி எழுத்து அளவு';

  @override
  String get hijriOffsetLabel => 'ஹிஜ்ரி இடைவெளி';

  @override
  String get decreaseHijriOffsetLabel => 'ஹிஜ்ரி இடைவெளியைக் குறை';

  @override
  String get increaseHijriOffsetLabel => 'ஹிஜ்ரி இடைவெளியை அதிகரி';

  @override
  String decreaseOffsetLabel(String label) {
    return '$label இடைவெளியைக் குறை';
  }

  @override
  String increaseOffsetLabel(String label) {
    return '$label இடைவெளியை அதிகரி';
  }

  @override
  String decreaseIqamathOffsetLabel(String label) {
    return '$label இகாமத் இடைவெளியைக் குறை';
  }

  @override
  String increaseIqamathOffsetLabel(String label) {
    return '$label இகாமத் இடைவெளியை அதிகரி';
  }

  @override
  String get extraMinutesAfterIqamathLabel =>
      'இகாமத்திற்குப் பிறகு கூடுதல் நிமிடங்கள்';

  @override
  String get decreaseExtraSilentMinutesLabel => 'கூடுதல் மௌன நிமிடங்களைக் குறை';

  @override
  String get increaseExtraSilentMinutesLabel => 'கூடுதல் மௌன நிமிடங்களை அதிகரி';

  @override
  String get grantDndAccessLabel => 'தொந்தரவு செய்ய வேண்டாம் அணுகலை வழங்கு';

  @override
  String get grantDndAccessHint => 'மௌன பயன்முறை தானாக ரிங்கரை மாற்ற இது தேவை';

  @override
  String silentModeToggleSemanticLabel(String label) {
    return '$label மௌன பயன்முறை';
  }

  @override
  String notificationToggleSemanticLabel(String label) {
    return '$label அறிவிப்பு';
  }

  @override
  String get aboutNoorSemanticLabel => 'நூர் பற்றி';

  @override
  String get donateLabel => 'நன்கொடை';

  @override
  String get donateHint =>
      'இந்த திட்டத்தை ஆதரிக்கும் வழிகளுக்கு இருமுறை தட்டவும்';

  @override
  String get supportNoorTitle => 'நூரை ஆதரிக்கவும்';

  @override
  String get supportNoorMessage =>
      'நூர் எப்போதும் இலவசமாகவும், ஆஃப்லைனாகவும், விளம்பரமின்றியும் இருக்கும். அதன் வளர்ச்சிக்கு ஆதரவளிக்க விரும்பினால், விவரங்கள் திட்டப் பக்கத்தில் உள்ளன. ஜசாகல்லாஹு கைரன்.';

  @override
  String get appTagline =>
      'ஒரு தூய்மையான, தனியுரிமையை முன்னிலைப்படுத்தும், விளம்பரமற்ற இஸ்லாமிய பயன்பாட்டுப் பயன்பாடு. முழுவதுமாக ஆஃப்லைன்: விளம்பரங்கள் இல்லை, பகுப்பாய்வுகள் இல்லை, தொலைநிலை தரவுப் பரிமாற்றம் இல்லை.';

  @override
  String get typefacesHeader => 'எழுத்துருக்கள்';

  @override
  String get fontRoleDisplay =>
      'காட்சி — தொழுகை நேரங்கள், பிஸ்மில்லாஹ், தலைப்புகள்';

  @override
  String get fontRoleBody => 'உரை — லேபிள்கள், அமைப்புகள், கட்டுப்பாடுகள்';

  @override
  String get fontRoleArabic => 'அரபி உரை';

  @override
  String get fontRoleTamil => 'தமிழ் இடைமுக உரை';

  @override
  String get fontRoleSinhala => 'சிங்கள இடைமுக உரை';

  @override
  String get fontLicenceNotice =>
      'ஒவ்வொன்றும் SIL Open Font Licence 1.1 இன் கீழ் உரிமம் பெற்று, முழுமையாக ஆஃப்லைனில் பயன்படுத்த பயன்பாட்டுடன் தொகுக்கப்பட்டுள்ளது.';

  @override
  String get openSourceLicencesLabel => 'திறந்த மூல உரிமங்கள்';

  @override
  String get openLicencesHint =>
      'மூன்றாம் தரப்பு உரிமங்களைக் காண இருமுறை தட்டவும்';

  @override
  String get noLicencesMessage => 'காட்ட மூன்றாம் தரப்பு உரிமங்கள் இல்லை.';

  @override
  String get licenceExpandHint => 'விரிவாக்க இருமுறை தட்டவும்';

  @override
  String get licenceCollapseHint => 'சுருக்க இருமுறை தட்டவும்';

  @override
  String packageLicenceSemanticLabel(String package) {
    return '$package உரிமம்';
  }

  @override
  String get textSourcesHeader => 'உரை மூலங்கள்';

  @override
  String get quranSourceAttribution =>
      'குர்ஆன் உரை: தன்ஸில் குர்ஆன் உரை (உஸ்மானி, பதிப்பு 1.0.2), காப்புரிமை © Tanzil.net, Creative Commons Attribution 3.0 இன் கீழ் உரிமம் பெற்றது. மாற்றமில்லாத நேரடி நகல்; முழு மூலம் மற்றும் சரிபார்ப்பு விவரங்களுக்கு assets/quran/README.md ஐப் பார்க்கவும்.';

  @override
  String get copyTanzilLinkSemanticLabel => 'tanzil.net இணைப்பை நகலெடு';

  @override
  String get copyTanzilLinkHint =>
      'தன்ஸில் திட்ட இணைய முகவரியை நகலெடுக்க இருமுறை தட்டவும்';

  @override
  String get copiedTanzilMessage => 'tanzil.net நகலெடுக்கப்பட்டது';

  @override
  String get goldSilverHeader => 'தங்கம் & வெள்ளி';

  @override
  String get goldGramsLabel => 'தங்கம் (கிராம்)';

  @override
  String get goldPriceLabel => 'தங்க விலை ஒரு கிராமுக்கு (இன்று)';

  @override
  String get silverGramsLabel => 'வெள்ளி (கிராம்)';

  @override
  String get silverPriceLabel => 'வெள்ளி விலை ஒரு கிராமுக்கு (இன்று)';

  @override
  String get otherAssetsHeader => 'மற்ற சொத்துக்கள் & பொறுப்புகள்';

  @override
  String get cashSavingsLabel => 'பணம் & சேமிப்பு';

  @override
  String get receivablesLabel => 'உங்களுக்குக் கிடைக்க வேண்டிய தொகைகள்';

  @override
  String get businessInventoryLabel => 'வணிக இருப்பு மதிப்பு';

  @override
  String get liabilitiesLabel =>
      'பொறுப்புகள் (இப்போது செலுத்த வேண்டிய கடன்கள்)';

  @override
  String get netWealthLabel => 'நிகர செல்வம்';

  @override
  String get zakatDueLabel => 'செலுத்த வேண்டிய ஜகாத் (2.5%)';

  @override
  String get nisabPromptMessage =>
      'நிசாப் வரம்பைக் காண தங்கம் அல்லது வெள்ளி விலையை உள்ளிடவும்.';

  @override
  String nisabThresholdMessage(String threshold, String met) {
    return 'நிசாப் வரம்பு: $threshold — $met.';
  }

  @override
  String get nisabMetLabel => 'எட்டப்பட்டது';

  @override
  String get nisabNotMetLabel => 'இன்னும் எட்டப்படவில்லை';

  @override
  String zakatSummarySemanticLabel(
      String netWealth, String nisabLabel, String zakatDue) {
    return 'நிகர செல்வம் $netWealth. $nisabLabel செலுத்த வேண்டிய ஜகாத்: $zakatDue.';
  }

  @override
  String get previousMonthLabel => 'முந்தைய மாதம்';

  @override
  String get nextMonthLabel => 'அடுத்த மாதம்';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get languageSinhala => 'සිංහල';

  @override
  String get languagePickerSemanticLabel => 'பயன்பாட்டு மொழி';
}
