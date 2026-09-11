enum Environment { dev, staging, prod }

class AppConfig {
  AppConfig._();

  static Environment environment = Environment.dev;

  static String get baseUrl {
    switch (environment) {
      case Environment.dev:
        return 'http://localhost:8080/api/v1';
      case Environment.staging:
        return 'https://staging.arogya.com/api';
      case Environment.prod:
        return 'https://api.arogya.com/api';
    }
  }

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}