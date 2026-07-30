class EndPoints {
  EndPoints._();

  static const String baseUrl = "https://rahala.duckdns.org/api/v1/";
  static const String auth = "auth/";
  static const String login = "${auth}login";
  static const String refreshToken = "${auth}refresh-token";
  static const String adminStats = "admin/stats";
}
