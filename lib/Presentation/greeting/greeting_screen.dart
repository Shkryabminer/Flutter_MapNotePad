import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_note_pad/Presentation/login/login_screen.dart';
import 'package:map_note_pad/Presentation/registration/create_name_screen.dart';
import 'package:map_note_pad/Widgets/custom_button.dart';
import 'package:hexcolor/hexcolor.dart';

class GreetingScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(top: false,left: false,right: false,maintainBottomViewPadding: true,
      child: Scaffold(
body: Padding(
  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  child:   Center(
      child:   Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(flex: 1),
          Image(image: AssetImage('assets/pic_enter_page.png')),
          SizedBox(height: 20),
          Text('MapNotepad', style: TextStyle(fontSize: 18,
            fontWeight: FontWeight.w700,
            color: HexColor('#596EFB'))),
          Spacer(flex: 1),
          CustomButton(
            isActive: true,
            color: HexColor('#596EFB'),
           height: 40,
            onTap: (){Navigator.of(context).push(MaterialPageRoute<void>(builder:(context)=>LoginScreen() ));},
            child: Center(child: Text('Log In',
              style: TextStyle(fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white),
            )
            ),
          ),
          SizedBox(height: 20,),
          CustomButton(
            isActive: true,
            isOutlined: true,
            outlineColor: HexColor('#596EFB'),
            color: Colors.white,
            height: 40,
            onTap: (){Navigator.of(context).push(MaterialPageRoute<void>(builder:(context)=>CreateAccountNameScreen() ));},
            child: Center(child: Text('Create account',
              style: TextStyle(fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HexColor('#596EFB')


              ),)),
          ),
        ]
      ),
  ),
),
      ),
    );
  }

}