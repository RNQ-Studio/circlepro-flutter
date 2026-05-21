import 'package:core/core.dart';

class VariantConfig extends AppConfig {
  @override
  Environment get environment => Environment.fromString(
        const String.fromEnvironment('ENV', defaultValue: 'dev'),
      );

  @override
  String get baseUrl => switch (environment) {
        Environment.dev => 'https://variant-api-dev.example.com',
        Environment.staging => 'https://variant-api-staging.example.com',
        Environment.prod => 'https://variant-api.example.com',
      };
}
