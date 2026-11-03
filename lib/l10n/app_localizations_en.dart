// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String hello(String name) {
    return 'Hello, $name';
  }

  @override
  String get language => 'Language';

  @override
  String get newGrievanceRegistration => 'New Grievance Registration';

  @override
  String get fileNewComplaint => 'File a new complaint';

  @override
  String get grievanceStatus => 'Grievance Status';

  @override
  String get viewAll => 'View All';

  @override
  String get registeredForScrutiny => 'Registered and sent for Scrutiny';

  @override
  String get inProgress => 'In Progress';

  @override
  String get closed => 'Closed';

  @override
  String get resolved => 'Resolved';
}
