import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:local_components/utils/extention/context_extension.dart';
import 'package:local_components/utils/extention/extension.dart';
import 'package:local_components/utils/helper/base_widget.dart';
import 'package:local_components/utils/theme/app_colors.dart';
import 'package:local_components/utils/theme/text_style.dart';

class ImageCropperDialog extends StatefulWidget {
  final Future<String?> Function() crop;
  final Widget cropper;
  final void Function(RotationAngle) rotate;
  final BuildContext mainContext;
  final String title;

  const ImageCropperDialog({super.key, required this.crop, required this.cropper, required this.rotate, required this.mainContext,required this.title});

  @override
  State<ImageCropperDialog> createState() => _ImageCropperDialogState();
}

class _ImageCropperDialogState extends State<ImageCropperDialog> with WidgetsBindingObserver,BaseStatefulWidget {
  bool sizeChanged = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    // if (sizeChanged == false) {
    //   Navigator.pop(widget.mainContext);
    //   sizeChanged = true;
    // }
    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return Container(
      height: context.height * 0.75,
      color: AppColors.white,
      constraints: const BoxConstraints(maxWidth: 500),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel, color: AppColors.red)),
                Expanded(
                  child: Text(
                    widget.title,
                    textScaleFactor: 1,
                    style: TextStyles.semiBold.copyWith(fontSize: 15.sp, color: AppColors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      widget.crop().then((result) {
                        Navigator.of(context).pop(result);
                      });
                    },
                    icon: const Icon(Icons.done_all_sharp, color: AppColors.green))
              ],
            ).paddingSymmetric(horizontal: 5.w, vertical: 10.h),
            SizedBox(
              height: context.height * 0.6,
              child: widget.cropper,
            ),
            context.height > 700
                ? Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            widget.rotate.call(RotationAngle.counterClockwise90);
                          },
                          icon: const Icon(Icons.rotate_90_degrees_ccw_sharp, color: AppColors.black)),
                      const Expanded(child: SizedBox()),
                      IconButton(
                          onPressed: () {
                            widget.rotate.call(RotationAngle.clockwise90);
                          },
                          icon: const Icon(Icons.rotate_90_degrees_cw_outlined, color: AppColors.black)),
                    ],
                  ).paddingSymmetric(horizontal: 15.w)
                : const Offstage(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
