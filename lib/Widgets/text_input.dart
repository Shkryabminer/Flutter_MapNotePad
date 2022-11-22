
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

typedef StringCallback = Function(String);
typedef SuffixAction = Function();

class TextInput extends StatefulWidget {
  final TextEditingController _controller;
  final String? label;
  final String? title;
  final FocusNode? focusNodeNext;
  final int minLines;
  final int maxLines;
  final FocusNode? focusNode;
  final StringCallback? onChanged;
  final SuffixAction? onTapCallBack;
  final SuffixAction? suffixAction;
  final bool hasSuffixAction;
   String? errorText;

  TextInput(
      this._controller,  {
        this.label='',
        this.title='',
        this.focusNode,
        this.onChanged,
        this.focusNodeNext,
        this.minLines = 1,
        this.maxLines = 1,
        this.suffixAction,
        this.errorText,
        this.hasSuffixAction = false,
        this.onTapCallBack,
        Key? key,
      }) : super(key: key);

  @override
  _TextInputState createState() => _TextInputState();
  }

class _TextInputState extends State<TextInput>
{
    @override
    Widget build(BuildContext context) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: _getTitle()),
            TextFormField(
              cursorColor: HexColor('#596EFB'),
              controller: widget._controller,
              maxLines: widget.maxLines,
              keyboardType: (widget.maxLines == 1) ? TextInputType.text : TextInputType.multiline,
              minLines: widget.minLines,
              focusNode: widget.focusNode,
              onTap: (){
                widget.onTapCallBack?.call();
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                widget.focusNodeNext?.requestFocus();
              },
              onChanged: (string) {
                widget.errorText = null;
                if(widget.onChanged != null)
                {
                  widget.onChanged!(string);
                }
                setState(() {
                });
              },
              style:  TextStyle(
                color: HexColor('#1E242B'),
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
              ),

              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20.0,20,10,20),
                  hintText: widget.label,
                  hintStyle:  TextStyle(
                    color: HexColor('#858E9E'),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                  alignLabelWithHint: true,
                  errorText: widget.errorText,
                  focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: HexColor('#D7DDE8'))),
                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                  disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: HexColor('#D7DDE8'))),
                  enabledBorder:  OutlineInputBorder(borderSide: BorderSide(color: HexColor('#D7DDE8'))),
                  suffixIcon: buildSuffixIcon()

              ),
            ),
          ]
      );
    }
    Widget buildSuffixIcon()
    {
      var vidget;
      if(widget._controller.value.text.length > 0 && widget.hasSuffixAction)
      {
        vidget = InkWell(onTap: (){
        setState(() {
          widget._controller.clear();
        widget.errorText=null;});
        },
          child: Image(image: AssetImage('assets/delete.png')));
      }
      else
      {
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
        ),) : Container();
    }

  }



