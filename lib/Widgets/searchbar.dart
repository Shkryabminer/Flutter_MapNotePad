import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:map_note_pad/Widgets/password_input.dart';

class CustomSearchBar extends StatefulWidget with PreferredSizeWidget
{
  final StringCallback? callback;
  final SuffixAction? suffixAction;
  final searchController;
   CustomSearchBar({
    required this.searchController,
    this.callback,
     this.suffixAction,
    Key? key}) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50);
}
class _CustomSearchBarState extends State<CustomSearchBar>
{
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      title: TextFormField(controller: widget.searchController,
        onChanged: widget.callback,
        cursorColor: HexColor('#596EFB'),
        style:  TextStyle(
          color: HexColor('#1E242B'),
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w400,
          fontSize: 14.0,),

          decoration: InputDecoration(
            filled: true,
            fillColor: HexColor('#F1F3FD'),
            constraints: BoxConstraints(maxHeight: 30),
          contentPadding: const EdgeInsets.all(5.0),
          hintText: 'Search',
          hintStyle:  TextStyle(
            color: HexColor('#858E9E'),
            fontWeight: FontWeight.w400,
            fontSize: 12.0,),
          alignLabelWithHint: true,
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: HexColor('#D7DDE8'))),
          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: HexColor('#D7DDE8'))),
          enabledBorder:  OutlineInputBorder(borderSide: BorderSide(color: HexColor('#D7DDE8'))),),
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: InkWell(child: Image.asset('assets/ic_settings.png')),
      actions: [InkWell(child: Image.asset('assets/ic_exit.png'),
      onTap: (){widget.suffixAction?.call();},)],

    );
  }

}