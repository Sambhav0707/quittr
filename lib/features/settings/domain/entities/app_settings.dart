import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool isDarkMode;
  final bool enableNotifications;
  final String language;

  const AppSettings({
    this.isDarkMode = false,
    this.enableNotifications = true,
    this.language = 'en',
  });

  AppSettings copyWith({
    bool? isDarkMode,
    bool? enableNotifications,
    String? language,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, enableNotifications, language];
}
