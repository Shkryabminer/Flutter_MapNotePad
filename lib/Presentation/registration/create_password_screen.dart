
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:map_note_pad/Presentation/main_screen/main_screen.dart';
import 'package:map_note_pad/Presentation/registration/user_bloc/create_user_bloc.dart';
import 'package:map_note_pad/Presentation/registration/user_bloc/create_user_event.dart';
import 'package:map_note_pad/Presentation/registration/user_bloc/create_user_state.dart';
import 'package:map_note_pad/Widgets/custom_button.dart';
import 'package:map_note_pad/Widgets/password_input.dart';
import 'package:map_note_pad/Widgets/separator.dart';



class CreateAccountPasswordScreen extends StatelessWidget
{
  final String login;
  final String email;
  final _confirmPasswordController = TextEditingController();
  final _passwordController = TextEditingController();

   CreateAccountPasswordScreen({
     required this.login,
     required this.email,
     Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentContext = context;
    // TODO: implement build
    return BlocProvider(
      create: (context)=> CreateUserBloc(),
      child: BlocBuilder<CreateUserBloc,CreateUserState>(
        builder: (context, state)=>
      SafeArea(top: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create an account', style: TextStyle(
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
                    PasswordInput(_passwordController, title: 'Password', label: 'Enter password', errorText: state.errorPasswordText,),
                    const SizedBox(height: 20,),
                    PasswordInput(_confirmPasswordController, title: 'Confirm password', label: 'Confirm password',errorText: state.errorConfirmPasswordText,),
                    const Spacer(flex:1),
                    CustomButton(isActive: true,
                      color: HexColor('#596EFB'),
                      height: 40,
                      onTap: (){
                        BlocProvider.of<CreateUserBloc>(context).add(CreateUserEvent(login, email,_passwordController.text,_confirmPasswordController.text, ()=>_navigate(currentContext)));
                      },
                      child: Center(child:  Text('Create account',
                        style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),)),),
                    Padding(padding: EdgeInsets.symmetric(vertical: 20),
                        child: Separator()),
                    CustomButton(isActive: true,
                      isOutlined: true,
                      outlineColor: HexColor('#D7DDE8'),
                      height: 40,
                      onTap: (){BlocProvider.of<CreateUserBloc>(context).add(GoogleSignInEvent(()=> _navigate(currentContext),(message)=>_errorCallBack(context, message))); },
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