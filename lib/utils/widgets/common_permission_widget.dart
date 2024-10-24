import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_components/utils/extention/context_extension.dart';
import 'package:local_components/utils/extention/extension.dart';
import 'package:local_components/utils/helper/base_widget.dart';
import 'package:local_components/utils/theme/app_colors.dart';
import 'package:local_components/utils/theme/text_style.dart';
import 'package:local_components/utils/widgets/common_button.dart';
import 'package:local_components/utils/widgets/common_text.dart';
import 'package:lottie/lottie.dart';

class CommonPermissionWidget extends ConsumerWidget with BaseConsumerWidget {
  final Function() onPositiveButtonTap;
  final String requestCameraAndStoragePermissionMsg;
  final String requestPermission;
  final String cameraStorageAnim;

  const CommonPermissionWidget({
    super.key,
    required this.onPositiveButtonTap,
    required this.requestCameraAndStoragePermissionMsg,
    required this.requestPermission,
    required this.cameraStorageAnim,
  });

  @override
  Widget buildPage(BuildContext context, ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          cameraStorageAnim,
          height: context.height * 0.145,
          width: context.width * 0.145,
          fit: BoxFit.scaleDown,
        ).paddingOnly(top: context.height * 0.030),

        ///title
        CommonText(
          title: requestCameraAndStoragePermissionMsg,
          textStyle: TextStyles.medium.copyWith(color: AppColors.black171717, fontSize: 18.sp),
          textAlign: TextAlign.center,
          maxLines: 3,
        ).paddingOnly(bottom: 15.h, left: 40.h, right: 40.h),

        ///Sub title
        CommonText(
          title: requestPermission,
          textStyle: TextStyles.regular.copyWith(color: AppColors.grey828282, fontSize: 14.sp),
          maxLines: 3,
          textAlign: TextAlign.center,
        ).paddingOnly(left: 40.h, right: 40.h, bottom: 30.h),

        ///Bottom Buttons
        Row(
          children: [
            Expanded(
              child: CommonButton(
                  height: 55.h,
                  buttonText: 'Not now',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  buttonEnabledColor: AppColors.lightPinkF7F7FC,
                  buttonTextColor: AppColors.black171717),
            ),
            SizedBox(
              width: 15.w,
            ),
            Expanded(
              child: CommonButton(height: 55.h, buttonText: 'Continue', onTap: onPositiveButtonTap, buttonEnabledColor: AppColors.black171717, buttonTextColor: AppColors.white),
            ),
          ],
        ).paddingSymmetric(horizontal: 15.w, vertical: 15.h)
      ],
    );
  }
}
