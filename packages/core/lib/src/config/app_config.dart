abstract class AppConfig {
  static late AppConfig instance;

  String get baseUrl;
  Environment get environment;
  String get googleWebClientId => '';
}

enum Environment {
  dev,
  staging,
  prod;

  factory Environment.fromString(String value) {
    return switch (value) {
      'staging' => Environment.staging,
      'prod' => Environment.prod,
      _ => Environment.dev,
    };
  }
}
