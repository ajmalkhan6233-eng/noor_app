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
  String get quranTabLabel => 'அல் குர்ஆன்';

  @override
  String get duasTabLabel => 'துஆக்கள் & திக்ர்';

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
  String get qiblaAlignedMessage => 'அல்ஹம்துலில்லாஹ் — கிப்லா கண்டறியப்பட்டது';

  @override
  String get qiblaRotateMessage => 'கிப்லாவைக் கண்டறிய திருப்பவும்';

  @override
  String get quranScreenTitle => 'குர்ஆன்';

  @override
  String get bookmarksLabel => 'புத்தகக்குறிகள்';

  @override
  String get noBookmarksMessage =>
      'இன்னும் புத்தகக்குறிகள் இல்லை — படிக்கும்போது எந்த ஆயத்திலும் புத்தகக்குறி ஐகானைத் தட்டி இங்கு சேமிக்கவும்.';

  @override
  String get noAzkarBookmarksMessage =>
      'இன்னும் புத்தகக்குறிகள் இல்லை — எந்த துஆவிலும் புத்தகக்குறி ஐகானைத் தட்டி இங்கு சேமிக்கவும்.';

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
  String get editLocationNameHint =>
      'இருப்பிடப் பெயரைத் திருத்த இருமுறை தட்டவும்';

  @override
  String locationLabelSemanticValue(String label) {
    return 'இருப்பிடம்: $label';
  }

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
  String get preReminderSectionHeader => 'அதானுக்கு முந்தைய நினைவூட்டல்';

  @override
  String get batteryOptimizationSectionHeader => 'நம்பகமான அறிவிப்புகள்';

  @override
  String get batteryOptimizationExemptedMessage =>
      'இந்த ஆப் பேட்டரி மேம்படுத்தலில் இருந்து விலக்கு பெற்றுள்ளது — ஆப் மூடப்பட்டிருந்தாலும் தொழுகை அறிவிப்புகள் நம்பகமாக இயங்கும்.';

  @override
  String get batteryOptimizationNotExemptedMessage =>
      'சில தொலைபேசிகள் (குறிப்பாக Samsung, Xiaomi, மற்றும் Huawei) இந்த ஆப் விலக்கு பெறாவிட்டால் பேட்டரியை சேமிக்க திட்டமிடப்பட்ட தொழுகை அறிவிப்புகளை அமைதியாக நிறுத்தும்.';

  @override
  String get grantBatteryOptimizationExemptionLabel =>
      'வரம்பற்ற பேட்டரி பயன்பாட்டை அனுமதிக்கவும்';

  @override
  String get sunnahFastingCardTitle => 'இன்று சுன்னத் நோன்பு';

  @override
  String get sunnahFastingWeekdayReason =>
      'இன்று நோன்பு நோற்பது சுன்னத் ஆகும் — திங்கள் மற்றும் வியாழக்கிழமைகள் நபிகள் நாயகம் ﷺ அவர்களின் வழக்கமான நோன்பு நாட்களில் அடங்கும்.';

  @override
  String get sunnahFastingWhiteDayReason =>
      'இன்று வெள்ளை நாள் (ஹிஜ்ரி மாதத்தின் 13-15) — நோன்பு நோற்க பரிந்துரைக்கப்படும் நாள்.';

  @override
  String get sunnahFastingWhiteDayAndWeekdayReason =>
      'இன்று வெள்ளை நாளும், பரிந்துரைக்கப்பட்ட வார நாள் நோன்பும் சேர்ந்த நாள் — நோன்பு நோற்க மிகவும் சிறந்த நாள்.';

  @override
  String get locationSectionHeader => 'இருப்பிடம்';

  @override
  String get manageLocationInSettingsLabel =>
      'அமைப்புகளில் இருப்பிடத்தை நிர்வகிக்கவும்';

  @override
  String get locationResolveFailedMessage =>
      'உங்கள் இருப்பிடத்தை கண்டறிய முடியவில்லை. மீண்டும் முயற்சிக்கவும் அல்லது கீழே ஒரு மாவட்டத்தைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get usingGpsAutoResolveMessage =>
      'GPS பயன்படுத்தப்படுகிறது — நீங்கள் ஆப்ஸை திறக்கும் ஒவ்வொரு முறையும் தானாக தீர்மானிக்கப்படும்.';

  @override
  String get silentModeSectionHeader => 'மௌன பயன்முறை';

  @override
  String get displaySectionHeader => 'காட்சி';

  @override
  String get languageSectionHeader => 'மொழி';

  @override
  String get countrySectionHeader => 'நாடு';

  @override
  String get countryPickerSemanticLabel => 'நாடு';

  @override
  String get comingSoonLabel => 'விரைவில்';

  @override
  String get countryComingSoonHint =>
      'இன்னும் கிடைக்கவில்லை — தற்போது இலங்கை மட்டுமே முழுமையாக செயல்படுகிறது';

  @override
  String get countrySriLanka => 'இலங்கை';

  @override
  String get countryIndia => 'இந்தியா';

  @override
  String get countryMalaysia => 'மலேசியா';

  @override
  String get countryUnitedKingdom => 'ஐக்கிய இராச்சியம்';

  @override
  String get countryUnitedStates => 'அமெரிக்க ஐக்கிய நாடுகள்';

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
  String previewAdhanSemanticLabel(String label) {
    return '$label தொழுகை அழைப்பை முன்னோட்டமிடவும்';
  }

  @override
  String get playPreviewHint => 'இயக்க இருமுறை தட்டவும்';

  @override
  String get stopPreviewHint => 'நிறுத்த இருமுறை தட்டவும்';

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
      'நூர் எப்போதும் ஆஃப்லைனாகவும், விளம்பரமின்றியும் இருக்கும். அதன் வளர்ச்சிக்கு ஆதரவளிக்க விரும்பினால், விவரங்கள் திட்டப் பக்கத்தில் உள்ளன. ஜசாகல்லாஹு கைரன்.';

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
  String get englishTranslationAttribution =>
      'ஆங்கில மொழிபெயர்ப்பு: சஹீஹ் இன்டர்நேஷனல் (உம்மு முஹம்மது), Tanzil.net வழியாக. Tanzil மொழிபெயர்ப்புகளை வணிகரீதியற்ற பயன்பாட்டிற்கு மட்டுமே கட்டுப்படுத்துகிறது; முழு மூலம் மற்றும் உரிம விவரங்களுக்கு assets/quran_translations/README.md ஐப் பார்க்கவும்.';

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

  @override
  String get switchLanguageHint =>
      'பயன்பாட்டு மொழியை இதற்கு மாற்ற இருமுறை தட்டவும்';

  @override
  String get themeToggleSemanticLabel => 'தோற்றம்';

  @override
  String get themeToggleHint =>
      'இருள், வெளிச்சம், கணினி தீம் இடையே மாற்ற இருமுறை தட்டவும்';

  @override
  String get pilgrimageLabel => 'ஹஜ் & உம்ரா';

  @override
  String get pilgrimageMoreRowHint =>
      'ஹஜ் மற்றும் உம்ரா கண்காணிப்பானைத் திறக்க இருமுறை தட்டவும்';

  @override
  String get profilePickerTitle => 'ஒரு யாத்ரீகரைத் தேர்ந்தெடுக்கவும்';

  @override
  String get profilePickerEmptyMessage =>
      'இன்னும் சுயவிவரங்கள் இல்லை. கண்காணிக்கத் தொடங்க ஒன்றைச் சேர்க்கவும்.';

  @override
  String get addProfileLabel => 'யாத்ரீகரைச் சேர்';

  @override
  String get addProfileHint =>
      'புதிய யாத்ரீகர் சுயவிவரத்தைச் சேர்க்க இருமுறை தட்டவும்';

  @override
  String get profileNameFieldLabel => 'பெயர்';

  @override
  String get profileNameFieldHint => 'இந்த சுயவிவரத்திற்கான பெயரை உள்ளிடவும்';

  @override
  String get experienceLevelLabel => 'அனுபவ நிலை';

  @override
  String get beginnerLabel => 'புதியவர்';

  @override
  String get experiencedLabel => 'அனுபவமுள்ளவர்';

  @override
  String get createProfileButtonLabel => 'சுயவிவரத்தை உருவாக்கு';

  @override
  String get createProfileButtonHint =>
      'இந்த சுயவிவரத்தைச் சேமிக்க இருமுறை தட்டவும்';

  @override
  String selectProfileHint(String name) {
    return '$name ஆகத் தொடர இருமுறை தட்டவும்';
  }

  @override
  String get sessionSetupTitle => 'ஒரு அமர்வைத் தொடங்கு';

  @override
  String get pilgrimageTypeLabel => 'வகை';

  @override
  String get umrahLabel => 'உம்ரா';

  @override
  String get hajjLabel => 'ஹஜ்';

  @override
  String get genderLabel => 'பாலினம்';

  @override
  String get maleLabel => 'ஆண்';

  @override
  String get femaleLabel => 'பெண்';

  @override
  String get startSessionButtonLabel => 'தொடங்கு';

  @override
  String get startSessionButtonHint => 'புதிய அமர்வைத் தொடங்க இருமுறை தட்டவும்';

  @override
  String get resumeSessionMessage => 'முடிக்கப்படாத அமர்வு ஒன்று உள்ளது.';

  @override
  String get resumeSessionButtonLabel => 'தொடரவும்';

  @override
  String get resumeSessionButtonHint =>
      'முடிக்கப்படாத அமர்வைத் தொடர இருமுறை தட்டவும்';

  @override
  String get tawafScreenTitle => 'தவாஃப்';

  @override
  String get tawafCounterSemanticLabel => 'தவாஃப் சுற்று';

  @override
  String get tawafIncrementHint => 'ஒரு சுற்றை எண்ண இருமுறை தட்டவும்';

  @override
  String circuitProgressLabel(int count) {
    return 'சுற்று $count / 7';
  }

  @override
  String get tawafCompleteMessage => 'தவாஃப் நிறைவடைந்தது.';

  @override
  String get continueToSaiButtonLabel => 'ஸாயீக்குச் செல்';

  @override
  String get continueToSaiButtonHint => 'ஸாயீக்குச் செல்ல இருமுறை தட்டவும்';

  @override
  String get idtibaTitle => 'இத்திபா';

  @override
  String get idtibaExplanation =>
      'ஆண்கள் தவாஃப் முழுவதும் வலது தோளை மூடாமல் வைத்திருந்து, 7ஆவது சுற்று முடிந்தவுடன் மீண்டும் மூடிக்கொள்கிறார்கள்.';

  @override
  String get idtibaBadgeLabel => 'இத்திபா: தோள் திறந்திருக்கும்';

  @override
  String get ramalTitle => 'ரமல்';

  @override
  String get ramalExplanation =>
      'ஆண்கள் முதல் மூன்று சுற்றுகளில் வேகமாக, சிறு அடிகளுடன் நடந்து, நான்காவது சுற்றிலிருந்து இயல்பான வேகத்திற்குத் திரும்புகிறார்கள்.';

  @override
  String get ramalBadgeLabel => 'ரமல்: வேக நடை';

  @override
  String get saiScreenTitle => 'ஸாயீ';

  @override
  String get saiCounterSemanticLabel => 'ஸாயீ சுற்று';

  @override
  String get saiIncrementHint => 'ஒரு சுற்றை எண்ண இருமுறை தட்டவும்';

  @override
  String roundProgressLabel(int count) {
    return 'சுற்று $count / 7';
  }

  @override
  String get saiDirectionSafaToMarwah => 'ஸஃபாவிலிருந்து மர்வாவிற்கு';

  @override
  String get saiDirectionMarwahToSafa => 'மர்வாவிலிருந்து ஸஃபாவிற்கு';

  @override
  String get saiDirectionExplanation =>
      'ஸாயீ என்பது ஸஃபா மற்றும் மர்வா மலைகளுக்கு இடையே ஏழு முறை நடந்து, ஒவ்வொரு சுற்றிலும் திசையை மாற்றுவதாகும்.';

  @override
  String get completeSessionButtonLabel => 'நிறைவுசெய்';

  @override
  String get completeSessionButtonHint =>
      'இந்த அமர்வை முடிக்க இருமுறை தட்டவும்';

  @override
  String get completionScreenTitle => 'அல்ஹம்துலில்லாஹ்';

  @override
  String completionMessage(String type) {
    return 'உங்கள் $type அல்லாஹ்வால் ஏற்றுக்கொள்ளப்படட்டும்.';
  }

  @override
  String completionUmrahCountLabel(int count) {
    return 'நிறைவு செய்த உம்ரா: $count';
  }

  @override
  String completionHajjCountLabel(int count) {
    return 'நிறைவு செய்த ஹஜ்: $count';
  }

  @override
  String get doneButtonLabel => 'முடிந்தது';

  @override
  String get doneButtonHint => 'திரும்பச் செல்ல இருமுறை தட்டவும்';

  @override
  String get ofSevenSuffix => '/ 7';

  @override
  String get selectOptionHint => 'தேர்ந்தெடுக்க இருமுறை தட்டவும்';

  @override
  String get umrahGuideLabel => 'உம்ரா வழிகாட்டி';

  @override
  String get umrahGuideMoreRowHint =>
      'உம்ரா வழிகாட்டியைத் திறக்க இருமுறை தட்டவும்';

  @override
  String get hajjGuideLabel => 'ஹஜ் வழிகாட்டி';

  @override
  String get hajjGuideMoreRowHint =>
      'ஹஜ் வழிகாட்டியைத் திறக்க இருமுறை தட்டவும்';

  @override
  String get scholarConfirmationNotice =>
      'எல்லா சடங்கு விவரங்களையும் உங்கள் அறிஞர் அல்லது ஹஜ் குழுவிடம் உறுதிப்படுத்திக் கொள்ளுங்கள்.';

  @override
  String get guideTextNotLoadedMessage =>
      'சரிபார்க்கப்பட்ட மூலத்திலிருந்து இந்த வழிகாட்டி உரை இன்னும் ஏற்றப்படவில்லை';

  @override
  String get guideBodyEnglishOnlyNote =>
      'முழு விளக்கமும் தற்போது ஆங்கிலத்தில் மட்டுமே கிடைக்கிறது';

  @override
  String get umrahStep1Title => '1. குளியல் மற்றும் இஹ்ராம்';

  @override
  String get umrahStep2Title => '2. நியாத் (எண்ணம்)';

  @override
  String get umrahStep3Title => '3. தல்பியா';

  @override
  String get umrahStep4Title => '4. தவாஃப் (ஏழு சுற்றுகள்)';

  @override
  String get umrahStep5Title => '5. மகாம் இப்ராஹீமில் தொழுகை';

  @override
  String get umrahStep6Title => '6. ஸம்ஸம் நீர்';

  @override
  String get umrahStep7Title => '7. ஸயீ (ஏழு சுற்றுகள்)';

  @override
  String get umrahStep8Title => '8. ஹல்க் அல்லது தக்ஸீர்';

  @override
  String guideStepLabel(int number) {
    return 'படி $number';
  }

  @override
  String guideDayLabel(int number) {
    return 'நாள் $number';
  }

  @override
  String get talbiyahSectionTitle => 'தல்பியா';

  @override
  String get guideReferenceLabel => 'மேற்கோள்';

  @override
  String get rabbanaSectionTitle => 'பரிந்துரைக்கப்படும் துஆ — குர்ஆன் 2:201';

  @override
  String get womenTawafNote =>
      'பெண்கள் தவாஃப் முழுவதும் இயல்பான வேகத்தில் நடந்து, இரு தோள்களையும் மூடியிருப்பார்கள் — இத்திபாவும் ரமலும் அவர்களுக்குப் பொருந்தாது.';

  @override
  String get tawafDuaSectionTitle => 'ஓதவேண்டிய துஆ';

  @override
  String get saiDuaSectionTitle => 'ஓதவேண்டிய திக்ர்';

  @override
  String reciteCountLabel(int count) {
    return '×$count முறை ஓதவும்';
  }

  @override
  String get todaysPrayersLabel => 'இன்றைய தொழுகைகள்';

  @override
  String get assalamuAlaikumGreeting => 'அஸ்ஸலாமு அலைக்கும்';

  @override
  String dayStreakBadgeLabel(int days) {
    return '$days நாள் தொடர்ச்சி';
  }

  @override
  String goalsProgressLabel(int completed, int total, int percent) {
    return '$completed/$total இலக்குகள் · $percent%';
  }

  @override
  String get suhoorLabel => 'சுஹூர்';

  @override
  String get iftarLabel => 'இஃப்தார்';

  @override
  String get ayahOfTheDayTitle => 'இன்றைய வசனம்';

  @override
  String get copyLabel => 'நகலெடு';

  @override
  String get copiedConfirmationLabel => 'கிளிப்போர்டுக்கு நகலெடுக்கப்பட்டது';

  @override
  String get fullQuranCtaLabel => 'முழு குர்ஆன்';

  @override
  String get dailyGoalsSectionTitle => 'இன்றைய ஆன்மீக இலக்குகள்';

  @override
  String get noPrayerStreakMessage => 'தற்போது தொடர் தொழுகை இல்லை';

  @override
  String prayerStreakLabel(int count) {
    return 'தொழுகை தொடர்: $count நாள்';
  }

  @override
  String get fastingTodayLabel => 'இன்று நோன்பு';

  @override
  String get markFastingHint =>
      'இன்று நோன்பு நோற்றதாகக் குறிக்க இருமுறை தட்டவும்';

  @override
  String get unmarkFastingHint =>
      'இன்றைய நோன்பு குறியீட்டை நீக்க இருமுறை தட்டவும்';

  @override
  String get noFastingStreakMessage => 'தற்போது தொடர் நோன்பு இல்லை';

  @override
  String fastingStreakLabel(int count) {
    return 'நோன்பு தொடர்: $count நாள்';
  }

  @override
  String markPrayerDoneHint(String label) {
    return '$label முடிந்ததாகக் குறிக்க இருமுறை தட்டவும்';
  }

  @override
  String unmarkPrayerHint(String label) {
    return '$label குறியீட்டை நீக்க இருமுறை தட்டவும்';
  }

  @override
  String get locationSetViaGpsLabel => 'இருப்பிடம்: நடப்பு (GPS)';

  @override
  String get locationSetLabel => 'இருப்பிடம் அமைக்கப்பட்டது';

  @override
  String get changeLocationSemanticLabel => 'இருப்பிடத்தை மாற்று';

  @override
  String get changeLocationHint =>
      'இருப்பிடம் அமைக்கும் முறையை மாற்ற இருமுறை தட்டவும்';

  @override
  String get changeLabel => 'மாற்று';

  @override
  String get enterManuallyLabel => 'கைமுறையாக உள்ளிடவும் (மேம்பட்டது)';

  @override
  String get hideManualEntryLabel => 'கைமுறை உள்ளீட்டை மறை';

  @override
  String get turnOffNotificationHint => 'நிறுத்த இருமுறை தட்டவும்';

  @override
  String get turnOnNotificationHint => 'இயக்க இருமுறை தட்டவும்';

  @override
  String get setLocationOnPrayerTabMessage =>
      'இன்றைய நேர அட்டவணையைக் காண, தொழுகை நேரம் தாவலில் உங்கள் இருப்பிடத்தை அமைக்கவும்.';

  @override
  String get religiousContentNoteHeader => 'மத உள்ளடக்கம் குறித்த குறிப்பு';

  @override
  String get religiousContentNoteBody =>
      'இந்த பயன்பாட்டில் உள்ள குர்ஆன் உரையும் அஃதுகாரும் சரிபார்க்கப்பட்ட மூலங்களிலிருந்து பெறப்பட்டவை — குர்ஆனுக்கு தன்ஸில் திட்டமும், அஃதுகாருக்கு ஹிஸ்ன் அல்-முஸ்லிமும் — மேலும் அந்த மூலங்களுடன் கவனமாக சரிபார்க்கப்பட்டுள்ளன. இருப்பினும், நாங்கள் மனிதர்கள் மட்டுமே, எந்த முயற்சியும் தவறுகளிலிருந்து முற்றிலும் விடுபட்டதல்ல. இந்த உள்ளடக்கம் தற்போது உள்ளூர் இஸ்லாமிய அறிஞர்களுடன் மறுஆய்வு செய்யப்பட்டு வருகிறது — இது தொடர்ச்சியான ஒரு செயல்முறையாகும், வெளியீட்டிற்குப் பிறகும் தொடரும். திருத்தம் தேவைப்படும் எதையேனும் நீங்கள் கவனித்தால், தயவுசெய்து எங்களைத் தொடர்பு கொள்ளுங்கள் — நாங்கள் அதை வரவேற்கிறோம். இந்த பணியை பணிவுடன் அணுகுகிறோம், மேலும் அறியாமல் ஏற்படும் எந்த தவறுக்கும் அல்லாஹ்விடம் மன்னிப்பு கோருகிறோம்.';

  @override
  String get religiousContentQuietNote =>
      'இந்த உள்ளடக்கம் கவனமாக மூலமாக்கப்பட்டு சரிபார்க்கப்பட்டுள்ளது, மேலும் தொடர்ச்சியான அறிஞர் மறுஆய்வின் கீழ் உள்ளது. திருத்தம் தேவைப்படும் ஏதேனும் கண்டீர்களா? தயவுசெய்து எங்களுக்குத் தெரியப்படுத்துங்கள்.';
}
