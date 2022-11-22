

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:map_note_pad/Models/event/event.dart';
import 'package:map_note_pad/Models/pin/pin.dart';
import 'package:map_note_pad/Presentation/edit_event_screen/edit_event_screen.dart';
import 'package:map_note_pad/Presentation/edit_pin_screen/edit_pin_screen.dart';
import 'package:map_note_pad/Presentation/main_screen/bloc/events.dart';
import 'package:map_note_pad/Presentation/main_screen/bloc/main_screen_bloc.dart';
import 'package:map_note_pad/Presentation/main_screen/bloc/main_screen_state.dart';
import 'package:map_note_pad/Presentation/main_screen/main_screen.dart';
import 'package:map_note_pad/Presentation/main_screen/pins/bloc/events.dart';
import 'package:map_note_pad/Presentation/main_screen/pins/bloc/pins_screen_bloc.dart';
import 'package:map_note_pad/Presentation/main_screen/pins/bloc/pins_screen_state.dart';
import 'package:map_note_pad/Presentation/main_screen/pins/widgets/event_cell.dart';
import 'package:map_note_pad/Presentation/main_screen/pins/widgets/pin_cell.dart';
import 'package:map_note_pad/Widgets/bottom_tab_bar.dart';
import 'package:map_note_pad/Widgets/custom_navigation_bar_item.dart';
import 'package:map_note_pad/Widgets/searchbar.dart';
import 'package:map_note_pad/custom_icons.dart';

class PinsScreen extends StatefulWidget{
  const PinsScreen({Key? key}) : super(key: key);

  @override
  _PinsScreenState createState() =>_PinsScreenState();
}

class _PinsScreenState extends State<PinsScreen>
{
final searchController = TextEditingController();
late Pin? _pin = null;
late Event? _event = null;

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<MainScreenBloc,MainScreenState>(builder: (context, state) {
      var bloc = BlocProvider.of<MainScreenBloc>(context);
      return
        Scaffold(
          floatingActionButton: _biuildFloatActionButton(),
          body: Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Column(
              children: [_buildTabBar(context),
                          _buildBody(bloc),]
            ),
          ),
        );
    });

  }

  Widget _buildPinCell(Pin pin,BuildContext buildContext, BoxConstraints constraints)
  {
   final bloc = BlocProvider.of<MainScreenBloc>(buildContext);
   return  Slidable(key: ValueKey(pin.id),
       child: PinCell(pin,callback: (){ bloc.add(PinTapEvent(pin));},),
        endActionPane: ActionPane(
          extentRatio: 0.5,
          motion: ScrollMotion(),
          children: [
            Builder(
              builder:(context)=> Container(width: constraints.maxWidth/4, color: Colors.red,
                    child: InkWell(
                      onTap: (){
                        var s = Slidable.of(context);
                      s?.close();
                      bloc.add(DeletePinEvent(pin));
                       },
                        child: Center(
                                  child: Image.asset('assets/ic_delete.png',color: Colors.white,),),),),
            )
            ,
            Builder(builder: (context)=>
              Container(width: constraints.maxWidth/4, color: HexColor('#596EFB'),
                child: InkWell(
                  onTap: (){ _pin = pin;
                    _onActionButtonTap();
                  var s = Slidable.of(context);
                  s?.close();
                    },
                  child: Center(
                    child: Image.asset('assets/ic_edit.png',color: Colors.white,),),),),
            )
                 ],
        )
   );
    }
Widget _buildEventCell(Event event,BuildContext buildContext, BoxConstraints constraints)
{
  final bloc = BlocProvider.of<MainScreenBloc>(buildContext);
  return  Slidable(key: ValueKey(event.id),
      child: EventCell(event,callback: (){ bloc.add(EventTapEvent(event));},),
      endActionPane: ActionPane(
        extentRatio: 0.5,
        motion: ScrollMotion(),
        children: [
          Builder(
            builder:(context)=> Container(width: constraints.maxWidth/4, color: Colors.red,
              child: InkWell(
                onTap: (){
                  var s = Slidable.of(context);
                  s?.close();
                  bloc.add(EventDeleteEvent(event));
                },
                child: Center(
                  child: Image.asset('assets/ic_delete.png',color: Colors.white,),),),),
          )
          ,
          Builder(builder: (context)=>
              Container(width: constraints.maxWidth/4, color: HexColor('#596EFB'),
                child: InkWell(
                  onTap: (){ _event = event;
                  _onActionButtonTap();
                  var s = Slidable.of(context);
                  s?.close();
                  },
                  child: Center(
                    child: Image.asset('assets/ic_edit.png',color: Colors.white,),),),),
          )
        ],
      )
  );
}

  Widget _biuildFloatActionButton()  {
    return FloatingActionButton(onPressed: _onActionButtonTap,
        backgroundColor: HexColor("#596EFB"),
        child: Image.asset('assets/ic_plus.png',color: Colors.white,),);
  }

  Future<void> _onActionButtonTap() async
  {
    var index = BlocProvider.of<MainScreenBloc>(context).state.tabIndex;
    bool? res = false;

    if(index == 0)
    {
      res = await Navigator.of(context).push(MaterialPageRoute<bool>(builder: (context) => EditPinScreen(pin: _pin,)));
    }
    else
      {
        res = await Navigator.of(context).push(MaterialPageRoute<bool>(builder: (context) => EditEventScreen(event: _event,)));
      }

    if(res != null && res)
      {
        BlocProvider.of<MainScreenBloc>(context).add(InitStateEvent());
      }
    _pin = null;
    _event = null;
  }

  _buildTabBar(BuildContext context) {
    var bloc = BlocProvider.of<MainScreenBloc>(context);
    return Container(
        height: 60,
        color: Colors.transparent, // main background
        child: Row(
        children: [
          Expanded(child: InkWell(child: _buildTabItem(bloc.state.tabIndex == 0, "Added"),onTap: (){bloc.add(PinScreenTabEvent(0));},)),
          Expanded(child:InkWell(child: _buildTabItem(bloc.state.tabIndex == 1, "Events"),onTap:  (){bloc.add(PinScreenTabEvent(1));},))
        ]
    ),
            
    );
  }

  _buildTabItem(bool isSelected, String text) {
    return Expanded(
      child: Column(
        children: [
          Expanded(child: Center(child: Text(text,style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: HexColor('#1E242B'),
          fontFamily: 'Montserrat', letterSpacing: 1),))),
              Divider(color: isSelected? HexColor('#596EFB') : Colors.grey, thickness: 2,),
        ],
      ),
    );
  }

  Widget _buildBody(MainScreenBloc bloc) {
    if(bloc.state.tabIndex == 0)
      {
        return
          ListView.builder(itemBuilder: (context, index) {
            return LayoutBuilder(builder: (buildcontext, boxconstraints) {
              return _buildPinCell(
                  bloc.state.pins![index], buildcontext, boxconstraints);
            });
          },
            itemCount: bloc.state.pins != null? bloc.state.pins!.length : 0,
            shrinkWrap: true,);
      }
    else
      {
        return
          ListView.builder(itemBuilder: (context, index) {
            return LayoutBuilder(builder: (buildcontext, boxconstraints) {
              return _buildEventCell(
                  bloc.state.events![index], buildcontext, boxconstraints);
            });
          },
            itemCount: bloc.state.events != null? bloc.state.events!.length : 0,
            shrinkWrap: true,);
      }

  }
  }

