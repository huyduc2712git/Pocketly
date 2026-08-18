enum Environment { dev, staging, prod }

class EnvConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableDebugBanner;

  const EnvConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.enableLogging = true,
    this.enableDebugBanner = false,
  });

  static const EnvConfig dev = EnvConfig(
    environment: Environment.dev,
    apiBaseUrl: 'https://dev-api.finly.app/v1',
    enableLogging: true,
    enableDebugBanner: true,
  );

  static const EnvConfig staging = EnvConfig(
    environment: Environment.staging,
    apiBaseUrl: 'https://staging-api.finly.app/v1',
    enableLogging: true,
    enableDebugBanner: false,
  );

  static const EnvConfig prod = EnvConfig(
    environment: Environment.prod,
    apiBaseUrl: 'https://api.finly.app/v1',
    enableLogging: false,
    enableDebugBanner: false,
  );
}

class AppConfig {
  static late EnvConfig _current;

  static void initialize({EnvConfig env = EnvConfig.dev}) {
    _current = env;
  }

  static EnvConfig get current => _current;
  static bool get isDev => _current.environment == Environment.dev;
  static bool get isProd => _current.environment == Environment.prod;
}
