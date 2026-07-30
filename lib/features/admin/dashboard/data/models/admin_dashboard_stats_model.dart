class AdminDashboardStatsModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final AdminStatsData? data;

  AdminDashboardStatsModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory AdminDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardStatsModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? null
          : AdminStatsData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            ),
    );
  }
}

class AdminStatsData {
  final AdminStatsUsers? users;
  final AdminStatsTrips? trips;
  final AdminStatsBookings? bookings;
  final AdminStatsFinancials? financials;
  final List<AdminStatsTopTrip> topTrips;

  AdminStatsData({
    this.users,
    this.trips,
    this.bookings,
    this.financials,
    this.topTrips = const [],
  });

  factory AdminStatsData.fromJson(Map<String, dynamic> json) {
    return AdminStatsData(
      users: json['users'] == null
          ? null
          : AdminStatsUsers.fromJson(
              Map<String, dynamic>.from(json['users'] as Map),
            ),
      trips: json['trips'] == null
          ? null
          : AdminStatsTrips.fromJson(
              Map<String, dynamic>.from(json['trips'] as Map),
            ),
      bookings: json['bookings'] == null
          ? null
          : AdminStatsBookings.fromJson(
              Map<String, dynamic>.from(json['bookings'] as Map),
            ),
      financials: json['financials'] == null
          ? null
          : AdminStatsFinancials.fromJson(
              Map<String, dynamic>.from(json['financials'] as Map),
            ),
      topTrips:
          (json['topTrips'] as List?)
              ?.map(
                (item) => AdminStatsTopTrip.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }
}

class AdminStatsUsers {
  final int totalUsers;
  final int totalAdmins;

  AdminStatsUsers({this.totalUsers = 0, this.totalAdmins = 0});

  factory AdminStatsUsers.fromJson(Map<String, dynamic> json) {
    return AdminStatsUsers(
      totalUsers: json['totalUsers'] as int? ?? 0,
      totalAdmins: json['totalAdmins'] as int? ?? 0,
    );
  }
}

class AdminStatsTrips {
  final int publishedTrips;
  final int draftTrips;
  final int deletedTrips;
  final int totalActiveTrips;

  AdminStatsTrips({
    this.publishedTrips = 0,
    this.draftTrips = 0,
    this.deletedTrips = 0,
    this.totalActiveTrips = 0,
  });

  factory AdminStatsTrips.fromJson(Map<String, dynamic> json) {
    return AdminStatsTrips(
      publishedTrips: json['publishedTrips'] as int? ?? 0,
      draftTrips: json['draftTrips'] as int? ?? 0,
      deletedTrips: json['deletedTrips'] as int? ?? 0,
      totalActiveTrips: json['totalActiveTrips'] as int? ?? 0,
    );
  }
}

class AdminStatsBookings {
  final int totalBookings;
  final int pendingBookings;
  final int approvedBookings;
  final int rejectedBookings;
  final int cancelledBookings;

  AdminStatsBookings({
    this.totalBookings = 0,
    this.pendingBookings = 0,
    this.approvedBookings = 0,
    this.rejectedBookings = 0,
    this.cancelledBookings = 0,
  });

  factory AdminStatsBookings.fromJson(Map<String, dynamic> json) {
    return AdminStatsBookings(
      totalBookings: json['totalBookings'] as int? ?? 0,
      pendingBookings: json['pendingBookings'] as int? ?? 0,
      approvedBookings: json['approvedBookings'] as int? ?? 0,
      rejectedBookings: json['rejectedBookings'] as int? ?? 0,
      cancelledBookings: json['cancelledBookings'] as int? ?? 0,
    );
  }
}

class AdminStatsFinancials {
  final num totalRevenue;

  AdminStatsFinancials({this.totalRevenue = 0});

  factory AdminStatsFinancials.fromJson(Map<String, dynamic> json) {
    return AdminStatsFinancials(
      totalRevenue: json['totalRevenue'] as num? ?? 0,
    );
  }
}

class AdminStatsTopTrip {
  final int bookingCount;
  final int totalSeatsBooked;
  final String? id;
  final String? title;
  final String? destination;
  final num price;
  final String? coverImage;

  AdminStatsTopTrip({
    this.bookingCount = 0,
    this.totalSeatsBooked = 0,
    this.id,
    this.title,
    this.destination,
    this.price = 0,
    this.coverImage,
  });

  factory AdminStatsTopTrip.fromJson(Map<String, dynamic> json) {
    return AdminStatsTopTrip(
      bookingCount: json['bookingCount'] as int? ?? 0,
      totalSeatsBooked: json['totalSeatsBooked'] as int? ?? 0,
      id: json['_id'] as String?,
      title: json['title'] as String?,
      destination: json['destination'] as String?,
      price: json['price'] as num? ?? 0,
      coverImage: json['coverImage'] as String?,
    );
  }
}
