// ignore_for_file: deprecated_member_use

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:local_components/utils/helper/base_widget.dart';

class CommonSVG extends StatelessWidget with BaseStatelessWidget{
  final String strIcon;
  final ColorFilter? colorFilter;
  final Color? svgColor;
  final double? height;
  final double? width;
  final BoxFit? boxFit;

  const CommonSVG(
      {super.key,
        required this.strIcon,
        this.svgColor,
        this.height,
        this.width,
        this.boxFit,
        this.colorFilter});

  @override
  Widget buildPage(BuildContext context) {
    return SvgPicture.asset(
      strIcon,
      colorFilter: colorFilter,
      color: svgColor,
      height: height,
      width: width,
      fit: boxFit ?? BoxFit.contain,
    );
  }
}
