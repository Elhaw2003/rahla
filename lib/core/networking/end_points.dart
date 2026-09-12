class EndPoints {
  EndPoints._();

  static const String baseUrl = "https://rahala.duckdns.org/api/v1/";
  static const String auth = "auth/";
  static const String login = "${auth}login";
  static const String register = "${auth}register";
  static const String googleLogin = "${auth}google";
  static const String refreshToken = "${auth}refresh-token";
  static const String adminStats = "admin/stats";
  static const String adminTrips = "trips/admin/all";
  static const String categories = "categories";
  static const String addTrip = "trips";
  static const String adminBookings = "bookings";
  static String approveBooking(String bookingId) =>
      "$adminBookings/$bookingId/approve";
  static String rejectBooking(String bookingId) =>
      "$adminBookings/$bookingId/reject";
  static const String getTrips = "trips";
  static const String getActiveOffer = "offers";
  static const String getFavorites = "favorites";
  static String toggleFavorite(String tripId) => "$getFavorites/toggle/$tripId";
}
