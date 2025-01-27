// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Cow Control`
  String get app_title {
    return Intl.message(
      'Cow Control',
      name: 'app_title',
      desc: '',
      args: [],
    );
  }

  /// `Pregnant`
  String get pregnant {
    return Intl.message(
      'Pregnant',
      name: 'pregnant',
      desc: '',
      args: [],
    );
  }

  /// `Non-pregnant`
  String get non_pregnant {
    return Intl.message(
      'Non-pregnant',
      name: 'non_pregnant',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Add Cow`
  String get add_cow {
    return Intl.message(
      'Add Cow',
      name: 'add_cow',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get change_language {
    return Intl.message(
      'Change Language',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }

  /// `Pregnancy Date`
  String get pregnancy_date {
    return Intl.message(
      'Pregnancy Date',
      name: 'pregnancy_date',
      desc: '',
      args: [],
    );
  }

  /// `Add Cow Page`
  String get add_cow_page_title {
    return Intl.message(
      'Add Cow Page',
      name: 'add_cow_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Cow Name`
  String get cow_name {
    return Intl.message(
      'Cow Name',
      name: 'cow_name',
      desc: '',
      args: [],
    );
  }

  /// `Is Pregnant?`
  String get is_pregnant {
    return Intl.message(
      'Is Pregnant?',
      name: 'is_pregnant',
      desc: '',
      args: [],
    );
  }

  /// `Add Cow Button`
  String get add_cow_button {
    return Intl.message(
      'Add Cow',
      name: 'add_cow_button',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
