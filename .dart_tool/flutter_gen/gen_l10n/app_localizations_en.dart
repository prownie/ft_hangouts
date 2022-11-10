import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get newContact => 'New contact';

  @override
  String get newMessage => 'New message';

  @override
  String get firstName => 'First Name';

  @override
  String get firstNameEmpty => 'First name can\'t be empty';

  @override
  String get lastName => 'Last Name';

  @override
  String get lastNameEmpty => 'Last name can\'t be empty';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberFormat => 'Bad phone number format. Must start with 0, followed by 9 digits';

  @override
  String get saveChange => 'Save Changes';

  @override
  String get deleteContact => 'Delete contact';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get updateDone => 'Contact updated';

  @override
  String get createNewContact => 'Create new contact';

  @override
  String get createDone => 'New contact created';

  @override
  String get createContact => 'Create contact';

  @override
  String get changeThemeColor => 'Select a color to change theme';

  @override
  String get changeLocale => 'Language';

  @override
  String get phoneLanguage => 'Phone Language';

  @override
  String get addPicture => 'Add picture';

  @override
  String get appHasBeenPaused => 'App has been paused at: ';

  @override
  String get contactAlreadyExists => 'This phone number is already used';

  @override
  String get selectContact => 'Select the contact you want to chat with';
}
