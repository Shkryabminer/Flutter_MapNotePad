import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:map_note_pad/Models/event/event.dart';
import 'package:map_note_pad/Presentation/main_screen/bloc/main_screen_bloc.dart';

class EventCell extends StatefulWidget
{
  static const int precision = 8;
  final Event event;
  final Function()? callback;

  const EventCell(
      this.event,
      {this.callback,Key? key}) : super(key: key);

  @override
  _EventCellState createState()=> _EventCellState();
}

class _EventCellState extends State<EventCell>
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
        child:Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              children:[
                _buildInfoPart(),
                const Spacer(),
                Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Image(image: AssetImage('assets/ic_arrow_left_grey.png'),))]
          ),
        )
    );
  }

  Widget _buildInfoPart() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(widget.event.label,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: HexColor('#1E242B'), fontFamily: 'Montserrat',
        fontStyle: FontStyle.normal, ),),
        const SizedBox(height: 5),
        Text(widget.event.date,
            style:TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: HexColor('#3D4E61'),fontFamily: 'Montserrat'),),
            ],
        );
  }

}