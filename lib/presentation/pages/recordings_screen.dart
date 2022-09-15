

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/content_card.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_screens.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/content_entity.dart';
import '../../domain/entities/path_entity.dart';
import 'config/configuration.dart';

class RecordingsScreen extends StatefulWidget {
  const RecordingsScreen({ Key key }) : super(key: key);

  @override
  State<RecordingsScreen> createState() => _RecordingsScreenState();
}

class _RecordingsScreenState extends State<RecordingsScreen> {
  
  Widget pathView({Path path}){
    return Container(
      width: Configuration.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(Configuration.smpadding),
          primary: Configuration.maincolor,
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius/2))
        ),
        onPressed: (){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context){
              return PathPage(path:path);
            })
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: Configuration.width*0.8,
              child: Column(
                mainAxisAlignment:MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(path.title,style: Configuration.text('small',Colors.white)),

                  SizedBox(height: Configuration.verticalspacing),
                  
                  Text(path.description, style: Configuration.text('small',Colors.white,font:'Helvetica')),

                  SizedBox(height: Configuration.verticalspacing),
                  Row(
                    children: [
                      Chip(
                        backgroundColor: Colors.white,
                        label: Text(path.content.length.toString() + ' sessions',
                          style: Configuration.text('small',Colors.black)
                        )
                      ),
                      SizedBox(width: Configuration.verticalspacing),
                      
                      path.isNew != null && path.isNew ? 
                        Chip(
                          backgroundColor: Colors.lightBlue,
                          label: Text('New',style: Configuration.text('small',Colors.white))
                        ): Container()
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: Configuration.verticalspacing),
           /* Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.grey
                  ),
                ),
              ),
            ),*/
          ],
        )),
    );
  }

  Widget biography(){

    String culadasabio  = """ Culadasa (John Yates, Ph.D.) is the founder of Dharma Treasure Buddhist Sangha in Tucson, Arizona, over which he presided as the spiritual director from 2008 to 2019. He is the author of The Mind Illuminated: A Complete Meditation Guide Using Buddhist Wisdom and Brain Science (Dharma Treasure Press, October 6, 2015). A meditation master with over four decades of experience in the Tibetan and Theravadin Buddhist traditions, Culadasa was ordained as an Upasaka (dedicated lay-practitioner) in 1976 and received ordination in the International Order of Buddhist ministers in Rosemead, California in December 2009.
      
      His principle teachers were Upasaka Kema Ananda and the Venerable Jotidhamma Bhikkhu, both trained in the Theravadin and Tibetan Karma Kagyu traditions with lineage to the Venerable Ananda Bodhi (later recognized by the 16th Gyalwa Karmapa as the tulku Namgyal Rinpoche)

      For many years, Culadasa taught physiology and neuroscience and worked at the forefront of the new fields of complementary healthcare education, physical medicine, and therapeutic massage. His unique lineage allows Culadasa to provide his students with a broad and in-depth perspective on the Buddha Dharma. He combines the original teachings of the Buddha with an emerging, scientific understanding of the mind to give students a rich and rare opportunity for rapid progress and profound insight.

      In 1996, Culadasa retired from academia and moved with his wife Nancy into an old Apache stronghold in the southeastern Arizona wilderness to live a contemplative life and deepen their spiritual practice together.

      The Mind Illuminated is the first comprehensive guide to Buddhist meditation for a Western audience. Written with clarity and detail, this user-friendly meditation manual provides the reader with in depth knowledge of meditation, Buddhism, and science of the mind. The Mind Illuminated is for mediators of all levels with step-by-step guidance for every stage of the path – from the very first sit all the way to mastery of the deepest states of peace and insight.

      Culadasa is also the author of the groundbreaking book, A Physician's Guide to Therapeutic Massage and served as the founding president of the Physical Medicine Research Foundation.""";

    return AbstractDialog(
      content: Container(
        padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
        width: Configuration.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Configuration.borderRadius/2)
        ),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: Configuration.verticalspacing),
              Text(culadasabio,style: Configuration.text('small',Colors.black,font: 'Helvetica')),
              SizedBox(height: Configuration.verticalspacing)
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: Configuration.verticalspacing),
          ClipRRect(
            borderRadius: BorderRadius.circular(Configuration.borderRadius/4),
            child: Image(
              height: Configuration.height*0.18,
              image: AssetImage('assets/culadasa-photo.jpeg'),
              loadingBuilder: (context,widget,imagechunk){
                if(imagechunk == null){
                  return widget;
                }
                return Container(height: Configuration.height*0.18);
              },
            ),
          ),
          SizedBox(height: Configuration.verticalspacing),
          Text('Culadasa talks', style: Configuration.text('smallmedium',Colors.black)),
          SizedBox(height: Configuration.verticalspacing/2),
          Text( 'Group of recordings from retreats held by Culadasa that talk about various meditation topics',
            style: Configuration.text('small',Colors.grey,font: 'Helvetica'),textAlign: TextAlign.center,),
          
          SizedBox(height: Configuration.verticalspacing),

          GestureDetector(
            onTap: (){
              showDialog(
                context: context, 
                builder: (context){
                  return biography();
                }
              );
            },
            child: Text('Biography',style: Configuration.text('small',Colors.lightBlue)),
          ),

          //SizedBox(height: Configuration.verticalspacing),
          //Text('List of recordings',style: Configuration.text('small',Colors.black)),
          SizedBox(height: Configuration.verticalspacing),
          /*
          Material(
            elevation: 2,
            borderRadius:BorderRadius.circular(Configuration.borderRadius/3) ,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Configuration.borderRadius/2)
              ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: Configuration.height*0.15,
                    constraints: BoxConstraints(
                      maxHeight: Configuration.height*0.15
                    ),
                    child:ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                        left:Radius.circular(Configuration.borderRadius/3)
                      ),
                      child: Image(
                        image: AssetImage('assets/culadasa-photo.jpeg'),
                        loadingBuilder: (context,widget,imagechunk){
                          if(imagechunk == null){
                            return widget;
                          }
                          return Container(height: Configuration.height*0.15, color:Colors.white);
                        },
                      ),
                    )
                  ),
                  SizedBox(width: Configuration.verticalspacing),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Culadasa talks', style: Configuration.text('small medium',Colors.black)),
                        SizedBox(height: Configuration.verticalspacing/2),
                        Text( 'Group of recordings from retreats held by Culadasa that talk about various meditation topics',
                          style: Configuration.text('tiny',Colors.grey)),
                        
                        SizedBox(height: Configuration.verticalspacing),

                        GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context, 
                              builder: (context){
                                return biography();
                              }
                            );
                          },
                          child: Text('Biography',style: Configuration.text('small',Colors.lightBlue)),
                        ),
                        /* 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.only(right: 8)
                              ),
                              onPressed: (){
          
                              }, 
                              child: Text('Biography'))
                          ],
                        )*/
                      ],
                    ),
                  )
          
                  
                ],
              ),
            ),
          ),*/
          SizedBox(height: Configuration.verticalspacing),

          Divider(),
          ListView.separated( 
            shrinkWrap: true,
            itemCount: _userstate.data.paths.length,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical:Configuration.verticalspacing), 
            itemBuilder: (BuildContext context, int index) { 
              return pathView(path: _userstate.data.paths[index]);
            },
            separatorBuilder: (context,int){
              return SizedBox(height: Configuration.verticalspacing);
            },
          )
        ]
      ),
    );
  }
}


class PathPage extends StatefulWidget {
  Path path;

  PathPage({ Key key, this.path}) : super(key: key);

  @override
  State<PathPage> createState() => _PathPageState();
}


class _PathPageState extends State<PathPage> {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return Scaffold(
      backgroundColor: Configuration.maincolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(Configuration.smpadding),
              height: Configuration.height*0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.path.title,style: Configuration.text('medium',Colors.white)),
                        SizedBox(height: Configuration.verticalspacing),
                        Text(widget.path.description,style: Configuration.text('small',Colors.white,font:'Helvetica'))
                      ],
                    ),
                  ),
                  SizedBox(height: Configuration.verticalspacing),
                  Container(
                    width: Configuration.width*0.1,
                  )
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minHeight: Configuration.height*0.85
              ),
              padding: EdgeInsets.symmetric(vertical: Configuration.smpadding),
              decoration: BoxDecoration(
                color: Configuration.lightgrey,
                borderRadius: BorderRadius.circular(Configuration.borderRadius)
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context,i){
                  return ContentCard(
                    //key: Key(widget.path.content[i].do),
                    // HAY QUE REFACTORIZAR LA PESTAÑA DE MEDITACIONES 
                    onPressed: (){
                      Content c =  Content.fromJson(widget.path.content[i].toFullJson());
                      c.description = c.title;
                      c.title  = widget.path.title;
      
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context){
                          return CountDownScreen(
                            content: c,
                            then:(){setState((){});},
                          );
                        })
                      ).then((value) { 
                        Future.delayed(Duration(milliseconds: 700),(){
                          setState((){
                            print('QUE PASAA VALENCIANS REBUILDING !!!!');
                          });
                        })
                        ;});
                    },  
                    content: widget.path.content[i]
                  );
                }, 
                itemCount: widget.path.content.length
              ),
            ) 
          ],
        ),
      ),
    );
  }
}


class PathRecordingScreen extends StatelessWidget {
  Path path;

  Content selectedcontent;

  PathRecordingScreen({this.path, this.selectedcontent}) : super();

  @override
  Widget build(BuildContext context) {
    return CountDownScreen(
      content: selectedcontent
    );
  }
}




