import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomNavigationBarItem extends StatelessWidget {
  const CustomNavigationBarItem({
    Key? key,
    required this.image,
    required this.isSelected,
    required this.onTap,
    required this.label,
  }) : super(key: key);

  final bool isSelected;
  final VoidCallback onTap;
  final String label;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: (InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          color: isSelected
              ? HexColor('#F1F3FD')
              : Colors.transparent,
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage(image)),
              SizedBox(width: 5,),
              Text("$label", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: HexColor('#596EFB')),),
            ],
          ),
        ),
      )),
    );
  }
}