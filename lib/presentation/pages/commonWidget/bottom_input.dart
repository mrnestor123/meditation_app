

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class BottomInput extends StatelessWidget {
  TextEditingController _controller = new TextEditingController();

  dynamic onSend;
  String placeholder;
  bool noPop;
  
  BottomInput({this.onSend, this.placeholder, this.noPop = false}) : super();

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.all(Configuration.verticalspacing/2),
          color: Colors.white,
          child: TextField(
            maxLines:null,
            controller: _controller,
            textAlignVertical: TextAlignVertical.center, 
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(Configuration.smpadding),
              hintText: placeholder != null? placeholder : 'Add comment',
              isDense: true,
              suffixIcon: IconButton(
                iconSize: Configuration.smicon,
                onPressed: (){
                  if(_controller.text.trim().isNotEmpty){
                    onSend(_controller.text.trim());
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null && !noPop) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                    _controller.clear();
                  }
                },   
                icon: Icon(Icons.send)
              )
            )
          )
        )
    );
  }
}