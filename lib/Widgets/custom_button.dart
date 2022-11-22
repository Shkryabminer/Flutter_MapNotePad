
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color? color;
  final Color outlineColor;
  final Widget? child;
  final bool? isActive;
  final bool? isOutlined;
  final Function? onTap;
  final EdgeInsets margin;
  final EdgeInsets? padding;
  final double? width;
  final double height;
  final double borderRadius;

  const CustomButton({
    this.child,
    this.onTap,
    this.color,
    this.width,
    this.outlineColor = Colors.white,
    this.height = 44.0,
    this.isActive = true,
    this.isOutlined = false,
    this.margin = EdgeInsets.zero,
    this.borderRadius = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap:  onTap as void Function(),
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: margin,
          child: Ink(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              color: _getColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: isOutlined! ? outlineColor : Colors.transparent,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Color? get _getColor {
    if (!isActive!) return Colors.blue;
    if (isOutlined!) return Colors.transparent;
    return color;
  }

}