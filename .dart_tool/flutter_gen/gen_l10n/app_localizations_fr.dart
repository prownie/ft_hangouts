import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get helloWorld => 'Bonjour monde!';

  @override
  String get newContact => 'Nouveau contact';

  @override
  String get newMessage => 'Nouveau message';

  @override
  String get firstName => 'Prénom';

  @override
  String get firstNameEmpty => 'Le prénom ne peut pas être vide';

  @override
  String get lastName => 'Nom de famille';

  @override
  String get lastNameEmpty => 'Le nom de famille ne peut pas être vide';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get phoneNumberFormat => 'Le numéro de téléphone doit commencer par 0 et contenir 10 chiffres';

  @override
  String get saveChange => 'Sauvegarder modifications';

  @override
  String get deleteContact => 'Supprimer contact';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get updateDone => 'Contact modifié';

  @override
  String get createNewContact => 'Créer nouveau contact';

  @override
  String get createDone => 'Nouveau contact créé';

  @override
  String get createContact => 'Créer contact';

  @override
  String get changeThemeColor => 'Sélectionner la couleur souhaitée pour changer le thème';

  @override
  String get changeLocale => 'Langage';

  @override
  String get phoneLanguage => 'Langage du téléphone';

  @override
  String get addPicture => 'Ajouter photo';
}
