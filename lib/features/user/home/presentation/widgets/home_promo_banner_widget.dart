import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/home/data/models/offer_model.dart';

class HomePromoBannerWidget extends StatelessWidget {
  final OfferModel? offer;

  const HomePromoBannerWidget({super.key, this.offer});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final title = locale == 'ar'
        ? (offer?.titleAr?.isNotEmpty == true
              ? offer!.titleAr!
              : AppStrings.homeDiscountBanner)
        : (offer?.titleEn?.isNotEmpty == true
              ? offer!.titleEn!
              : AppStrings.homeDiscountBanner);
    final subtitle = locale == 'ar'
        ? (offer?.descriptionAr?.isNotEmpty == true
              ? offer!.descriptionAr!
              : AppStrings.homeDiscountSubtitle)
        : (offer?.descriptionEn?.isNotEmpty == true
              ? offer!.descriptionEn!
              : AppStrings.homeDiscountSubtitle);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      padding: EdgeInsets.all(AppSizes.p16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSizes.p4.verticalSpace,
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
              ),
              if (offer?.promoCode?.isNotEmpty == true) ...[
                AppSizes.p8.verticalSpace,
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: offer!.promoCode!));
                    AppSnackbar.showInfo(
                      context: context,
                      message: AppStrings.copied(offer!.promoCode!),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 32.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.disabled,
                      borderRadius: BorderRadius.circular(AppSizes.r4),
                    ),
                    padding: EdgeInsets.all(AppSizes.p8),
                    child: Text(
                      offer!.promoCode!,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              AppSizes.p12.verticalSpace,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryDark,
                  minimumSize: Size(0, 32.h),
                ),
                onPressed: () {},
                child: Text(
                  AppStrings.bookNow,
                  style: AppTextStyles.labelMedium,
                ),
              ),
            ],
          ).expanded(),
          if (offer?.discountPercentage != null &&
              offer!.discountPercentage > 0)
            Text(
              '${offer!.discountPercentage.toInt()}%',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.secondary.withValues(alpha: 0.35),
                fontWeight: FontWeight.bold,
              ),
            )
          else
            Icon(
              Icons.discount,
              color: AppColors.secondary.withValues(alpha: 0.2),
              size: 48.sp,
            ),
        ],
      ),
    ).paddingSymmetric(horizontal: AppSizes.p16);
  }
}
