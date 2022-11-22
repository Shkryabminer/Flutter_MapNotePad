import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

typedef StringCallback = Function(String);
typedef SuffixAction = Function();

class PasswordInput extends StatefulWidget
{
  final TextEditingController _controller;
  final String? label;
  final String? title;
  final FocusNode? focusNodeNext;
  final int minLines;
  final int maxLines;
  final FocusNode? focusNode;
  final StringCallback? onChanged;
  final SuffixAction? suffixAction;
   String? errorText;

   PasswordInput(
      this._controller,  {
        this.label,
        this.title,
        this.focusNode,
        this.onChanged,
        this.focusNodeNext,
        this.minLines = 1,
        this.maxLines = 1,
        this.suffixAction,
        this.errorText,
        Key? key,
      }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput>
{
  var _isHiddenText = false;

    @override
    Widget build(BuildContext context) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 10), child: _getTitle()),
            TextFormField(
              cursorColor: HexColor('#596EFB'),
              controller: widget._controller,
              maxLines: widget.maxLines,
              keyboardType: (widget.maxLines == 1)
                  ? TextInputType.text
                  : TextInputType.multiline,
              minLines: widget.minLines,
              focusNode: widget.focusNode,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                widget.focusNodeNext?.requestFocus();
              },
              onChanged: (string) {
                widget.errorText = null;
                if (widget.onChanged != null) {
                  widget.onChanged!(string);
                }
                setState(() {});
              },
              style: TextStyle(
                color: HexColor('#1E242B'),
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
              ),

              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20.0),
                  hintText: widget.label,
                  hintStyle: TextStyle(
                    color: HexColor('#858E9E'),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                  errorText: widget.errorText,
                  alignLabelWithHint: true,
                  focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: HexColor('#D7DDE8'))),
                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                  disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: HexColor('#D7DDE8'))),
                  enabledBorder:  OutlineInputBorder(borderSide: BorderSide(color: HexColor('#D7DDE8'))),
                  suffixIcon: buildSuffixIcon()
              ),
              obscureText: _isHiddenText,
            ),
          ]
      );
    }

  Widget buildSuffixIcon() {
    var vidget;
    if (widget._controller.value.text.length > 0) {
      vidget = InkWell(onTap: () {
        setState(() {_isHiddenText = !_isHiddenText;
        });
      },
          child: Image(image: AssetImage(_isHiddenText ? 'assets/ic_eye_off.png' : 'assets/ic_eye.png')));
    }
    else {
      vidget = const SizedBox();
    }
    return vidget;
  }

  Widget _getTitle()
  {
    return widget.title != null? Text(widget.title!,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          color: HexColor('#3D4E61'),
          fontSize: 12,
          fontFamily: 'Montserrat'
      ),) : SizedBox();
  }
}