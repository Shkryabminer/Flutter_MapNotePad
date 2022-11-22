
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:map_note_pad/Presentation/main_screen/main_screen.dart';
import 'package:map_note_pad/Presentation/registration/create_password_screen.dart';
import 'package:map_note_pad/Presentation/registration/login_bloc/create_name_bloc.dart';
import 'package:map_note_pad/Presentation/registration/login_bloc/create_name_event.dart';
import 'package:map_note_pad/Presentation/registration/login_bloc/create_name_state.dart';
import 'package:map_note_pad/Widgets/custom_button.dart';
import 'package:map_note_pad/Widgets/separator.dart';
import 'package:map_note_pad/Widgets/text_input.dart';


class CreateAccountNameScreen extends StatelessWidget
{
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final currentContext = context;
    // TODO: implement build
    return BlocProvider(
      create: (context) => CreateNameBloc(),
      child: BlocBuilder<CreateNameBloc, CreateNameState>(
        builder: (context,state) =>
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
                               TextInput(_nameController, title: 'Name', label: 'Enter name', errorText: state.errorLoginText, hasSuffixAction: true,
                                 suffixAction: (){_nameController.clear();},),
                               const SizedBox(height: 20,),
                               TextInput(_emailController, title: 'Email', label: 'Enter email',errorText: state.errorPasswordText, hasSuffixAction: true,
                                 suffixAction: (){_emailController.clear();},),
                               const Spacer(flex:1),
                               CustomButton(isActive: true,
                                 color: HexColor('#596EFB'),
                                 height: 40,
                                 onTap: ()
                                 {
                                 BlocProvider.of<CreateNameBloc>(context).add(CreateNameEvent(_nameController.text, _emailController.text,()=>navigate(currentContext,_nameController.text,_emailController.text)));
                                   },
                                 child: Center(child:  Text('Next',
                                   style: TextStyle(fontSize: 14,
                                       fontWeight: FontWeight.w600,
                                       color: Colors.white),)),),
                               Padding(padding: EdgeInsets.symmetric(vertical: 20),
                                   child: Separator()),
                               CustomButton(isActive: true,
                                 isOutlined: true,
                                   outlineColor: HexColor('#D7DDE8'),
                                   height: 40,
                                   onTap: (){BlocProvider.of<CreateNameBloc>(context).add(GoogleSignInEvent(()=> _navigate(currentContext),(message)=>_errorCallBack(context, message))); },
                                   child: const Center(child: Image(image: AssetImage('assets/ic_google.png'))),),
                                 const Spacer(flex:3),
                               ],
                                )
                            ),
                          ),
                        ),
             ),
                    ),
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
  void navigate(BuildContext context, String login, String email)
  {
       Navigator.of(context).push(MaterialPageRoute<void>(builder: (context)=>CreateAccountPasswordScreen(login:login, email: email)));
  }

}