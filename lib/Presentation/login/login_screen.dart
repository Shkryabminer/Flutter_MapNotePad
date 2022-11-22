
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:map_note_pad/Presentation/login/bloc/login_bloc.dart';
import 'package:map_note_pad/Presentation/login/bloc/login_event.dart';
import 'package:map_note_pad/Presentation/login/bloc/login_state.dart';
import 'package:map_note_pad/Presentation/main_screen/main_screen.dart';
import 'package:map_note_pad/Widgets/custom_button.dart';
import 'package:map_note_pad/Widgets/password_input.dart';
import 'package:map_note_pad/Widgets/separator.dart';
import 'package:map_note_pad/Widgets/text_input.dart';

class LoginScreen extends StatelessWidget
{
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final currentContext = context;
    // TODO: implement build
    return BlocProvider(
      create: (context)=> LoginBloc(),
      child: BlocBuilder<LoginBloc, LoginState>(
       builder:(context,state)=> SafeArea(top: false,
         child: Scaffold(
          appBar: AppBar(
            title: Text('Log In', style: TextStyle(
              fontSize: 16,
              color: HexColor('#1E242B'),
              fontWeight: FontWeight.w600
            ),
            ),
            leading: InkWell(child: Image(image: AssetImage('assets/ic_back.png'),),
            onTap: (){Navigator.of(context).pop();},),

          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,),
            body:Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
              child: Center
                (
                child: Column(
                  children: [SizedBox(height: 20,),
                    TextInput(_loginController, title: 'Email', label: 'Enter email', errorText: state.emailErrorText),
                  const SizedBox(height: 20,),
                  PasswordInput(_passwordController, title: 'Password', label: 'Enter password', errorText: state.passwordErrorText,
                  ),
                    const Spacer(flex:1),
                    CustomButton(isActive: true,
                      color: HexColor('#596EFB'),
                      height: 40,
                      onTap: (){
                      BlocProvider.of<LoginBloc>(context).add(
                          LoginClickEvent(_loginController.text, _passwordController.text, ()=> _navigate(currentContext), null));},

                      child: Center(child:  Text('Log In',
                        style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),)),),
                    Padding(padding: EdgeInsets.symmetric(vertical: 20),
                        child: Separator()),
                    CustomButton(isActive: true,
                      isOutlined: true,
                      outlineColor: HexColor('#D7DDE8'),
                      height: 40,
                      onTap: (){
                          BlocProvider.of<LoginBloc>(context).add(GoogleAuthEvent(()=> _navigate(currentContext),(message)=>_errorCallBack(context, message)));
                      },
                      child: const Center(child: Image(image: AssetImage('assets/ic_google.png'))),),
                    const Spacer(flex:3),
                  ],
                )
                ),
              ),
            ),
       ),
    )
    );
  }

  void _errorCallBack(BuildContext context, String message)
  {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
  });}

  void _navigate(BuildContext context)
  {
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (context)=>MainScreen()));
  }


}