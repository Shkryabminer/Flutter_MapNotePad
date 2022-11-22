import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:map_note_pad/Models/event/event.dart';
import 'package:map_note_pad/Presentation/edit_event_screen/bloc/edit_event_bloc.dart';
import 'package:map_note_pad/Presentation/edit_event_screen/bloc/edit_event_screen_state.dart';
import 'package:map_note_pad/Presentation/edit_pin_screen/bloc/edit_pin_screen_state.dart';
import 'package:map_note_pad/Widgets/text_input.dart';

import 'bloc/edit_event_screen_events.dart';

class EditEventScreen extends StatefulWidget
{

  final String? label;
  final String? dateTime;
  Event? event;


  EditEventScreen({this.label,
    this.event,
    this.dateTime,Key? key}) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();

}

class _EditEventScreenState extends State<EditEventScreen>
{
  final _labelController = TextEditingController();
  final _dateTimeController = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();

  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) { var bloc = EditEventsScreenBloc(EditEventsScreenState());

      bloc.add(InitStateEvent(event:widget.event, labelController: _labelController,
          dateTimeController: _dateTimeController,
      ));

      return bloc;},
      child: BlocBuilder<EditEventsScreenBloc, EditEventsScreenState>(
        builder: (context, state)=>
            SafeArea(top: false,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(widget.event == null? 'Create event': 'Edit event', style: TextStyle(
                      fontSize: 16,
                      color: HexColor('#1E242B'),
                      fontWeight: FontWeight.w600
                  ),
                  ),
                  leading: InkWell(child: Image(image: AssetImage('assets/ic_back.png'),),
                    onTap: (){
                      Navigator.of(context).pop(false);},),
                  actions: [InkWell(
                    onTap:(){ var bloc = BlocProvider.of<EditEventsScreenBloc>(context);
                    bloc.add(AddUpdateEvent_Event(widget.event, _labelController.text,
                        _dateTimeController.text,
                        _onSaveButtonTapCallBack),
                    );},
                    child: Image.asset('assets/ic_save.png'),)],
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  shadowColor: Colors.transparent,),
                body: _buildBody(context),
              ),
            ),
      ),
    );
  }

  void _onSaveButtonTapCallBack()
  {
    Navigator.of(context).pop(true);
  }

  Widget _buildBody(BuildContext context) {

    double width = MediaQuery. of(context). size. width ;
    var bloc= BlocProvider.of<EditEventsScreenBloc>(context);

    // _latitudeController.text = state.latitude.toString();
    // _longitudeController.text = state.longitude.toString();
    // _labelController.text = state.label ?? '';
    // _descriptionController.text = state.description ?? '';
    _dateTimeController.text = bloc.state.dateText??'';
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints)=>
        Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
          child: Center
            (
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  TextInput(_labelController, title: 'Label', label: 'Enter the label',hasSuffixAction: true),
                  const SizedBox(height: 20,),
                  // Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                  //   child: Text('Date and time',
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.w500,
                  //         color: HexColor('#3D4E61'),
                  //         fontSize: 12,
                  //         fontFamily: 'Montserrat'
                  //     ),),
                  // ),
                  //_buildDateInput(context),
                  TextInput(_dateTimeController, title: 'Date and time', label: 'Select date and time',hasSuffixAction: false,
                  onChanged: (string) async {bloc.add(DateTapEvent());},
                  onTapCallBack: ()async {bloc.add(DateTapEvent());},),
                  const SizedBox(height: 20,),
                  Expanded(
                    child: Stack(
                        children: [GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: _getInitialCameraPosition(),
                          onMapCreated: (controller) {
                            _controller.complete(controller);
                          },
                          markers: bloc.state.markers == null? Set<Marker>() : bloc.state.markers!,
                          myLocationButtonEnabled: false,
                          myLocationEnabled: true,
                          onTap: _onMapTap,
                          onLongPress: (coordinates){_onLongPress(coordinates,context);},
                          zoomControlsEnabled: false,),

                          Align(alignment: Alignment.bottomRight,
                            child: InkWell(onTap: (){_onActionButtonTap();},child: Container(height: 50,width: 50,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0),
                                  color: Colors.white),
                              margin: EdgeInsets.symmetric(vertical: 30,horizontal: 30),
                              child: Image.asset("assets/ic_location.png",
                                width: 30,height: 30,
                                scale: 0.7,),
                            ),
                            ),
                          ),]
                    ),
                  ),
                ],
              )
          ),
        ),
    );
  }

  _getPermissionStatus() async
  {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _onActionButtonTap() async
  {
    await _getPermissionStatus();
    var locationData = await location.getLocation();
    final position = LatLng(locationData.latitude!, locationData.longitude!);
    _onMapTap(position);
  }


  void _onMapTap(LatLng argument) async {
    final GoogleMapController controller = await _controller.future;
    // _longitudeController.text = argument.longitude.toString();
    // _latitudeController.text = argument.latitude.toString();

    _cameraPosition = CameraPosition(target: argument, zoom: 14.5);
    controller.moveCamera(CameraUpdate.newLatLng(argument));
    //final zoom = await controller.getZoomLevel();
  }

  void _onLongPress(LatLng argument, BuildContext builderContext) {
  }

  CameraPosition _getInitialCameraPosition() {
    CameraPosition _initialCameraPosition = _cameraPosition;
    // if (widget.pin != null)
    // {
    //   final _latitude= widget.pin!.latitude.toDouble();
    //   final _longitude= widget.pin!.longitude.toDouble();
    //   _initialCameraPosition = CameraPosition(target: LatLng(_latitude, _longitude), zoom: 14.5);
    // }

    return _initialCameraPosition;
  }
  
  Widget _buildDateInput(BuildContext context)
  {
    var color = HexColor("#858E9E");
    var alfa = color.alpha;
    var gren = color.green;
    var blue = color.blue;
    var red = color.red;
    Color newColor = Color.fromARGB(alfa, red, gren, blue);
    var bloc = BlocProvider.of<EditEventsScreenBloc>(context);
    return Container(height: 60,
                  decoration: BoxDecoration(border:Border(top:BorderSide(color: Color(0xff858e9e),width: 1),
                    right: BorderSide(color: Color(0xff858e9e),width: 1),
                    bottom: BorderSide(color: Color(0xff858e9e),width: 1),
                    left: BorderSide(color: Color(0xff858e9e),width: 1),
                  ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
                child: InkWell(onTap: (){bloc.add(DateTapEvent());},
                  child: Align(alignment:Alignment.centerLeft,
                      child: Padding(padding: EdgeInsets.fromLTRB(20.0,20,10,20),
                          child: Text(bloc.state.dateText ?? 'Select date and time',
                          style: TextStyle(
                            color: bloc.state.dateText == null? HexColor('#858E9E') :HexColor('#1E242B'),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),),
                      ))),);
  }

}