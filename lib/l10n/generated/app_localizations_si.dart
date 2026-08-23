// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get homeTab => 'මුල් පිටුව';

  @override
  String get moreTab => 'තවත්';

  @override
  String get quranTabLabel => 'අල් කුර්ආන්';

  @override
  String get duasTabLabel => 'දුආ සහ දික්ර්';

  @override
  String get settingsSemanticLabel => 'සැකසුම්';

  @override
  String get settingsHint => 'සැකසුම් විවෘත කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String openItemHint(String label) {
    return '$label විවෘත කිරීමට දෙවරක් තට්ටු කරන්න';
  }

  @override
  String get openHint => 'විවෘත කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get cancelLabel => 'අවලංගු කරන්න';

  @override
  String get saveLabel => 'සුරකින්න';

  @override
  String get closeLabel => 'වසන්න';

  @override
  String get closeDialogSemanticLabel => 'සංවාදය වසන්න';

  @override
  String get tasbihScreenTitle => 'තස්බීහ්';

  @override
  String get tasbihCounterSemanticLabel => 'තස්බීහ් ගණකය';

  @override
  String get tasbihResetSemanticLabel => 'තස්බීහ් ගණන යළි පිහිටුවන්න';

  @override
  String get resetLabel => 'යළි පිහිටුවන්න';

  @override
  String get tasbihResetHint => 'ගණන බිංදුවට යළි පිහිටුවීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get tasbihIncrementHint => 'එකතු කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get dhikrSelectorSemanticLabel => 'ගණන් කළ යුතු ධික්ර්';

  @override
  String currentlyCountingLabel(String dhikr) {
    return 'දැනට ගණන් කරන්නේ $dhikr';
  }

  @override
  String get prayerTimesScreenTitle => 'සලාත් වේලාවන්';

  @override
  String get openMonthlyTimetableSemanticLabel =>
      'මාසික සලාත් කාල සටහන විවෘත කරන්න';

  @override
  String get monthlyTimetableScreenTitle => 'මාසික කාල සටහන';

  @override
  String get useGpsSemanticLabel => 'මගේ වත්මන් ස්ථානය භාවිත කරන්න';

  @override
  String get useGpsHint =>
      'GPS මගින් ඔබේ ස්ථානය සොයා ගැනීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get locatingLabel => 'සොයමින්…';

  @override
  String get useMyLocationLabel => 'මගේ ස්ථානය භාවිත කරන්න';

  @override
  String get latitudeLabel => 'අක්ෂාංශය';

  @override
  String get longitudeLabel => 'දේශාංශය';

  @override
  String get applyManualLocationSemanticLabel =>
      'අතින් ඇතුළත් කළ ඛණ්ඩාංක යොදන්න';

  @override
  String get applyCoordinatesLabel => 'ඛණ්ඩාංක යොදන්න';

  @override
  String get manualLatitudeSemanticLabel => 'අතින් අක්ෂාංශ ඇතුළත් කිරීම';

  @override
  String get manualLongitudeSemanticLabel => 'අතින් දේශාංශ ඇතුළත් කිරීම';

  @override
  String get calculationMethodSemanticLabel => 'ගණන් කිරීමේ ක්‍රමය';

  @override
  String get asrMadhabSemanticLabel => 'අස්ර් මධ්හබ්';

  @override
  String get highLatitudeRuleSemanticLabel => 'අධි අක්ෂාංශ නීතිය';

  @override
  String get highLatitudeUnresolvedMessage =>
      'මෙම ස්ථානය සහ දිනය සඳහා සැබෑ ඉෂා (හෝ ෆජ්ර්) වේලාවක් නොපවතී — හිරු අවශ්‍ය කෝණයට නොපැමිණේ. මෙහි ඇස්තමේන්තුගත වේලාවක් පෙන්වීම නොමඟ යවන සුළු බැවින්, කිසිවක් පෙන්වා නොමැත.';

  @override
  String get districtSelectorSemanticLabel =>
      'ශ්‍රී ලාංකික දිස්ත්‍රික්කයක් තෝරන්න';

  @override
  String get districtFieldLabel => 'ශ්‍රී ලාංකික දිස්ත්‍රික්කය (විකල්ප)';

  @override
  String get chooseDistrictHint => 'දිස්ත්‍රික්කයක් තෝරන්න';

  @override
  String get noneSelectedLabel => 'කිසිවක් තෝරාගෙන නැත';

  @override
  String get enterLocationPrompt =>
      'සලාත් වේලාවන් බැලීමට ඔබේ ස්ථානය ඇතුළත් කරන්න.';

  @override
  String activeCalculationSettingsLabel(String text) {
    return 'සක්‍රීය ගණන් කිරීමේ සැකසුම්: $text';
  }

  @override
  String get qiblaScreenTitle => 'කිබ්ලා';

  @override
  String get qiblaNeedleSemanticLabel => 'කිබ්ලා දිශා කටුව';

  @override
  String get recentreCompassLabel => 'දික්සූචිය නැවත මධ්‍යගත කරන්න';

  @override
  String get qiblaCalibrationPromptMessage =>
      'දික්සූචි කියවීම වත්මන් ක්‍රමාංකනය කර නැත හෝ විශ්වාසදායක නොවේ — ක්‍රමාංකනය කිරීමට ඔබේ උපකරණය අටේ හැඩැති චලනයකින් ගෙනයන්න. එතෙක් වැරදි දිශාවකට විශ්වාසයෙන් පෙන්වීම වළක්වා ගැනීමට කටුව අඳුරු කර ඇත.';

  @override
  String get qiblaNoCompassMessage =>
      'මෙම උපකරණයේ දික්සූචියක් නොමැත — කිබ්ලා දිශාව අංකයක් ලෙස පමණක් පෙන්වයි.';

  @override
  String get quranScreenTitle => 'අල් කුර්ආනය';

  @override
  String get bookmarksLabel => 'පිටු සලකුණු';

  @override
  String get noBookmarksMessage =>
      'තවම පිටු සලකුණු නොමැත — කියවන අතරතුර ඕනෑම ආයාවක් මත පිටු සලකුණු අයිකනය තට්ටු කර එය මෙහි සුරකින්න.';

  @override
  String get searchQuranSemanticLabel => 'අල් කුර්ආනයේ සොයන්න';

  @override
  String get searchHintText => 'සොයන්න…';

  @override
  String searchResultSemanticLabel(int surahId, int ayahNumber) {
    return 'සෙවුම් ප්‍රතිඵලය: සූරා $surahId, ආයා $ayahNumber';
  }

  @override
  String surahAyahLabel(int surahId, int ayahNumber) {
    return 'සූරා $surahId, ආයා $ayahNumber';
  }

  @override
  String surahReaderTitle(int surahId) {
    return 'සූරා $surahId';
  }

  @override
  String get quranAssetMissingMessage =>
      'මෙම විශේෂාංගය සක්‍රීය කිරීමට කුර්ආන් මූලාශ්‍ර ගොනුවක් එක් කරන්න.';

  @override
  String get quranVerificationFailedMessage =>
      'කුර්ආන් පෙළ ප්‍රතිස්ථාපනය කිරීමට යෙදුම නැවත ස්ථාපනය කරන්න හෝ යාවත්කාලීන කරන්න — මෙම උපකරණයේ ඇති ගොනුව සත්‍යාපනය සමත් නොවීය.';

  @override
  String importingQuranProgressSemanticLabel(int percent) {
    return 'කුර්ආන් පෙළ ආනයනය කරමින්, $percent සියයට සම්පූර්ණයි';
  }

  @override
  String get importingQuranLabel => 'කුර්ආන් පෙළ ආනයනය කරමින්…';

  @override
  String get azkarScreenTitle => 'අස්කාර්';

  @override
  String dhikrCountSemanticLabel(int count, int total) {
    return 'මෙම ධික්ර් සඳහා ගණන: $total න් $count';
  }

  @override
  String get countHint => 'එක් වරක් ගණන් කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String sourceLabel(String source) {
    return 'මූලාශ්‍රය: $source';
  }

  @override
  String get nextPrayerLabel => 'ඊළඟ සලාතය';

  @override
  String nextPrayerAnnouncement(String name, String time) {
    return 'ඊළඟ සලාතය: $name, $time ට';
  }

  @override
  String get ishaPassedAnnouncement =>
      'ඉෂා ගෙවී ගොස් ඇත; ඊළඟ සලාතය හෙට දිනයේ ෆජ්ර් වේ';

  @override
  String get todayLabel => 'අද';

  @override
  String get setLocationPrompt =>
      'අද දින කාලසටහන මෙහි බැලීමට සලාත් වේලාවන් පටිත්තෙහි ඔබේ ස්ථානය සකසන්න.';

  @override
  String get notificationsSectionHeader => 'දැනුම්දීම්';

  @override
  String get locationNameDialogTitle => 'ස්ථානයේ නම';

  @override
  String get editLocationNameHint =>
      'ඔබේ ස්ථානයේ නම සංස්කරණය කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String locationLabelSemanticValue(String label) {
    return 'ස්ථානය: $label';
  }

  @override
  String get locationNameHint => 'උදා. අම්මාන්, ජෝර්දානය';

  @override
  String get qiblaLabel => 'කිබ්ලා';

  @override
  String get calendarLabel => 'දින දර්ශනය';

  @override
  String get zakatCalculatorLabel => 'සකාත් ගණකය';

  @override
  String get aboutLabel => 'පිළිබඳ';

  @override
  String get calculationSectionHeader => 'ගණනය';

  @override
  String get manualAdjustmentsSectionHeader => 'අතින් සකස් කිරීම් (මිනිත්තු)';

  @override
  String get iqamathOffsetsSectionHeader =>
      'ඉකාමත් කාල පරතරය (අදාන් වලින් පසු මිනිත්තු)';

  @override
  String get silentModeSectionHeader => 'නිශ්ශබ්ද ප්‍රකාරය';

  @override
  String get displaySectionHeader => 'සංදර්ශනය';

  @override
  String get languageSectionHeader => 'භාෂාව';

  @override
  String get countrySectionHeader => 'රට';

  @override
  String get countryPickerSemanticLabel => 'රට';

  @override
  String get comingSoonLabel => 'ඉක්මනින්';

  @override
  String get countryComingSoonHint =>
      'තවම ලබා ගත නොහැක — දැනට සම්පූර්ණයෙන් ක්‍රියාත්මක වන්නේ ශ්‍රී ලංකාව පමණි';

  @override
  String get countrySriLanka => 'ශ්‍රී ලංකාව';

  @override
  String get countryIndia => 'ඉන්දියාව';

  @override
  String get countryMalaysia => 'මැලේසියාව';

  @override
  String get countryUnitedKingdom => 'එක්සත් රාජධානිය';

  @override
  String get countryUnitedStates => 'එක්සත් ජනපදය';

  @override
  String get themeSemanticLabel => 'තේමාව';

  @override
  String get arabicTextSizeSemanticLabel => 'අරාබි අකුරු ප්‍රමාණය';

  @override
  String get hijriOffsetLabel => 'හිජ්රි වෙනස';

  @override
  String get decreaseHijriOffsetLabel => 'හිජ්රි වෙනස අඩු කරන්න';

  @override
  String get increaseHijriOffsetLabel => 'හිජ්රි වෙනස වැඩි කරන්න';

  @override
  String decreaseOffsetLabel(String label) {
    return '$label වෙනස අඩු කරන්න';
  }

  @override
  String increaseOffsetLabel(String label) {
    return '$label වෙනස වැඩි කරන්න';
  }

  @override
  String decreaseIqamathOffsetLabel(String label) {
    return '$label ඉකාමත් වෙනස අඩු කරන්න';
  }

  @override
  String increaseIqamathOffsetLabel(String label) {
    return '$label ඉකාමත් වෙනස වැඩි කරන්න';
  }

  @override
  String get extraMinutesAfterIqamathLabel => 'ඉකාමත්වලින් පසු අමතර මිනිත්තු';

  @override
  String get decreaseExtraSilentMinutesLabel =>
      'අමතර නිශ්ශබ්ද මිනිත්තු අඩු කරන්න';

  @override
  String get increaseExtraSilentMinutesLabel =>
      'අමතර නිශ්ශබ්ද මිනිත්තු වැඩි කරන්න';

  @override
  String get grantDndAccessLabel => 'බාධා නොකරන්න ප්‍රවේශය ලබා දෙන්න';

  @override
  String get grantDndAccessHint =>
      'නිශ්ශබ්ද ප්‍රකාරයට ස්වයංක්‍රීයව රින්ගර් මාරු කිරීමට මෙය අවශ්‍යයි';

  @override
  String silentModeToggleSemanticLabel(String label) {
    return '$label නිශ්ශබ්ද ප්‍රකාරය';
  }

  @override
  String notificationToggleSemanticLabel(String label) {
    return '$label දැනුම්දීම';
  }

  @override
  String previewAdhanSemanticLabel(String label) {
    return '$label අදාන් පෙරදසුන';
  }

  @override
  String get playPreviewHint => 'වාදනය කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get stopPreviewHint => 'නැවැත්වීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get aboutNoorSemanticLabel => 'නූර් පිළිබඳ';

  @override
  String get donateLabel => 'පරිත්‍යාග කරන්න';

  @override
  String get donateHint =>
      'මෙම ව්‍යාපෘතියට සහාය දැක්වීමේ ක්‍රම සඳහා දෙවරක් තට්ටු කරන්න';

  @override
  String get supportNoorTitle => 'නූර්ට සහාය වන්න';

  @override
  String get supportNoorMessage =>
      'නූර් සැමවිටම නොමිලේ, අන්තර්ජාල රහිතව සහ දැන්වීම් රහිතව පවතිනු ඇත. එහි සංවර්ධනයට සහාය දැක්වීමට කැමති නම්, විස්තර ව්‍යාපෘති පිටුවේ ඇත. ජසාකල්ලාහු කයිරන්.';

  @override
  String get appTagline =>
      'පිරිසිදු, පෞද්ගලිකත්වයට ප්‍රමුඛත්වය දෙන, දැන්වීම් රහිත ඉස්ලාමීය උපයෝගිතා යෙදුමකි. සම්පූර්ණයෙන්ම අන්තර්ජාල රහිත: දැන්වීම් නැත, විශ්ලේෂණ නැත, දුරස්ථ දත්ත සම්ප්‍රේෂණයක් නැත.';

  @override
  String get typefacesHeader => 'අකුරු වර්ග';

  @override
  String get fontRoleDisplay =>
      'සංදර්ශනය — සලාත් වේලාවන්, බිස්මිල්ලාහ්, ශීර්ෂක';

  @override
  String get fontRoleBody => 'ශරීරය — ලේබල්, සැකසුම්, පාලක';

  @override
  String get fontRoleArabic => 'අරාබි පෙළ';

  @override
  String get fontRoleTamil => 'දෙමළ අතුරුමුහුණත් පෙළ';

  @override
  String get fontRoleSinhala => 'සිංහල අතුරුමුහුණත් පෙළ';

  @override
  String get fontLicenceNotice =>
      'සෑම එකක්ම SIL Open Font Licence 1.1 යටතේ බලපත්‍රලාභී වන අතර, සම්පූර්ණයෙන්ම අන්තර්ජාල රහිත භාවිතය සඳහා යෙදුම සමඟ ඇතුළත් කර ඇත.';

  @override
  String get openSourceLicencesLabel => 'විවෘත මූලාශ්‍ර බලපත්‍ර';

  @override
  String get openLicencesHint =>
      'තෙවන පාර්ශ්ව බලපත්‍ර බැලීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get noLicencesMessage => 'පෙන්වීමට තෙවන පාර්ශ්ව බලපත්‍ර නොමැත.';

  @override
  String get licenceExpandHint => 'විස්තීරණය කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get licenceCollapseHint => 'හකුළා දැමීමට දෙවරක් තට්ටු කරන්න';

  @override
  String packageLicenceSemanticLabel(String package) {
    return '$package බලපත්‍රය';
  }

  @override
  String get textSourcesHeader => 'පෙළ මූලාශ්‍ර';

  @override
  String get quranSourceAttribution =>
      'කුර්ආන් පෙළ: Tanzil Quran Text (Uthmani, සංස්කරණය 1.0.2), ප්‍රකාශන හිමිකම © Tanzil.net, Creative Commons Attribution 3.0 යටතේ බලපත්‍රලාභී. නොවෙනස් කළ නිවැරදි පිටපතකි; සම්පූර්ණ මූලාශ්‍ර හා සත්‍යාපන විස්තර සඳහා assets/quran/README.md බලන්න.';

  @override
  String get copyTanzilLinkSemanticLabel => 'tanzil.net සබැඳිය පිටපත් කරන්න';

  @override
  String get copyTanzilLinkHint =>
      'Tanzil ව්‍යාපෘතියේ වෙබ් ලිපිනය පිටපත් කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get copiedTanzilMessage => 'tanzil.net පිටපත් කරන ලදී';

  @override
  String get englishTranslationAttribution =>
      'ඉංග්‍රීසි පරිවර්තනය: සහීහ් ඉන්ටනැෂනල් (උම්මු මුහම්මද්), Tanzil.net හරහා. Tanzil පරිවර්තන වාණිජ නොවන භාවිතයට පමණක් සීමා කරයි; සම්පූර්ණ මූලාශ්‍රය සහ බලපත්‍ර විස්තර සඳහා assets/quran_translations/README.md බලන්න.';

  @override
  String get goldSilverHeader => 'රත්‍රන් සහ රිදී';

  @override
  String get goldGramsLabel => 'රත්‍රන් (ග්‍රෑම්)';

  @override
  String get goldPriceLabel => 'රත්‍රන් මිල එක් ග්‍රෑමයකට (අද)';

  @override
  String get silverGramsLabel => 'රිදී (ග්‍රෑම්)';

  @override
  String get silverPriceLabel => 'රිදී මිල එක් ග්‍රෑමයකට (අද)';

  @override
  String get otherAssetsHeader => 'වෙනත් වත්කම් සහ බැරකම්';

  @override
  String get cashSavingsLabel => 'මුදල් සහ ඉතුරුම්';

  @override
  String get receivablesLabel => 'ඔබට ලැබිය යුතු මුදල්';

  @override
  String get businessInventoryLabel => 'ව්‍යාපාරික තොග වටිනාකම';

  @override
  String get liabilitiesLabel => 'බැරකම් (දැන් ගෙවිය යුතු ණය)';

  @override
  String get netWealthLabel => 'නිශ්කලංක ධනය';

  @override
  String get zakatDueLabel => 'ගෙවිය යුතු සකාත් (2.5%)';

  @override
  String get nisabPromptMessage =>
      'නිසාබ් සීමාව බැලීමට රත්‍රන් හෝ රිදී මිලක් ඇතුළත් කරන්න.';

  @override
  String nisabThresholdMessage(String threshold, String met) {
    return 'නිසාබ් සීමාව: $threshold — $met.';
  }

  @override
  String get nisabMetLabel => 'සපුරා ඇත';

  @override
  String get nisabNotMetLabel => 'තවම සපුරා නැත';

  @override
  String zakatSummarySemanticLabel(
      String netWealth, String nisabLabel, String zakatDue) {
    return 'නිශ්කලංක ධනය $netWealth. $nisabLabel ගෙවිය යුතු සකාත්: $zakatDue.';
  }

  @override
  String get previousMonthLabel => 'පෙර මාසය';

  @override
  String get nextMonthLabel => 'ඊළඟ මාසය';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get languageSinhala => 'සිංහල';

  @override
  String get languagePickerSemanticLabel => 'යෙදුම් භාෂාව';

  @override
  String get switchLanguageHint =>
      'යෙදුමේ භාෂාව මෙයට මාරු කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get themeToggleSemanticLabel => 'තේමාව';

  @override
  String get themeToggleHint =>
      'අඳුරු, ආලෝක සහ පද්ධති තේමා අතර මාරු කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get pilgrimageLabel => 'හජ් සහ උම්රා';

  @override
  String get pilgrimageMoreRowHint =>
      'හජ් සහ උම්රා ට්‍රැකරය විවෘත කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get profilePickerTitle => 'වන්දනාකරුවෙකු තෝරන්න';

  @override
  String get profilePickerEmptyMessage =>
      'තවම පැතිකඩ නැත. නිරීක්ෂණය කිරීමට එකක් එක් කරන්න.';

  @override
  String get addProfileLabel => 'වන්දනාකරු එකතු කරන්න';

  @override
  String get addProfileHint =>
      'නව වන්දනාකරු පැතිකඩක් එක් කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get profileNameFieldLabel => 'නම';

  @override
  String get profileNameFieldHint => 'මෙම පැතිකඩ සඳහා නමක් ඇතුළත් කරන්න';

  @override
  String get experienceLevelLabel => 'පළපුරුද්ද';

  @override
  String get beginnerLabel => 'අලුත්';

  @override
  String get experiencedLabel => 'පළපුරුදු';

  @override
  String get createProfileButtonLabel => 'පැතිකඩ සාදන්න';

  @override
  String get createProfileButtonHint =>
      'මෙම පැතිකඩ සුරැකීමට දෙවරක් තට්ටු කරන්න';

  @override
  String selectProfileHint(String name) {
    return '$name ලෙස ඉදිරියට යාමට දෙවරක් තට්ටු කරන්න';
  }

  @override
  String get sessionSetupTitle => 'සැසියක් ආරම්භ කරන්න';

  @override
  String get pilgrimageTypeLabel => 'වර්ගය';

  @override
  String get umrahLabel => 'උම්රා';

  @override
  String get hajjLabel => 'හජ්';

  @override
  String get genderLabel => 'ලිංගිකත්වය';

  @override
  String get maleLabel => 'පිරිමි';

  @override
  String get femaleLabel => 'ගැහැණු';

  @override
  String get startSessionButtonLabel => 'ආරම්භ කරන්න';

  @override
  String get startSessionButtonHint =>
      'නව සැසියක් ආරම්භ කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get resumeSessionMessage => 'නොසම්පූර්ණ සැසියක් පවතී.';

  @override
  String get resumeSessionButtonLabel => 'දිගටම කරගෙන යන්න';

  @override
  String get resumeSessionButtonHint =>
      'නොසම්පූර්ණ සැසිය දිගටම කරගෙන යාමට දෙවරක් තට්ටු කරන්න';

  @override
  String get tawafScreenTitle => 'තවාෆ්';

  @override
  String get tawafCounterSemanticLabel => 'තවාෆ් වටය';

  @override
  String get tawafIncrementHint => 'වටයක් ගණන් කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String circuitProgressLabel(int count) {
    return 'වටය $count / 7';
  }

  @override
  String get tawafCompleteMessage => 'තවාෆ් සම්පූර්ණයි.';

  @override
  String get continueToSaiButtonLabel => 'සායි වෙත යන්න';

  @override
  String get continueToSaiButtonHint => 'සායි වෙත යාමට දෙවරක් තට්ටු කරන්න';

  @override
  String get idtibaTitle => 'ඉද්තිබා';

  @override
  String get idtibaExplanation =>
      'පිරිමින් තවාෆ් පුරාවටම දකුණු උරහිස විවෘතව තබා, 7වන වටය අවසන් වූ පසු එය නැවත ආවරණය කරයි.';

  @override
  String get idtibaBadgeLabel => 'ඉද්තිබා: උරහිස විවෘතයි';

  @override
  String get ramalTitle => 'රමල්';

  @override
  String get ramalExplanation =>
      'පිරිමින් පළමු වට තුන තුළ කෙටි පියවර වලින් වේගයෙන් ඇවිද, හතරවන වටයේ සිට සාමාන්‍ය වේගයට යති.';

  @override
  String get ramalBadgeLabel => 'රමල්: වේගවත් ගමන';

  @override
  String get saiScreenTitle => 'සායි';

  @override
  String get saiCounterSemanticLabel => 'සායි වටය';

  @override
  String get saiIncrementHint => 'වටයක් ගණන් කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String roundProgressLabel(int count) {
    return 'වටය $count / 7';
  }

  @override
  String get saiDirectionSafaToMarwah => 'සෆා සිට මර්වා දක්වා';

  @override
  String get saiDirectionMarwahToSafa => 'මර්වා සිට සෆා දක්වා';

  @override
  String get saiDirectionExplanation =>
      'සායි යනු සෆා සහ මර්වා කඳු අතර වාර හතක් ඇවිදීමයි, සෑම වටයකදීම දිශාව මාරු කරමින්.';

  @override
  String get completeSessionButtonLabel => 'සම්පූර්ණ කරන්න';

  @override
  String get completeSessionButtonHint =>
      'මෙම සැසිය අවසන් කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get completionScreenTitle => 'අල්හම්දුලිල්ලාහ්';

  @override
  String completionMessage(String type) {
    return 'ඔබගේ $type අල්ලාහ් පිළිගනී වා.';
  }

  @override
  String completionUmrahCountLabel(int count) {
    return 'සම්පූර්ණ කළ උම්රා: $count';
  }

  @override
  String completionHajjCountLabel(int count) {
    return 'සම්පූර්ණ කළ හජ්: $count';
  }

  @override
  String get doneButtonLabel => 'නිමයි';

  @override
  String get doneButtonHint => 'ආපසු යාමට දෙවරක් තට්ටු කරන්න';

  @override
  String get ofSevenSuffix => '/ 7';

  @override
  String get selectOptionHint => 'තේරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get umrahGuideLabel => 'උම්රා මාර්ගෝපදේශය';

  @override
  String get umrahGuideMoreRowHint =>
      'උම්රා මාර්ගෝපදේශය විවෘත කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get hajjGuideLabel => 'හජ් මාර්ගෝපදේශය';

  @override
  String get hajjGuideMoreRowHint =>
      'හජ් මාර්ගෝපදේශය විවෘත කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get scholarConfirmationNotice =>
      'සියලුම චාරිත්‍ර විස්තර ඔබේ විද්වතා හෝ හජ් කණ්ඩායම සමඟ තහවුරු කරගන්න.';

  @override
  String get guideTextNotLoadedMessage =>
      'සත්‍යාපිත මූලාශ්‍රයකින් මෙම මාර්ගෝපදේශ පෙළ තවම පූරණය කර නැත';

  @override
  String get guideBodyEnglishOnlyNote =>
      'සම්පූර්ණ විස්තරය දැනට ඉංග්‍රීසියෙන් පමණක් ලබාගත හැක';

  @override
  String get umrahStep1Title => '1. ගුස්ල් සහ ඉහ්‍රාම්';

  @override
  String get umrahStep2Title => '2. නියියා (චේතනාව)';

  @override
  String get umrahStep3Title => '3. තල්බියා';

  @override
  String get umrahStep4Title => '4. තවාෆ් (වටරවුම් හතක්)';

  @override
  String get umrahStep5Title => '5. මකාම් ඉබ්‍රාහීම්හිදී සලාතය';

  @override
  String get umrahStep6Title => '6. සම්සම් ජලය';

  @override
  String get umrahStep7Title => '7. සායි (ගමන් හතක්)';

  @override
  String get umrahStep8Title => '8. හල්ක් හෝ තක්සීර්';

  @override
  String guideStepLabel(int number) {
    return 'පියවර $number';
  }

  @override
  String guideDayLabel(int number) {
    return 'දිනය $number';
  }

  @override
  String get talbiyahSectionTitle => 'තල්බියා';

  @override
  String get guideReferenceLabel => 'මූලාශ්‍රය';

  @override
  String get rabbanaSectionTitle => 'යෝජිත ප්‍රාර්ථනාව — කුර්ආන් 2:201';

  @override
  String get womenTawafNote =>
      'කාන්තාවන් තවාෆ් පුරාවටම සාමාන්‍ය වේගයෙන් ඇවිද, උරහිස් දෙකම ආවරණය කර සිටිති — ඉද්තිබා සහ රමල් ඔවුන්ට අදාළ නොවේ.';

  @override
  String get tawafDuaSectionTitle => 'පාඨනය කළ යුතු දුආව';

  @override
  String get saiDuaSectionTitle => 'පාඨනය කළ යුතු දික්ර්';

  @override
  String reciteCountLabel(int count) {
    return '×$count වර පාඨනය කරන්න';
  }

  @override
  String get todaysPrayersLabel => 'අද සලාත්';

  @override
  String get assalamuAlaikumGreeting => 'අස්සලාමු අලෙයිකුම්';

  @override
  String dayStreakBadgeLabel(int days) {
    return '$days දින අඛණ්ඩතාවය';
  }

  @override
  String goalsProgressLabel(int completed, int total, int percent) {
    return '$completed/$total ඉලක්ක · $percent%';
  }

  @override
  String get suhoorLabel => 'සුහූර්';

  @override
  String get iftarLabel => 'ඉෆ්තාර්';

  @override
  String get ayahOfTheDayTitle => 'අද දිනයේ වැකිය';

  @override
  String get copyLabel => 'පිටපත් කරන්න';

  @override
  String get copiedConfirmationLabel => 'පසුරු පුවරුවට පිටපත් කරන ලදී';

  @override
  String get fullQuranCtaLabel => 'සම්පූර්ණ කුර්ආනය';

  @override
  String get dailyGoalsSectionTitle => 'අද දිනයේ අධ්‍යාත්මික ඉලක්ක';

  @override
  String get noPrayerStreakMessage => 'දැනට සලාත් අඛණ්ඩතාවක් නැත';

  @override
  String prayerStreakLabel(int count) {
    return 'සලාත් අඛණ්ඩතාව: දින $count';
  }

  @override
  String get fastingTodayLabel => 'අද උපවාසය';

  @override
  String get markFastingHint => 'අද උපවාසය ලකුණු කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get unmarkFastingHint =>
      'අද උපවාස ලකුණ ඉවත් කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get noFastingStreakMessage => 'දැනට උපවාස අඛණ්ඩතාවක් නැත';

  @override
  String fastingStreakLabel(int count) {
    return 'උපවාස අඛණ්ඩතාව: දින $count';
  }

  @override
  String markPrayerDoneHint(String label) {
    return '$label සම්පූර්ණයි ලෙස ලකුණු කිරීමට දෙවරක් තට්ටු කරන්න';
  }

  @override
  String unmarkPrayerHint(String label) {
    return '$label ලකුණ ඉවත් කිරීමට දෙවරක් තට්ටු කරන්න';
  }

  @override
  String get locationSetViaGpsLabel => 'ස්ථානය: වත්මන් (GPS)';

  @override
  String get locationSetLabel => 'ස්ථානය සකසා ඇත';

  @override
  String get changeLocationSemanticLabel => 'ස්ථානය වෙනස් කරන්න';

  @override
  String get changeLocationHint =>
      'ස්ථානය සකසන ආකාරය වෙනස් කිරීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get changeLabel => 'වෙනස් කරන්න';

  @override
  String get enterManuallyLabel => 'අතින් ඇතුළත් කරන්න (උසස්)';

  @override
  String get hideManualEntryLabel => 'අතින් ඇතුළත් කිරීම සඟවන්න';

  @override
  String get turnOffNotificationHint => 'නිවීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get turnOnNotificationHint => 'දැල්වීමට දෙවරක් තට්ටු කරන්න';

  @override
  String get setLocationOnPrayerTabMessage =>
      'අද වේලාවන් මෙහි දැකීමට, සලාත් වේලා පටිත්තෙහි ඔබේ ස්ථානය සකසන්න.';

  @override
  String get religiousContentNoteHeader => 'ආගමික අන්තර්ගතය පිළිබඳ සටහනක්';

  @override
  String get religiousContentNoteBody =>
      'මෙම යෙදුමේ ඇති කුර්ආන් පාඨය සහ අස්කාර් සත්‍යාපිත මූලාශ්‍රවලින් ලබාගෙන ඇත — කුර්ආනය සඳහා Tanzil Project සහ අස්කාර් සඳහා හිස්නුල් මුස්ලිම් — එම මූලාශ්‍ර සමඟ ප්‍රවේශමෙන් සසඳා බලා ඇත. එසේ වුවද, අපි මිනිසුන් පමණි, කිසිදු ප්‍රයත්නයක් වැරදිවලින් තොර නොවේ. මෙම අන්තර්ගතය දැනට දේශීය ඉස්ලාමීය විද්වත්භාවය සමඟ සමාලෝචනය කරමින් පවතී — මෙය අඛණ්ඩව සිදුවන ක්‍රියාවලියක් වන අතර නිකුතුවෙන් පසුවද එය දිගටම කරගෙන යනු ඇත. නිවැරදි කළ යුතු කිසිවක් ඔබ දුටුවහොත්, කරුණාකර අප හා සම්බන්ධ වන්න — අපි එය සාදරයෙන් පිළිගනිමු. අපි මෙම කාර්යය කරන්නේ නිහතමානීව වන අතර, නොදැනුවත්වම සිදුවන ඕනෑම වැරැද්දකට අල්ලාහ්ගේ සමාව අයදිමු.';

  @override
  String get religiousContentQuietNote =>
      'මෙම අන්තර්ගතය ප්‍රවේශමෙන් මූලාශ්‍ර කර සසඳා බලා ඇති අතර, අඛණ්ඩ විද්වත් සමාලෝචනයට ලක්ව පවතී. නිවැරදි කළ යුතු දෙයක් හමු වුණාද? කරුණාකර අපට දන්වන්න.';
}
