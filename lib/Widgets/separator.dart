import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Separator extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Stack(
        children: [
          Container(height: 2,
            color: HexColor('#D7DDE8'),
          alignment: Alignment.center,),
          Center(
            child: Container(width: 20,
              color: Colors.white,
              child: Text('or',
              style: TextStyle(
                color: HexColor('#D7DDE8')
              ),),
              alignment: Alignment.center,
            ),
          )
        ],
        alignment: Alignment.center,
      )
    );
  }

}