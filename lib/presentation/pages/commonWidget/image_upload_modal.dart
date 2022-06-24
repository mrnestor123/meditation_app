

//PASAR ESTO AL 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

void showPicker({onSelectImage}) {

    final ImagePicker _picker = ImagePicker();

    _imgFromCamera() async {
      XFile image = await _picker.pickImage(source: ImageSource.camera);
      if(image != null){ 
        onSelectImage(image);
      }
    }

    _imgFromGallery() async {
      XFile image = await _picker.pickImage(source: ImageSource.gallery);
      if(image != null){
        onSelectImage(image);
      }
    }

    showModalBottomSheet(
        context: navigatorKey.currentContext,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
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
              ),
            ),
          );
        });
  }