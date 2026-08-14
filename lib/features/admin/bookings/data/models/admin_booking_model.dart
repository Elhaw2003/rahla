class AdminBokkingResponseModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final AdminBookingDataModel data;
  AdminBokkingResponseModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });
  factory AdminBokkingResponseModel.fromJson(Map<String, dynamic> json) {
    return AdminBokkingResponseModel(
      statusCode: json['statusCode'] ?? 0,
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: AdminBookingDataModel.fromJson(json['data'] ?? {}),
    );
  }
}

class AdminBookingDataModel {
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final List<AdminBookingModel> bookings;
  AdminBookingDataModel({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.bookings,
  });
  factory AdminBookingDataModel.fromJson(Map<String, dynamic> json) {
    return AdminBookingDataModel(
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      bookings:
          (json['bookings'] as List?)
              ?.map(
                (booking) => AdminBookingModel.fromJson(
                  Map<String, dynamic>.from(booking as Map),
                ),
              )
              .toList() ??
          [],
    );
  }
}

class AdminBookingModel {
  final String id;
  final UserModel user;
  final TripModel trip;
  final int numberOfSeats;
  final double totalPrice;
  final TripSnapshotModel tripSnapshot;
  final String status;
  final String notes;
  final String rejectionReason;
  final String cancellationReason;
  final bool isProtected;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final DateTime approvedAt;
  AdminBookingModel({
    required this.id,
    required this.user,
    required this.trip,
    required this.numberOfSeats,
    required this.totalPrice,
    required this.tripSnapshot,
    required this.status,
    required this.notes,
    required this.rejectionReason,
    required this.cancellationReason,
    required this.isProtected,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.approvedAt,
  });
  factory AdminBookingModel.fromJson(Map<String, dynamic> json) {
    final snapshot = TripSnapshotModel.fromJson(
      Map<String, dynamic>.from(json['tripSnapshot'] as Map? ?? {}),
    );
    final tripJson = json['trip'];

    return AdminBookingModel(
      id: json['_id'] ?? '',
      user: json['user'] == null
          ? UserModel(
              id: '',
              fullName: 'مستخدم محذوف',
              email: '',
              phone: '',
              profileImage: '',
            )
          : UserModel.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
      trip: tripJson is Map
          ? TripModel.fromJson(Map<String, dynamic>.from(tripJson))
          : TripModel.fromSnapshot(snapshot),
      numberOfSeats: json['numberOfSeats'] ?? 0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      tripSnapshot: snapshot,
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
      rejectionReason: json['rejectionReason'] ?? '',
      cancellationReason: json['cancellationReason'] ?? '',
      isProtected: json['isProtected'] ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      v: json['__v'] ?? 0,
      approvedAt:
          DateTime.tryParse(json['approvedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String profileImage;
  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.profileImage,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}

class TripModel {
  final String id;
  final String title;
  final String origin;
  final String destination;
  final double price;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String coverImage;
  TripModel({
    required this.id,
    required this.title,
    required this.origin,
    required this.destination,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.coverImage,
  });
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      startDate:
          DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      endDate:
          DateTime.tryParse(json['endDate']?.toString() ?? '') ??
          DateTime.now(),
      status: json['status'] ?? '',
      coverImage: json['coverImage'] ?? '',
    );
  }

  factory TripModel.fromSnapshot(TripSnapshotModel snapshot) {
    return TripModel(
      id: snapshot.id,
      title: snapshot.title,
      origin: snapshot.origin,
      destination: snapshot.destination,
      price: snapshot.pricePerSeat,
      startDate: snapshot.startDate,
      endDate: snapshot.endDate,
      status: '',
      coverImage: snapshot.coverImage,
    );
  }
}

class TripSnapshotModel {
  final String id;
  final String title;
  final String coverImage;
  final String origin;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double pricePerSeat;
  TripSnapshotModel({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.origin,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.pricePerSeat,
  });
  factory TripSnapshotModel.fromJson(Map<String, dynamic> json) {
    return TripSnapshotModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      coverImage: json['coverImage'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      endDate: DateTime.tryParse(json['endDate']?.toString() ?? '') ??
          DateTime.now(),
      pricePerSeat: (json['pricePerSeat'] as num?)?.toDouble() ?? 0,
    );
  }
}

// {
//     "statusCode": 200,
//     "success": true,
//     "code": "BOOKINGS_FETCHED",
//     "message": "Bookings list retrieved successfully.",
//     "data": {
//         "totalItems": 3,
//         "totalPages": 1,
//         "currentPage": 1,
//         "pageSize": 10,
//         "bookings": [
//             {
//                 "_id": "6a746fa3f9f0cda3c928eebc",
//                 "user": {
//                     "_id": "6a746f60f9f0cda3c928ee79",
//                     "fullName": "Developer Permanent User",
//                     "email": "user1@example.com",
//                     "phone": "01099991112",
//                     "profileImage": ""
//                 },
//                 "trip": {
//                     "_id": "6a6ba7cff9f0cda3c928dda8",
//                     "title": "رحله ل حديقه الحيوان",
//                     "origin": "Aswan",
//                     "destination": "Cairo",
//                     "price": 300,
//                     "startDate": "2026-07-29T21:00:00.000Z",
//                     "endDate": "2026-07-30T21:00:00.000Z",
//                     "status": "published",
//                     "coverImage": "/uploads/trips/trip-1785440207105-583135964.jpg"
//                 },
//                 "numberOfSeats": 2,
//                 "totalPrice": 600,
//                 "tripSnapshot": {
//                     "title": "رحله ل حديقه الحيوان",
//                     "coverImage": "/uploads/trips/trip-1785440207105-583135964.jpg",
//                     "origin": "Aswan",
//                     "destination": "Cairo",
//                     "startDate": "2026-07-29T21:00:00.000Z",
//                     "endDate": "2026-07-30T21:00:00.000Z",
//                     "pricePerSeat": 300
//                 },
//                 "status": "approved",
//                 "notes": "Need front seats please",
//                 "rejectionReason": "",
//                 "cancellationReason": "",
//                 "isProtected": true,
//                 "createdAt": "2026-08-06T11:27:31.604Z",
//                 "updatedAt": "2026-08-08T09:30:06.264Z",
//                 "__v": 0,
//                 "approvedAt": "2026-08-08T09:30:06.257Z"
//             },
//             {
//                 "_id": "6a691c80c9f70c7d471b53c5",
//                 "user": null,
//                 "trip": {
//                     "_id": "6a65077cc9f70c7d471b4842",
//                     "title": "عطلة الأنشطة البحرية بالغردقة ورالي الجونة",
//                     "origin": "Cairo",
//                     "destination": "Hurghada",
//                     "price": 5200,
//                     "startDate": "2026-09-20T07:00:00.000Z",
//                     "endDate": "2026-09-24T20:00:00.000Z",
//                     "status": "published",
//                     "coverImage": "/uploads/trips/trip-1785005948191-473498507.jpg"
//                 },
//                 "numberOfSeats": 2,
//                 "totalPrice": 10400,
//                 "tripSnapshot": {
//                     "title": "عطلة الأنشطة البحرية بالغردقة ورالي الجونة",
//                     "coverImage": "/uploads/trips/trip-1785005948191-473498507.jpg",
//                     "origin": "Cairo",
//                     "destination": "Hurghada",
//                     "startDate": "2026-09-20T07:00:00.000Z",
//                     "endDate": "2026-09-24T20:00:00.000Z",
//                     "pricePerSeat": 5200
//                 },
//                 "status": "approved",
//                 "notes": "Need front seats please",
//                 "rejectionReason": "",
//                 "cancellationReason": "",
//                 "isProtected": true,
//                 "createdAt": "2026-07-28T21:17:52.335Z",
//                 "updatedAt": "2026-07-28T21:18:58.595Z",
//                 "__v": 0,
//                 "approvedAt": "2026-07-28T21:18:58.594Z"
//             },
//             {
//                 "_id": "6a691a99c9f70c7d471b53ae",
//                 "user": null,
//                 "trip": {
//                     "_id": "6a65077cc9f70c7d471b4842",
//                     "title": "عطلة الأنشطة البحرية بالغردقة ورالي الجونة",
//                     "origin": "Cairo",
//                     "destination": "Hurghada",
//                     "price": 5200,
//                     "startDate": "2026-09-20T07:00:00.000Z",
//                     "endDate": "2026-09-24T20:00:00.000Z",
//                     "status": "published",
//                     "coverImage": "/uploads/trips/trip-1785005948191-473498507.jpg"
//                 },
//                 "numberOfSeats": 2,
//                 "totalPrice": 10400,
//                 "tripSnapshot": {
//                     "title": "عطلة الأنشطة البحرية بالغردقة ورالي الجونة",
//                     "coverImage": "/uploads/trips/trip-1785005948191-473498507.jpg",
//                     "origin": "Cairo",
//                     "destination": "Hurghada",
//                     "startDate": "2026-09-20T07:00:00.000Z",
//                     "endDate": "2026-09-24T20:00:00.000Z",
//                     "pricePerSeat": 5200
//                 },
//                 "status": "approved",
//                 "notes": "Need front seats please",
//                 "rejectionReason": "",
//                 "cancellationReason": "",
//                 "isProtected": true,
//                 "createdAt": "2026-07-28T21:09:45.754Z",
//                 "updatedAt": "2026-07-29T11:02:29.833Z",
//                 "__v": 0,
//                 "approvedAt": "2026-07-29T11:02:29.832Z"
//             }
//         ]
//     }
// }
