

//PASAR ESTO AL 
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:multiavatar/multiavatar.dart';

import '../main.dart';

// ESTO DEBERÍA SER OTRO NOMBRE
void showPicker({onSelectImage}) {

    final ImagePicker _picker = ImagePicker();


    _imgFromCamera() async {
      XFile image = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480, maxWidth: 640,
        imageQuality: 80
      );

      if(image != null){ 
        onSelectImage(image);
      }
    }

    _imgFromGallery() async {
      XFile image = await _picker.pickImage(
        maxHeight: 480, maxWidth: 640,
        imageQuality: 80,
        source: ImageSource.gallery
      );
      
      if(image != null){
        onSelectImage(image);
      }
    }

    avatarGrid(){

      return StatefulBuilder(
        builder: (context,setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
          
            children: [
              Text('These avatar are unique. You can choose any of them. ',
                style: Configuration.text('small',Colors.black),
              ),


              


              SizedBox(height: Configuration.verticalspacing),

              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Configuration.crossAxisCount+1,
                  crossAxisSpacing: Configuration.verticalspacing,
                  mainAxisSpacing: Configuration.verticalspacing
                ),
                itemCount: 9,
                itemBuilder: (BuildContext context, int index) {
                  var svgCode = multiavatar(DateTime.now().toIso8601String() + index.toString(), 
                    trBackground: true
                    );

                    return GestureDetector(
                      onTap: (){
                        onSelectImage(svgCode);
                        Navigator.pop(context);
                      },
                      child: SvgPicture.string(svgCode, 
                        width: Configuration.width*0.2,
                        height: Configuration.width*0.2,
                        fit: BoxFit.contain,
                      ),
                    );



                  /*
                  return Container(
                    child: Image.,
                  )
                  return Container(
                    child: RandomAvatar(
                      DateTime.now().toIso8601String() + index.toString(),
                    )
                  );*/
                },

              
              
              ),

              SizedBox(height: Configuration.verticalspacing),
              
              BaseButton(
                onPressed: ()=>{
                  setState(()=>{})
                },
                text:'Generate avatars'
              ),
            ],
          );
        }
      );
    }



    showModalBottomSheet(
        context: navigatorKey.currentContext,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children:[Container(
                padding: EdgeInsets.all(Configuration.smpadding),
                child: avatarGrid()
                /* child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () {
                          _imgFromGallery();
                          Navigator.of(navigatorKey.currentContext).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.of(navigatorKey.currentContext).pop();
                      },
                    ),
                  ],
                ),*/
              ),
            ]),
          );
        });
  }