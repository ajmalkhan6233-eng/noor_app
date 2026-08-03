// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../data/app_settings.dart';

class SettingsState extends Equatable {
  const SettingsState({this.settings = const AppSettings(), this.isLoading = true});

  final AppSettings settings;
  final bool isLoading;

  SettingsState copyWith({AppSettings? settings, bool? isLoading}) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [settings, isLoading];
}
