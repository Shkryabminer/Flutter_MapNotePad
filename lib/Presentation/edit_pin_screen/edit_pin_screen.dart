import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:map_note_pad/Models/pin/pin.dart';
import 'package:map_note_pad/Presentation/edit_pin_screen/bloc/edit_pin_events.dart';
import 'package:map_note_pad/Presentation/edit_pin_screen/bloc/edit_pin_screen_bloc.dart';
import 'package:map_note_pad/Presentation/edit_pin_screen/bloc/edit_pin_screen_state.dart';
import 'package:map_note_pad/Widgets/text_input.dart';

class EditPinScreen extends StatefulWidget
{

  final String? label;
  final String? description;
  Pin? pin;


  EditPinScreen({this.label,
    this.pin,
    this.description,Key? key}) : super(key: key);

  @override
  _EditPinScreenState createState() => _EditPinScreenState();

}

class _EditPinScreenState extends State<EditPinScreen>
{
  final _labelController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();

    CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) { var bloc = EditPinScreenBloc(EditPinsScreenState());

      bloc.add(InitStateEvent(pin:widget.pin, labelController: _labelController,
      descriptionController: _descriptionController,latitudeController: _latitudeController,
        longitudeController: _longitudeController
      ));

      return bloc;},
      child: BlocBuilder<EditPinScreenBloc, EditPinsScreenState>(
        builder: (context, state)=>
       SafeArea(top: false,
         child: Scaffold(
            appBar: AppBar(
              title: Text(widget.pin == null? 'Create pin': 'Edit pin', style: TextStyle(
                  fontSize: 16,
                  color: HexColor('#1E242B'),
                  fontWeight: FontWeight.w600
              ),
              ),
              leading: InkWell(child: Image(image: AssetImage('assets/ic_back.png'),),
              onTap: (){
                Navigator.of(context).pop(false);},),
              actions: [InkWell(
                onTap:(){ var bloc = BlocProvider.of<EditPinScreenBloc>(context);
                bloc.add(AddUpdatePinEvent(widget.pin, _labelController.text,
                _descriptionController.text,
                _latitudeController.text,
                _longitudeController.text,
                 _onSaveButtonTapCallBack),
                );
                },
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
    var state= BlocProvider.of<EditPinScreenBloc>(context).state;

    // _latitudeController.text = state.latitude.toString();
    // _longitudeController.text = state.longitude.toString();
    // _labelController.text = state.label ?? '';
    // _descriptionController.text = state.description ?? '';

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints)=>
        Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
              child: Center
                (
                   child: Column(
                    children: [
                    const SizedBox(height: 20,),
                      TextInput(_labelController, title: 'Label', label: 'Enter the label',hasSuffixAction: true),
                     const SizedBox(height: 20,),
                     TextInput(_descriptionController, title: 'Description', label: 'Enter Description',hasSuffixAction: true),
                     const SizedBox(height: 20,),
                     Row(
                         children: [
                       Container(width:(width-60)/2,
                            child: TextInput(_latitudeController,title: 'Coordinates', label: 'Latitude',)),
                        const Spacer(flex: 1,),
                        Container(width: (width-60)/2,
                            child: TextInput(_longitudeController, label: 'Longitude',)),],
                ),
                      const SizedBox(height: 5,),
                      Expanded(
                        child: Stack(
                          children: [GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: _getInitialCameraPosition(),
                                onMapCreated: (controller) {
                                _controller.complete(controller);
                                },
                                markers: state.marker == null? Set<Marker>() :state.marker!,
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
    _longitudeController.text = argument.longitude.toString();
    _latitudeController.text = argument.latitude.toString();
    BlocProvider.of<EditPinScreenBloc>(builderContext).add(LongPressEvent(coordinates: argument));
  }

 CameraPosition _getInitialCameraPosition() {
    CameraPosition _initialCameraPosition = _cameraPosition;
    if (widget.pin != null)
      {
        final _latitude= widget.pin!.latitude.toDouble();
        final _longitude= widget.pin!.longitude.toDouble();
        _initialCameraPosition = CameraPosition(target: LatLng(_latitude, _longitude), zoom: 14.5);
      }

    return _initialCameraPosition;
  }
}