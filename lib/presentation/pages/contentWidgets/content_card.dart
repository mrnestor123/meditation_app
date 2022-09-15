

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/meditation_modal.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/content_entity.dart';
import '../../mobx/actions/user_state.dart';
import '../config/configuration.dart';

class ContentCard extends StatelessWidget {
  Content content, unlocksContent;
  dynamic onPressed;
  bool blocked,seen;
  
  ContentCard({this.content, this.onPressed, this.blocked = false, this.unlocksContent, this.seen = false ,key}):super(key:key);

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return AspectRatio(
      aspectRatio: Configuration.lessonratio,
      child: Container(
        margin: EdgeInsets.all(Configuration.verticalspacing),
        child: ElevatedButton(
          onPressed: onPressed,
          /* () {
            if(content.type == 'meditation-practice'){
              meditationModal(content);
            }else if (!blocked) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentView(
                    lesson: content,
                    content: content,
                    slider: image))
              ).then(onGoBack);
            }
          },*/
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0),
            primary: Colors.white,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Configuration.borderRadius / 3)),
            minimumSize: Size(double.infinity, double.infinity)),
          child: Stack(
            children: [
              content.image != null && content.image.isNotEmpty
                ? Align(
                    alignment: Alignment.centerRight,
                    child: AspectRatio(
                      aspectRatio: 0.9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(
                                Configuration.borderRadius / 3)),
                        child: CachedNetworkImage(
                          imageUrl: content.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                          ),
                          errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                        ),
                      )),
                  )
                : Container(),

              Positioned(
                  top: 15,
                  left: 15,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: Configuration.blockSizeHorizontal * 2),
                        width: Configuration.safeBlockHorizontal * 5,
                        height: Configuration.safeBlockHorizontal * 5,
                        child: Icon(
                          content.isRecording() ? Icons.audiotrack :
                          content.isVideo() ? Icons.ondemand_video : 
                          content.isMeditation() ? Icons.self_improvement
                          : Icons.book,
                          color: Colors.grey,
                          size: Configuration.smicon,
                        ),
                      ),
                      SizedBox(width: Configuration.verticalspacing),
                      content.total != null && content.total.inMinutes  > 0 ?
                      TimeChip(c:content): Container(),
                    ],
                  )),
              Positioned(
                left: 15,
                bottom: 15,
                child: Container(
                  width: Configuration.width * 0.5,
                  child: Text(
                    content.title,
                    style: Configuration.text(
                      "small",
                      blocked ? Colors.grey : Colors.black,
                    ),
                  ),
                )
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                top: 0,
                child: AnimatedContainer(
                  padding: EdgeInsets.all(0),
                  key: Key(content.cod),
                  duration: Duration(seconds: 2),
                  // HACER QUE EL BLOCKED SE SAQUE AQUI !!!!
                  child: blocked
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.lock, size: Configuration.smicon),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                              child: Text(
                                _userstate.user.stagenumber < content.stagenumber && content.position == 0 ? 
                                "Unlocked when you reach stage " + (_userstate.user.stagenumber+1).toString() :
                                
                                'Unlocked after ' + 
                                  (unlocksContent.type == 'meditation-practice' ?
                                  'doing ' : 'reading ') +
                                  unlocksContent.title,
                                  style: Configuration.text('tiny', Colors.white),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ))
                      : Container(),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          Configuration.borderRadius / 3),
                      color: blocked
                          ? Colors.grey.withOpacity(0.8)
                          : Colors.transparent),
                  curve: Curves.fastOutSlowIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
   }
}