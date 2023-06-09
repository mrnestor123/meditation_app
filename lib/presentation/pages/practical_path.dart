import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meditation_app/presentation/pages/commonWidget/carousel_balls.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/user_bottom_dialog.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/technique_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../mobx/actions/user_state.dart';
import 'commonWidget/back_button.dart';
//import 'package:open_file/open_file.dart';


// SE LE PODRÁ PASAR UNA STAGE O MOSTRARÁ  TODAS LAS  TÉCNICAS
// ESTO DEBERÍA DE ESTAR DENTRO DE LEARN SCREEN
class PracticalPath extends StatefulWidget {
  const PracticalPath({Key key}) : super(key: key);

  @override
  State<PracticalPath> createState() => _PracticalPathState();
}

class _PracticalPathState extends State<PracticalPath> {
  int position = 0;
  int _index = 0;
  int stagenumber;
  UserState _userstate;
  List<Technique> techniques = new  List.empty(growable: true); 
  User oded;

  Widget explanation({String title, String text}){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Configuration.width,
          padding: EdgeInsets.all(Configuration.smpadding),
          color: Configuration.maincolor,
          child: Text(title, style: Configuration.text('medium', Colors.white, font: 'Helvetica')),
        ),
        Container(
          padding: EdgeInsets.all(Configuration.smpadding),
          child: htmlToWidget(text),
        ),
      ],
    );
  }

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();

    final args = ModalRoute.of(context).settings.arguments as Map;
    _userstate = Provider.of<UserState>(context);
    _userstate.users.forEach((element) {
      if(element.nombre == 'Oded Raz'){
        oded = element;
      }
    });

    if(args != null){
      stagenumber = args['stagenumber'];
      techniques  = _userstate.data.techniques.where((element) => element.startingStage <= stagenumber).toList();
      
      int startingpoint =  techniques.indexWhere((element) => element.startingStage == stagenumber);
      _index = args['position'] + startingpoint;
      setState(() {});
    }
  }

  Future<String>  getPath() async{
    String _localPath;
    if (Platform.isAndroid) {
        _localPath = "/sdcard/download/";
        print(await getExternalStorageDirectories(
          type: StorageDirectory.downloads)
        );
    } else {
      var directory = await getApplicationDocumentsDirectory();
      _localPath = directory.path + Platform.pathSeparator + 'Download';
    }
    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    return _localPath;
  }

  /*
  Future download2(String url, String filename) async {
    try {
      Directory path = await getTemporaryDirectory();
      Dio dio = Dio();
      final file = File('${path.path}/$filename');

      Response response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false
        )
      );
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      if(file !=null){
        print({'OPENING FILE', file.path});
        OpenFile.open(file.path);
      }

      print('SUCCESS');
      print( response);
    } catch (e) {
      print(e);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    position = 0;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed:()=>{
              showDialog(
                context: context, 
                builder: (context){
                  return AbstractDialog(
                    content: Container(
                      padding: EdgeInsets.all(Configuration.smpadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('This techniques have been based from the Playful path, created by Oded Raz. It presents a series of tasks that we have to follow in order to progress. \n\n  Here you can find a link to his work', 
                            style: Configuration.text('small', Colors.black, font: 'Helvetica'),
                            textAlign: TextAlign.center,
                          ),

                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue
                            ),
                            onPressed: ()async{
                              Directory tempDir = await getTemporaryDirectory();
                              String filename = 'playfulpath.pdf';       
                              final imgUrl = "https://firebasestorage.googleapis.com/v0/b/the-mind-illuminated-32dee.appspot.com/o/The%20Practical%20Path%20-%20haMind%20Muar%20(1).pdf?alt=media&token=b6e21d35-0f70-42d0-89cd-61306919aa06";
                              //download2(imgUrl, filename);
                            }, 
                            child: Text('Download the playful path', 
                              style: Configuration.text('small',Colors.blue)
                            )
                          ),
                          GestureDetector(
                            onTap: ()=>{
                              showUserProfile(user:oded, isTeacher: true)
                            },
                            child: Chip(
                              backgroundColor: Colors.lightBlue,
                              avatar: ProfileCircle(userImage: oded.image, width: Configuration.smicon, bordercolor: Colors.white),
                              label: Text(oded.nombre, style: Configuration.text('small', Colors.white),),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })
            },
            icon: Icon(
              Icons.info,
              color: Colors.black,
              size: Configuration.smicon,
            ),
          )
        ],
        backgroundColor: Colors.white,
        leading: ButtonBack(color: Colors.black),
        title: Text('Techniques', style: Configuration.text('big', Colors.black)),
      ),
      body: Container(
        height: Configuration.height,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.grey,
                  padding: EdgeInsets.all(Configuration.smpadding),
                  child: Text("Techniques should be used cyclically in every meditation and in the order they are presented.",
                   style: Configuration.text('small', Colors.white,  font:'Helvetica')
                  ),
                ),

                Expanded(
                  child: CarouselSlider.builder(
                    itemCount: techniques.length,
                    itemBuilder: (context, index, realIndex) {
                      Technique technique = techniques[index];

                      return Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(Configuration.smpadding),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: Configuration.width*0.5,
                                        height: Configuration.width*0.5,
                                        decoration: BoxDecoration(     
                                          borderRadius: BorderRadius.circular(
                                            Configuration.borderRadius
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3), // changes position of shadow
                                            ),
                                          ],                             
                                          color: Colors.white,
                                        ),
                                        child: technique.image != null && technique.image.isNotEmpty
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              Configuration.borderRadius
                                            ),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:technique.image,
                                            ),
                                          ): Container(),
                                      ),

                                      SizedBox(height: Configuration.verticalspacing),
                          
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(Configuration.smpadding),
                                            decoration: BoxDecoration(
                                              color: Configuration.maincolor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text((index+1).toString(),
                                              style: Configuration.text('small', Colors.white, font: 'Helvetica'),
                                            ),
                                          ),
                                          SizedBox(width: Configuration.verticalspacing),
                                          Text(technique.title, style: Configuration.text('medium', Colors.black)),
                                        ],
                                      ),
                                      
                                      htmlToWidget(technique.description),
                                    ],
                                  ),
                                ),

                                
                                explanation(
                                  title: 'Why do we do it?',
                                  text: technique.why
                                ),
                                explanation(
                                  title: 'When to move on? ',
                                  text: technique.moveOn
                                ),

                                explanation(
                                  title: 'When do we return to it?',
                                  text: technique.returnTo
                                ),
                                SizedBox(
                                  height: Configuration.verticalspacing*4,
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }, 
                    options: CarouselOptions(
                      height: Configuration.height,
                      viewportFraction: 1,
                      initialPage: _index,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      onPageChanged: ((index, reason) => setState(() => this._index = index))
                    ),
                  ),
                ),
              ],
            ),
             Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CarouselBalls(
                      items: techniques.length,
                      index: _index,
                      activecolor: Colors.black,
                    ),
                    SizedBox(height: Configuration.verticalspacing*2,)
                  ],
                )
              )
          ],
        ),
      )
    );
  }
}