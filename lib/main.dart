
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_note_pad/Presentation/main_screen/main_screen.dart';
import 'package:map_note_pad/Services/AuthenticationService/authentiation_service_impl.dart';
import 'package:map_note_pad/Services/AuthenticationService/authentication_service.dart';
import 'package:map_note_pad/application/bloc/application_bloc.dart';
import 'package:map_note_pad/application/bloc/application_event.dart';
import 'package:map_note_pad/application/bloc/application_state.dart';

import 'Presentation/greeting/greeting_screen.dart';
import 'Presentation/login/login_screen.dart';
import 'constants.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppWidgetState createState() => MyAppWidgetState();
  
  // This widget is the root of your application.
}

class MyAppWidgetState extends State<MyApp>
{
  @override
  Widget build(BuildContext widgetContext) {

    return  BlocProvider<ApplicationBloc>(
        create: (context) { var bloc = ApplicationBloc();
                                bloc.add(ApplicationInitStateEvent());
                            return bloc;},
        child: BlocBuilder<ApplicationBloc , ApplicationState>(
            builder: (ctx,state)  {
              return MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: state.initialRoute,
              );
            }));
  }
  
}


