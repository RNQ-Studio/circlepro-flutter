import 'package:core/core.dart';

class MainConfig extends AppConfig {
  @override
  Environment get environment => Environment.fromString(
        const String.fromEnvironment('ENV', defaultValue: 'dev'),
      );

  // Note: the `/api/` suffix is required — the Laravel API is served under
  // `/api/v1/...` and Dio request paths are relative (`v1/...`).
  @override
  String get baseUrl => switch (environment) {
        Environment.dev => 'https://circlepro.web.id/api/',
        Environment.staging => 'https://circlepro.web.id/api/',
        Environment.prod => 'https://circlepro.web.id/api/',
      };

  @override
  String get googleWebClientId =>
      '925566560744-qee086bdptv1jm964ghs0phgjsmo0ljf.apps.googleusercontent.com';
}
