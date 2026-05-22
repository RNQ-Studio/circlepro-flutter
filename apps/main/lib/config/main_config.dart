import 'package:core/core.dart';

class MainConfig extends AppConfig {
  @override
  Environment get environment => Environment.fromString(
        const String.fromEnvironment('ENV', defaultValue: 'dev'),
      );

  @override
  String get baseUrl => switch (environment) {
        Environment.dev => 'https://api-dev.example.com',
        Environment.staging => 'https://api-staging.example.com',
        Environment.prod => 'https://api.example.com',
      };
}
