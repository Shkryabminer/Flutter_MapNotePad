import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_note_pad/Presentation/greeting/greeting_screen.dart';
import 'package:map_note_pad/Presentation/main_screen/bloc/main_screen_bloc.dart';
import 'package:map_note_pad/Presentation/main_screen/bloc/main_screen_state.dart';
import 'package:map_note_pad/Presentation/main_screen/map/map_screen.dart';
import 'package:map_note_pad/Presentation/main_screen/pins/pins_screen.dart';
import 'package:map_note_pad/Widgets/bottom_tab_bar.dart';
import 'package:map_note_pad/Widgets/custom_navigation_bar_item.dart';
import 'package:map_note_pad/Widgets/searchbar.dart';

import 'bloc/events.dart';

class MainScreen extends StatefulWidget {
   MainScreen({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState()=> _MainScreenState();

}
class _MainScreenState extends State<MainScreen>
{
  final searchController = TextEditingController();
  int _currentIndex = 0;

  List pages = [MapScreen(key: PageStorageKey<String>('map'),), PinsScreen(key: PageStorageKey<String>('pins'),)];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(create: (context){
      var bloc = MainScreenBloc(MainScreenState());
    bloc.add(InitStateEvent());

    return bloc;},

      child: BlocBuilder<MainScreenBloc, MainScreenState>(builder:(context, state)
      {
        return SafeArea(top: false,
          child: Scaffold(
              appBar: CustomSearchBar(searchController: searchController,
                callback: (text){
                BlocProvider.of<MainScreenBloc>(context).add(SearchPinEvent(text));
                },
              suffixAction: (){_onExitPinTap(context);}),
              body: pages[state.pageIndex],
              bottomNavigationBar: _buildTapBar(context)
          ),
        );})

    );
  }

  _onExitPinTap(BuildContext context) async {
    BlocProvider.of<MainScreenBloc>(context).add(ExitTapEvent(callBack: _onExitTapCallBack));

  }
  _onExitTapCallBack() async
  {
    await Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (context)=>GreetingScreen()));
  }
}

 Widget _buildTapBar(BuildContext context) {
  var bloc = BlocProvider.of<MainScreenBloc>(context);
  return Container(
    height: 60,
     color: Colors.transparent, // main background
     child: Row(
       children: [
         CustomNavigationBarItem(
           image: 'assets/ic_map.png',
           isSelected: 0 == bloc.state.pageIndex,
           label: "Map",
           onTap: () {bloc.add(TabSelectEvent(0));
             }
         ),
         CustomNavigationBarItem(
           image: 'assets/ic_pin.png',
           isSelected: 1 == bloc.state.pageIndex,
           label: "Pins",
           onTap: () {bloc.add(TabSelectEvent(1));
           },
         ),
       ],
     ),
   );
  }
