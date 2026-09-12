import 'package:flutter/material.dart';

import 'package:travel_app/features/user/user_booking/presentation/pages/my_bookings_page.dart';

/// Kept for home bottom-nav; UI lives in `user_booking`.
class BookingsTab extends StatelessWidget {
  const BookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyBookingsPage();
  }
}
