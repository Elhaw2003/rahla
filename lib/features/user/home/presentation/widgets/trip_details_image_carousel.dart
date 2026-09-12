import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_assets.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';

class TripDetailsImageCarousel extends StatefulWidget {
  final List<String> images;
  final double height;
  final bool showGradient;

  const TripDetailsImageCarousel({
    super.key,
    required this.images,
    required this.height,
    this.showGradient = true,
  });

  @override
  State<TripDetailsImageCarousel> createState() =>
      _TripDetailsImageCarouselState();
}

class _TripDetailsImageCarouselState extends State<TripDetailsImageCarousel> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  String _imageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'https://rahala.duckdns.org$path';
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;

    if (images.isEmpty) {
      return Image.asset(
        AppAssets.homeFeatured,
        height: widget.height,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            final url = _imageUrl(images[index]);
            if (url.isEmpty) {
              return Image.asset(AppAssets.homeFeatured, fit: BoxFit.cover);
            }
            return AppNetworkImage(
              imageUrl: url,
              width: double.infinity,
              height: widget.height,
              fit: BoxFit.cover,
            );
          },
          options: CarouselOptions(
            height: widget.height,
            viewportFraction: 1,
            enableInfiniteScroll: images.length > 1,
            autoPlay: false,
          ),
        ),
        if (widget.showGradient)
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        if (images.length > 1) ...[
          Positioned(
            left: AppSizes.p12,
            top: 0,
            bottom: 0,
            child: Center(
              child: _GalleryArrowButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => _carouselController.previousPage(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                ),
              ),
            ),
          ),
          Positioned(
            right: AppSizes.p12,
            top: 0,
            bottom: 0,
            child: Center(
              child: _GalleryArrowButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => _carouselController.nextPage(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _GalleryArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GalleryArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40.w,
          height: 40.w,
          child: Icon(icon, color: Colors.white, size: 28.sp),
        ),
      ),
    );
  }
}
