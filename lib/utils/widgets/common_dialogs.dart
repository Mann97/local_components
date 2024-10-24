import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_components/utils/theme/app_colors.dart';

/// Widget Dialog
showWidgetDialog(BuildContext context, Widget? widget, Function()? didDismiss, {bool isDismissDialog = false, int autoDismissTimer = 0}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.grey.withOpacity(0.3),
      builder: (context) => Dialog(
        surfaceTintColor:AppColors.transparent ,
        backgroundColor: AppColors.white,
        insetPadding: EdgeInsets.all(25.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ScreenUtil().setWidth(20.r),
          ),
        ),
        child: Wrap(
          children: [
            widget!,
          ],
        ),
      ));

  if (autoDismissTimer > 0) {
    Future.delayed(Duration(seconds: autoDismissTimer), () {
      if (didDismiss != null) {
        didDismiss();
      }
    });
  } else {
    if (isDismissDialog) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        didDismiss!();
      });
    }
  }
}