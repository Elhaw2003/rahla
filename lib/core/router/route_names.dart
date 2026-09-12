class RouteNames {
  RouteNames._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String tripDetails = '/trip-details';
  static const String favorites = '/favorites';
  static const String bookingConfirmation = '/booking-confirmation';
  static const String bookingDetails = '/booking-details/:bookingId';

  static String bookingDetailsPath(String bookingId) =>
      '/booking-details/$bookingId';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String adminDashboard = '/admin-dashboard';
  static const String adminTrips = '/admin-trips';
  static const String adminBookings = '/admin-bookings';
  static const String adminBookingDetails = '/admin-booking-details';
  static const String addTrip = '/add-trip';
  static const String notFound = '/not-found';
}
