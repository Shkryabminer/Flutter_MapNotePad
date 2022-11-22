
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:map_note_pad/Models/pin/pin.dart';
import 'package:map_note_pad/Presentation/main_screen/bloc/events.dart';
import 'package:map_note_pad/Presentation/main_screen/bloc/main_screen_bloc.dart';

class PinCell extends StatefulWidget
{
  static const int precision = 8;
  final Pin pin;
  final Function()? callback;

  const PinCell(
       this.pin,
      {this.callback,Key? key}) : super(key: key);

  @override
  _PinCellState createState()=> _PinCellState();
}

class _PinCellState extends State<PinCell>
{
  @override
  Widget build(BuildContext context) {
    return Column(
      children:[ Container(height: 75,
          alignment: Alignment.center,
          child: Row(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                child: InkWell(
                  child:Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all( Radius.circular(5)),
                    color: HexColor('#F1F3FD')),

                    child: Image(image: AssetImage(_getImage(widget.pin.isFavorite)),
                    height: 40,width: 40),
                  ),
                onTap: (){
                  var bloc = BlocProvider.of<MainScreenBloc>(context);
                  widget.pin.isFavorite = !widget.pin.isFavorite;
                  bloc.add(UpdatePinEvent(widget.pin));
                setState(() {

                });},),
              ),
              Expanded(child: _buildTapArea()),
            ],

          ),

      ),
      Padding(padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
          child: Container(height: 1,color: HexColor('#F1F3FD'),))]
    );

  }

  String _getImage(bool isFavorite) {
    return isFavorite ? 'assets/ic_like_blue.png' : 'assets/ic_like_grey.png';
  }

  Widget _buildTapArea()
  {
    return InkWell(onTap: (){
                              widget.callback?.call();},
                    child:Row(
                          mainAxisSize: MainAxisSize.max,
                          children:[
                            _buildInfoPart(),
                            Spacer(),
                            Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                child: Image(image: AssetImage('assets/ic_arrow_left_grey.png'),))]
            )


    );
  }

 Widget _buildInfoPart() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(widget.pin.label,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: HexColor('#1E242B')),),
      SizedBox(height: 2,),
      Row(
          children: [Text(widget.pin.longitude.toStringAsPrecision(PinCell.precision),
           style:TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: HexColor('#3D4E61')),),
            SizedBox(width: 6,),
            Text(widget.pin.latitude.toStringAsPrecision(PinCell.precision),
              style:TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: HexColor('#3D4E61')),),
          ],
      )],
    );
  }

}