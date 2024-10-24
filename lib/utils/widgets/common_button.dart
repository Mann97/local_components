import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:local_components/utils/helper/base_widget.dart';
import 'package:local_components/utils/theme/app_colors.dart';
import 'package:local_components/utils/theme/text_style.dart';
import 'package:local_components/utils/widgets/common_svg.dart';

class CommonButton extends StatefulWidget {
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final String? leftImage;
  final double? leftImageHeight;
  final double? leftImageWidth;
  final double? leftImageHorizontalPadding;
  final Widget? rightIcon;
  final Widget? leftIcon;
  final String? rightImage;
  final double? rightImageHeight;
  final double? rightImageWidth;
  final double? rightImageHorizontalPadding;
  final String? buttonText;
  final int? buttonMaxLine;
  final TextStyle? buttonTextStyle;
  final double? buttonHorizontalPadding;
  final bool isButtonEnabled;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onValidateTap;
  final TextAlign? buttonTextAlignment;
  final Color? buttonTextColor;
  final Color? buttonEnabledColor;
  final Color? buttonDisabledColor;
  final double? buttonTextSize;
  final bool? isLoading;
  final Color? loadingAnimationColor;

  const CommonButton({
    super.key,
    this.height,
    this.width,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.leftImage,
    this.leftImageHeight,
    this.leftImageWidth,
    this.leftImageHorizontalPadding,
    this.rightImage,
    this.rightImageHeight,
    this.rightImageWidth,
    this.rightImageHorizontalPadding,
    this.buttonText,
    this.buttonMaxLine,
    this.buttonTextStyle,
    this.buttonHorizontalPadding,
    this.onTap,
    this.buttonTextAlignment,
    this.buttonTextColor,
    this.isButtonEnabled = false,
    this.buttonEnabledColor,
    this.buttonDisabledColor,
    this.buttonTextSize,
    this.rightIcon,
    this.isLoading,
    this.loadingAnimationColor,
    this.onValidateTap,
    this.leftIcon,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> with BaseStatefulWidget {
  @override
  Widget buildPage(BuildContext context) {
    Color buttonColor = widget.isButtonEnabled ? (widget.buttonEnabledColor ?? widget.backgroundColor ?? AppColors.clr009AF1) : (widget.buttonDisabledColor ?? AppColors.clrF7F7FC);
    return /*(widget.isLoading ?? false) ? shimmerLoader() : */ InkWell(
      onTap: () {
        if (widget.isButtonEnabled && !(widget.isLoading ?? false)) {
          widget.onTap?.call();
        } else if (!(widget.isLoading ?? false)) {
          widget.onValidateTap?.call();
        }
      },
      child: AbsorbPointer(
        absorbing: widget.isLoading ?? false,
        child: Container(
          height: widget.height ?? 82.h,
          width: widget.width ?? 233.w,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(40.r),
            border: Border.all(color: widget.borderColor ?? Colors.transparent, width: widget.borderWidth ?? 0),
          ),
          child: (widget.isLoading ?? false)
              ? Center(
                  child: LoadingAnimationWidget.waveDots(
                    color: widget.loadingAnimationColor ?? Colors.white,
                    size: widget.height ?? 48.h,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if ((widget.leftImage ?? '').isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widget.leftImageHorizontalPadding ?? 12.w),
                        child: Image.asset(
                          widget.leftImage!,
                          height: widget.leftImageHeight,
                          width: widget.leftImageWidth,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widget.buttonHorizontalPadding ?? 0),
                      child: Row(
                        children: [
                          if ((widget.leftIcon != null && widget.leftImage == null)) widget.leftIcon ?? const Offstage(),
                          Text(
                            widget.buttonText ?? '',
                            textAlign: widget.buttonTextAlignment ?? TextAlign.center,
                            maxLines: widget.buttonMaxLine ?? 1,
                            style: widget.buttonTextStyle ??
                                TextStyles.regular.copyWith(
                                    fontSize: widget.buttonTextSize ?? 22.sp, color: widget.buttonTextColor ?? (widget.isButtonEnabled ? AppColors.white : AppColors.grey7D7D7D)),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          if ((widget.rightIcon != null && widget.rightImage == null)) widget.rightIcon ?? const Offstage()
                        ],
                      ),
                    ),
                    if ((widget.rightImage ?? '').isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widget.rightImageHorizontalPadding ?? 12.w),
                        child: widget.rightImage!.contains('.svg')
                            ? CommonSVG(
                                strIcon: widget.rightImage!,
                                height: widget.rightImageHeight,
                                width: widget.rightImageWidth,
                              )
                            : Image.asset(
                                widget.rightImage!,
                                height: widget.rightImageHeight,
                                width: widget.rightImageWidth,
                              ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

/*
Widget Usage
CommonButton(
          buttonText: "Login",
          onTap: () {

          },
        )
* */

/*
Widget Usage
CommonButton(
          buttonText: "Login",
          onTap: () {

          },
        )
* */
