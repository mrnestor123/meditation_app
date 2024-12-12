import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/beautiful_container.dart';
import 'package:meditation_app/presentation/pages/commonWidget/page_title.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/content_card.dart';
import 'package:meditation_app/presentation/pages/mainpages/home_screen.dart';
import 'package:provider/provider.dart';

import '../commonWidget/created_by.dart';

class ExploreScreen extends StatefulWidget {
  ExploreScreen();

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  UserState _userstate;
  Image  image;

  double imageWidth, imageHeight;

  ScrollController _controller = new ScrollController();

  List<Widget> positionButtons(){ 
    
    Widget stageButton(Stage s){
      //container  with a number inside

      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50)
        ),
        child: Center(
          child: Text(
            s.stagenumber.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      );
    }


    imageWidth = image.width;
    imageHeight = image.height;

    // create a grid array separating into five columns from width and height
    List<dynamic> grid = new List.empty(growable: true);
    List<Widget> widgets = [];

    for(int i = 0; i < 1 ;  i++){
      grid.add({
        'left':10.0,
        'bottom':20.0
      });
    }

    // create a list of widgets with the position of the buttons
    for(int i = 0; i < 1 ;  i++){
      if(grid[i] != null){
        widgets.add(Positioned(
          left: grid[i]['left'],
          bottom: grid[i]['bottom'],
          child: stageButton(_userstate.data.stages[i])
        ));
      }
    }


    return widgets;
  }


  

  @override
  void initState() {
    super.initState();
    _userstate = Provider.of<UserState>(context, listen: false);
    image = Image.asset("assets/path.png", width: Configuration.width);
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(height: Configuration.verticalspacing*1.5),
          
          pageTitle('',
            'Find guided meditations, philosophy and techniques to practice',
            Icons.explore
          ),
          
          SizedBox(height: Configuration.verticalspacing),

          Padding(
            padding: EdgeInsets.all(Configuration.smpadding),
            child: containerLayout(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Find a teacher',
                          style: Configuration.text('subtitle',Colors.black),
                        ),
                              
                        OutlinedButton(
                          onPressed:() {
                            Navigator.pushNamed(context, '/teachers').then((value) => setState(() => null));
                          },
                          child: Text('See all', style: Configuration.text('small',Colors.black)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius))
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  TeachersList(userstate: _userstate),
                
                ],
              ),
            ),
          ),
          

          Padding(
            padding: EdgeInsets.all(Configuration.smpadding),
            child: Text('Sections & courses', 
              style: Configuration.text('subtitle',Colors.black),
            ),
          ),
          Container(
            padding: EdgeInsets.all(Configuration.smpadding),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _userstate.data.sections.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context,index){
                Section e = _userstate.data.sections[index];
                
                
                return Container(
                  margin: EdgeInsets.only(bottom: Configuration.verticalspacing),
                  child: BeautifulContainer(
                    createdBy:e.createdBy,
                    onPressed: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context){
                          return ViewSection(section:e);
                        })
                      );
                    },
                    title: e.title,
                    subtitle: e.description,
                    image: e.image,
                    color: e.gradientStart != null ? e.gradientStart : Configuration.maincolor,
                  )
                );
              },
            ),
          ),
        ],
      ),
    ); 
  }
}


// view  all content page
class ViewSection extends StatefulWidget {

  Section section;
  ViewSection({Key key, this.section}) : super(key: key);

  @override
  State<ViewSection> createState() => _ViewSectionState();
}

class _ViewSectionState extends State<ViewSection> {

  bool isNotExpanded = false;


  @override
  void initState(){
    super.initState();
    

    if(widget.section.content.length == 0){
      isNotExpanded = true;
    } else {
      widget.section.content.sort((a,b){
        if(a is  String){ 
          isNotExpanded= true;
          return 0;
        } else {
          return a.position != null  && b.position != null ? 
            a.position.compareTo(b.position):0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final  _userstate = Provider.of<UserState>(context);
    
    if(isNotExpanded){
      widget.section = _userstate.data.sections.firstWhere((element) => element.cod ==  widget.section.cod);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CloseButton(
          color: Colors.black
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            widget.section.gradientStart,
                            Colors.white
                          ],
                        )
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(top:Configuration.height*0.1),
                    child: Column(
                      children: [
                        Center(
                          child: Material(
                            borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                            elevation: 2,
                            child: Container(
                              width: Configuration.width > 500 ? Configuration.width*0.5 : Configuration.width*0.6,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                                child: CachedNetworkImage(
                                  imageUrl: widget.section.image,
                                ),
                              )
                            ),
                          ),
                        ),
                        
                        Padding(
                          padding:  EdgeInsets.all(Configuration.smpadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.section.title,
                                style: Configuration.text('subtitle',Colors.black),
                              ),
                              SizedBox(height: Configuration.verticalspacing/2),
                                
                              Text(widget.section.description,
                                style: Configuration.text('small',Colors.black, font: 'Helvetica'),
                              ),
                  
                              // sessions
                              widget.section.createdBy  != null ? 
                                Container(
                                  margin: EdgeInsets.only(top: Configuration.verticalspacing),
                                  child: createdByChip(widget.section.createdBy)
                                ) : Container(),
                              
                              SizedBox(height: Configuration.verticalspacing),
                  
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      
      
              
              
              Container(
                width: Configuration.width,
                padding: EdgeInsets.all(Configuration.smpadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                      width: 2
                    )
                  )
                ),
                child: Text(widget.section.content.length.toString() + ' sessions',
                  style: Configuration.text('small',Colors.black, font: 'Helvetica')
                ),
              ),
              
              Container(
                decoration: BoxDecoration(
                  color: Configuration.lightgrey
                ),
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    left:Configuration.smpadding,  
                    right:Configuration.smpadding, 
                    bottom: Configuration.smpadding
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.section.contentGroups.length,
                  shrinkWrap: true,
                  itemBuilder: (context,i){
                    ContentGroup group =  widget.section.contentGroups[i];
                    
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        SizedBox(height: Configuration.verticalspacing),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(

                              width: 1,
                              color: Colors.grey,
                            )
                          ),
                          padding: EdgeInsets.all(Configuration.smpadding),
                          child: Row(
                            children: [
                              Text(group.title,  style:Configuration.text('subtitle', Colors.white)),
                            ],
                          )
                        ),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(0),
                          itemCount: group.content.length,
                          itemBuilder: (context,index){
                            Content content = group.content[index];
                            bool seen = _userstate.user.contentDone.any((element) => element.cod  == content.cod);
                            
                            return ContentCard(
                              seen: seen,
                              content: content,
                              path: group.content
                              
                            );
                          },
                        )
                      ],
                    ); 
                  }
                ),
              
              
                
              ),
            ],
      
      
      
      
          ),
        ),
      ),

    );
  }
}



