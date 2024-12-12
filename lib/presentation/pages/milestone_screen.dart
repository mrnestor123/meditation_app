import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/radial_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/wrapper_container.dart';
import 'package:meditation_app/presentation/pages/main.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/milestone_entity.dart';
import '../mobx/actions/user_state.dart';
import 'config/configuration.dart';


class MilestoneScreen extends StatefulWidget {

  MilestoneScreen({Key key}) : super(key: key);

  @override
  State<MilestoneScreen> createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen> {
  Milestone m;
  UserState _userstate;

  Widget objectives(list){
    List<Widget> widgets = new List.empty(growable: true);

    
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) => SizedBox(height: Configuration.verticalspacing),
      itemCount: m.objectives.length,
      itemBuilder: (context, index){
        Objective o = m.objectives[index];
        
        return wrapperContainer(
          child: ListTile(
            title: Text(o.title, style: Configuration.text('small', Colors.black)),
           subtitle: Text(o.description, style: Configuration.text('small', Colors.black,font: 'Helvetica')),
            onTap: () {
              // Navigator.pop(context);
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                o.completed >= o.toComplete ? 
                Icon(Icons.check_circle, color: Colors.green, size: Configuration.smicon) :
                Text(
                  o.completed.toString() + '/' + o.toComplete.toString(), 
                  style: Configuration.text('small', Colors.black)
                ),
              ],
            ),
          )
        );
      },
    );
  }


  void showMilestones(){
    showModalBottomSheet(
      context: navigatorKey.currentContext, 
      builder: (context){
        return Wrap(
          children: [
            Container(
              color: Configuration.maincolor,
              padding: EdgeInsets.all(Configuration.smpadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'The milestones',
                    style: Configuration.text('subtitle', Colors.white),
                  ),
                ],
              ),
            ),
            
            Container(
              margin: EdgeInsets.only(top: Configuration.verticalspacing),
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemCount: _userstate.data.milestones.length,
                itemBuilder: (context, index) {
                  Milestone milestone = _userstate.data.milestones[index];

                  return ListTile(
                    minLeadingWidth: Configuration.width*0.25,
                    leading: Chip(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                        side: BorderSide(color: Colors.black, width: 1)
                      ),
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.landscape, size: Configuration.smicon, color:Colors.black),
                          SizedBox(width: Configuration.verticalspacing/2),
                          Text(
                            milestone.firstStage == milestone.lastStage ?
                            milestone.firstStage.toString() :
                            (milestone.firstStage.toString() + ' - ' + milestone.lastStage.toString()),
                            style: Configuration.text('tiny', Colors.black),
                          ),
                        ],
                      ),
                    ),
                    title: Text(milestone.title, style: Configuration.text('small', Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),

            SizedBox(height: Configuration.verticalspacing*2)
          ],
        );
      });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
  }

  String positionToString(n){
    if(n == 1){
      return 'first';
    }else if(n == 2){
      return 'second';
    }else if(n == 3){
      return 'third';
    }

    return 'last';
  }


  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    m = _userstate.data.milestones[_userstate.user.milestonenumber-1];
    _userstate.user.checkMileStone(milestone: m);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Configuration.lightgrey,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Container(
        color: Configuration.lightgrey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              padding: EdgeInsets.all(Configuration.smpadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                border: Border.all(color: Colors.grey, width: 0.5)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Configuration.width*0.4,
                    height: Configuration.width*0.4,
                    child: milestonePercentage(m: m,width: Configuration.verticalspacing, textSize: 'subtitle')
                  ),
                  
                  SizedBox(height: Configuration.verticalspacing*3),
                  Text(m.title, style: Configuration.text('subtitle',Colors.black)),
            
                  SizedBox(height: Configuration.verticalspacing),
                  Text(m.description, 
                    style: Configuration.text('small',Colors.black, font: 'Helvetica'),
                    textAlign: TextAlign.center,
                  ),
            
                  SizedBox(height: Configuration.verticalspacing * 2),
      
                  Row(
                    children: [
                      Icon(Icons.checklist, color: Colors.black, size: Configuration.smicon),
                      SizedBox(width: Configuration.verticalspacing),
                      Text('Objectives', style: Configuration.text('subtitle',Colors.black))
                    ],
                  ),
      
      
                  SizedBox(height: Configuration.verticalspacing),
                  objectives(m.objectives)
                
                ],
              ),
            ),


            SizedBox(height: Configuration.verticalspacing),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: 
                  BorderSide(color: Colors.grey, width: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                  side: BorderSide(color: Colors.grey, width: 1)
                )
              ),
              onPressed: ()=> showMilestones(),
              child: Container(
                padding: EdgeInsets.all(Configuration.tinpadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('This is the ${positionToString(m.position)} of four milestones',
                        style: Configuration.text('small', Colors.black),
                      ),
                    ),
                    
                    SizedBox(width: Configuration.verticalspacing),
                    Text('Press to View all',
                      style: Configuration.text('small', Colors.grey, font: 'Helvetica'),
                    )
                  ],
                ),
              ),
            ),
            
            SizedBox(height: Configuration.verticalspacing*3)
          ],
        ),
      )
      /*
      bottomSheet: Wrap(
        children:[
          

        ]
      ),*/
    );
  }
}

 


Widget stagesChip({Milestone m}){
  return Chip(
    backgroundColor: Colors.white,
    padding: EdgeInsets.all(4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
      side: BorderSide(color: Colors.black, width: 1)
    ),
    label: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.landscape, color: Colors.black, size: Configuration.smicon),
        SizedBox(width: Configuration.verticalspacing),
        Text('Stages ' + m.firstStage.toString() + ' - ' + m.lastStage.toString(), 
          style: Configuration.text('tiny',Colors.black),
        ),
      ],
  ));
}


Widget milestonePercentage({Milestone m, double width = 4, String textSize = 'small'}){

  return RadialProgress(
    goalCompleted: m.passedPercentage/100,
    width: width,
    progressColor: Configuration.maincolor,
    progressBackgroundColor: Configuration.lightgrey,
    child: Padding(
      padding: EdgeInsets.all(Configuration.tinpadding),
      child: Center(
        child: Text(
          m.passedPercentage.toString() + '%',
          style: Configuration.text( textSize, Configuration.maincolor)
        ),
      ),
    ),
  );
}