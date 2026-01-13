abstract class Environment {
  static const String appName = 'DailyMotiv';
  static const String version = '1.0.0';
  
  // API Configuration (when you add backend)
  static const String apiBaseUrl = 'https://api.dailymotiv.com/v1';
  static const int apiTimeoutSeconds = 30;
  
  // Feature flags
  static const bool enableGoogleSignIn = false;
  static const bool enableFacebookSignIn = false;
  static const bool enableAnalytics = false;
}

class AppConstants {
  // App settings
  static const Duration splashDuration = Duration(seconds: 2);
  static const int quotesPerPage = 20;
  static const int maxFavoriteQuotes = 1000;
  
  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String favoritesKey = 'favorite_quotes';
  static const String appSettingsKey = 'app_settings';
  
  // API Endpoints (when you add backend)
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String quotesEndpoint = '/quotes';
  static const String categoriesEndpoint = '/categories';
}