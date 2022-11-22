import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_note_pad/Presentation/main_screen/bloc/main_screen_bloc.dart';
import 'package:map_note_pad/Presentation/main_screen/bloc/main_screen_state.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget{


  const MapScreen({
     Key? key}) : super(key: key);

  @override
  _MapScreenState createState()=> _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
{
  Completer<GoogleMapController> _controller = Completer();
  Location location = new Location();
  static  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {
    _getPermissionStatus();
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext  context)
  {
    return BlocBuilder<MainScreenBloc,MainScreenState>(builder: (context, state) {
      var bloc = BlocProvider.of<MainScreenBloc>(context);
        return Stack(
          children: [GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition:  _cameraPosition,
          onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _checkPositionAndMove(state.pinPosition);
          _setInfoWindow(_controller, bloc);
      },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onTap: (latLng){_onMapTap(latLng, context);},//_onLongPress,
            markers: state.markers!,
            zoomControlsEnabled: false,
            onCameraMove: _onCameraMove,
    ),
          Align(alignment: Alignment.bottomRight,
            child: InkWell(onTap: (){_onActionButtonTap(context);},child: Container(height: 50,width: 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0),
              color: Colors.white),
              margin: EdgeInsets.symmetric(vertical: 30,horizontal: 30),
              child: Image.asset("assets/ic_location.png",
                  width: 30,height: 30,
                scale: 0.7,),
            ),
              ),
            ),
          ]
        );
    });
  }

  _getPermissionStatus() async
  {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

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

  void _onMapTap(LatLng argument, BuildContext buildContext) async {
    var bloc = BlocProvider.of<MainScreenBloc>(context);
    final GoogleMapController controller = await _controller.future;
    _cameraPosition = CameraPosition(target: argument, zoom: 14.4746);
    controller.moveCamera(CameraUpdate.newLatLng(argument));
    _setInfoWindow(_controller, bloc);
    //final zoom = await controller.getZoomLevel();
  }

  void _onLongPress(LatLng argument) {
  // var id = 'q';
  //
  //   if(_markers.isNotEmpty){
  //    id = _markers.last.markerId.value +'1';}
  //   else
  //     { id = '1';}
  //
  //   _markers.add(Marker(markerId: MarkerId(id), position: argument));
  //   setState(() {
  //
  //   });
  }

  void _onCameraMove(CameraPosition position) {
    _cameraPosition = position;
  }

  void _checkPositionAndMove(CameraPosition? position) async
  {
    if(position != null)
    {
    final GoogleMapController controller = await _controller.future;
    final _zoom = await controller.getZoomLevel();
    _cameraPosition = CameraPosition(target: position.target, zoom: _zoom);
    controller.moveCamera(CameraUpdate.newLatLng(position.target));
    }
  }

  // Widget _biuildFloatActionButton()  {
  //   return FloatingActionButton(onPressed: _onActionButtonTap,
  //     backgroundColor: Colors.transparent,
  //     child: Image.asset('assets/ic_plus.png',color: Colors.white,),);
  // }

  Future<void> _onActionButtonTap(BuildContext buildContext) async
  {
    var locationData = await location.getLocation();
    final position = LatLng(locationData.latitude!, locationData.longitude!);
    _onMapTap(position,buildContext);
  }
}

void _setInfoWindow(Completer<GoogleMapController> controller,MainScreenBloc bloc ) async {
  var _mapController = await controller.future;
  var markers = bloc.state.markers;
  markers?.forEach((element) {_mapController.showMarkerInfoWindow(element.markerId);});
}