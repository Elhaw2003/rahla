import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travel_app/core/constants/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const AppShimmer({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8ECF1),
      highlightColor: AppColors.disabled.withValues(alpha: 0.55),
      period: const Duration(milliseconds: 1400),
      direction: ShimmerDirection.ltr,
      child: child,
    );
  }
}

class AppShimmerBone extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;

  const AppShimmerBone({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.shape = BoxShape.rectangle,
  });

  const AppShimmerBone.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = 0,
      shape = BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderRadius),
      ),
    );
  }
}
