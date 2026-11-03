// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String hello(String name) {
    return 'ನಮಸ್ಕಾರ, $name';
  }

  @override
  String get language => 'ಭಾಷೆ';

  @override
  String get newGrievanceRegistration => 'ಹೊಸ ಅಹವಾಲು ನೋಂದಣಿ';

  @override
  String get fileNewComplaint => 'ಹೊಸ ದೂರು ಸಲ್ಲಿಸಿ';

  @override
  String get grievanceStatus => 'ಅಹವಾಲಿನ ಸ್ಥಿತಿ';

  @override
  String get viewAll => 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ';

  @override
  String get registeredForScrutiny =>
      'ನೋಂದಾಯಿಸಲಾಗಿದೆ ಮತ್ತು ಪರಿಶೀಲನೆಗೆ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get inProgress => 'ಪ್ರಗತಿಯಲ್ಲಿದೆ';

  @override
  String get closed => 'ಮುಚ್ಚಲಾಗಿದೆ';

  @override
  String get resolved => 'ಪರಿಹರಿಸಲಾಗಿದೆ';
}
