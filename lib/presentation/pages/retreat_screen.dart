


import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meditation_app/presentation/pages/commonWidget/bottom_sheet_modal.dart';
import 'package:meditation_app/presentation/pages/commonWidget/carousel_balls.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/retreat_entity.dart';
import '../mobx/actions/user_state.dart';

class RetreatScreen extends StatefulWidget {
  const RetreatScreen({Key key}) : super(key: key);

  @override
  State<RetreatScreen> createState() => _RetreatScreenState();
}

class _RetreatScreenState extends State<RetreatScreen> { 
  
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Retreats', style: Configuration.text('medium',Colors.black)),
        leading: CloseButton(
          color: Colors.black,
        ),
      ),
      body: Container(
        color: Configuration.lightgrey,
        child: Column(
          children: [
            SizedBox(height: Configuration.verticalspacing),
            
            BaseButton(
              text: 'Create Retreat',
              color: Colors.lightBlue,
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => CreateRetreatScreen())
                );
              },
            ),
            
            _userstate.user.retreats.length > 0 ? 
            ListView.builder(
              shrinkWrap: true,
              itemCount: _userstate.user.retreats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_userstate.user.retreats[index].name),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewRetreat()));
                  },
                );
              },
            ) : Container()
          ],
        ),
      ),
    );
  }
}


class ViewRetreat extends StatefulWidget {
  const ViewRetreat({Key key}) : super(key: key);

  @override
  State<ViewRetreat> createState() => _ViewRetreatState();
}

class _ViewRetreatState extends State<ViewRetreat> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



class CreateRetreatScreen extends StatefulWidget {
  const CreateRetreatScreen({Key key}) : super(key: key);

  @override
  State<CreateRetreatScreen> createState() => _CreateRetreatScreenState();
}

class _CreateRetreatScreenState extends State<CreateRetreatScreen> {

  UserState _userstate;

  List<String> slides = [
    'Basic information',
    'What will be the routine?',
    'What will be the activities?',
  ];
  int _index = 0;

  Retreat retreat = new Retreat();

  CarouselController controller = new CarouselController();

  Widget dateInput({DateTime value, bool disabled, hintText,  dynamic onChanged,DateTime firstDate,DateTime lastDate,DateTime initialDate}){

    return TextFormField(
      onTap: ()=>{
        showDatePicker(
          helpText: 'Choose a date',
          context: context, 
          firstDate: firstDate,
          lastDate: lastDate,
          initialDate:initialDate,
          
          //initialDate: retreat.startDate != null ? retreat.startDate : DateTime.now(),  
         // firstDate:  DateTime.now(), 
         // lastDate: retreat.endDate != null ? retreat.endDate : DateTime.now().add(Duration(days: 365))
        ).then((value) => setState(() => onChanged(value)))
      },
      readOnly: true,
      initialValue: value != null ? 
        '${value.day}/${value.month}/${value.year}' : 
        null,
      
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey)
        ),
        prefixIcon: Icon(Icons.calendar_today),
        labelStyle: Configuration.text('small',Colors.black),
        labelText: hintText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value){
        if (value == null || value.isEmpty) {
          return 'Please enter a $hintText';
        }
        return null;
      },
    );
  }

  Widget basicInformation(){
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: Configuration.verticalspacing*3),
          Text('Basic information', style: Configuration.text('smallmedium',Colors.black)),
          SizedBox(height: Configuration.verticalspacing*2),
          TextFormField(
            initialValue: retreat.name != null ? retreat.name : null,
            decoration: InputDecoration(
              labelStyle: Configuration.text('small',Colors.black),
              labelText: 'Name',
              hintText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value){
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onChanged: (value) => retreat.name = value,
          ),
          SizedBox(height: Configuration.verticalspacing*2),
          TextFormField(
            initialValue: retreat.description != null ? retreat.description : null,
            maxLines: 2,
            decoration: InputDecoration(
              labelStyle: Configuration.text('small',Colors.black),
              labelText: 'Description',
              hintText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value){
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
            onChanged: (value) => retreat.description = value,
          ),
          SizedBox(height: Configuration.verticalspacing*2),
          
          dateInput(
            hintText: 'Start date',
            value: retreat.startDate,
            firstDate: DateTime.now(),
            onChanged: (value) => setState(() => retreat.startDate = value),
            initialDate: retreat.startDate != null ? retreat.startDate : DateTime.now().add(Duration(days:1)),
            lastDate: retreat.endDate != null ? retreat.endDate : DateTime.now().add(Duration(days: 365))
          ),

          SizedBox(height: Configuration.verticalspacing*2),
          dateInput(
            disabled: retreat.startDate == null,
            hintText: 'End date',
            value: retreat.endDate,
            onChanged: (value) => setState(() => retreat.endDate = value),
            initialDate: retreat.startDate != null ? retreat.startDate : DateTime.now().add(Duration(days:1)),
            firstDate: retreat.startDate != null ? retreat.startDate : DateTime.now().add(Duration(days:1)),
            lastDate: DateTime.now().add(Duration(days: 365))
          ), 

          SizedBox(height: Configuration.verticalspacing*2),

          BaseButton(
            text: 'Next',
            onPressed: () => {
              if(_formKey.currentState.validate()){
                setState(() => _index = 1)
              }
            },

          )
        ],
      ),
    );
  }

  Widget routine(){
    final _formKey = GlobalKey<FormState>();

    Widget timePicker({String hintText, dynamic onChanged, TimeOfDay value}){
      return TextFormField(
        onTap: ()=>{
          showTimePicker(
            context: context, 
            initialTime: value != null ? value : TimeOfDay(hour: 10,minute: 00)
          ).then((value) => setState(() => onChanged(value)))
        },
        readOnly: true,
        initialValue: value != null ? 
          value.format(context).toString()  : 
          null,
        decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey)
          ),
          prefixIcon: Icon(Icons.calendar_today),
          labelStyle: Configuration.text('small',Colors.black),
          labelText: hintText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value){
          if (value == null || value.isEmpty) {
            return 'Please enter a $hintText';
          }
          return null;
        },
      );
    }

    Widget activity(Activity e){
      return Container(
        margin: EdgeInsets.only(
          bottom: Configuration.verticalspacing
        ),
        width: Configuration.width,
        padding: EdgeInsets.all(Configuration.smpadding),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => setState(() => retreat.activities.remove(e)),
              splashColor: Colors.red,
              color: Colors.red,
            ),
            SizedBox(height: Configuration.verticalspacing),

            TextFormField(
              initialValue: e.name != null ? e.name : null,
              decoration: InputDecoration(
                
                labelStyle: Configuration.text('small',Colors.black),
                labelText: 'Name',
                hintText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => e.name = value,
            ),
            SizedBox(height: Configuration.verticalspacing),
            timePicker(
              hintText: 'Start time',
              value: e.startTime,
              onChanged: (value) => setState(() => e.startTime = value)
            ),
            SizedBox(height: Configuration.verticalspacing),
            timePicker(
              hintText: 'End time',
              value: e.endTime,
              onChanged: (value) => setState(() => e.endTime = value)
            )
          ],
        )
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: Configuration.verticalspacing*2),
          Text( 'What will be the routine?', style: Configuration.text('smallmedium',Colors.black)),
          SizedBox(height: Configuration.verticalspacing*2),
          
          timePicker(
            hintText: 'Start time',
            value: retreat.startTime,
            onChanged: (value) => setState(() => retreat.startTime = value)
          ),

          SizedBox(height: Configuration.verticalspacing*2),

          timePicker(
            hintText: 'End time',
            value: retreat.endTime,
            onChanged: (value) => setState(() => retreat.endTime = value)
          ),

          SizedBox(height: Configuration.verticalspacing*1.5),

          retreat.activities.length > 0 ? 
          Column(
            mainAxisSize: MainAxisSize.min,
            children:retreat.activities.map((e){
            return activity(e);
          }).toList()): Text('No activities added yet'),


          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(Configuration.smpadding),
              side: BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
            onPressed: ()=>{
              setState(() => retreat.activities.add(Activity()))
            }, child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.black, size:Configuration.smicon),
                SizedBox(width: Configuration.verticalspacing*2),
                Text('Add Activity', style: Configuration.text('small',Colors.black),),
              ],
            )
            
          ),

          SizedBox(height: Configuration.verticalspacing*2),


          BaseButton(
            text: 'Back',
            onPressed: () => {
              setState(() => _index--)
            },
            color: Colors.white,
            bordercolor: Colors.black,
            textcolor: Colors.black,
            border: true,
            noelevation: true,
          ),

          SizedBox(height: Configuration.verticalspacing),


          BaseButton(
            text: 'Next',
            onPressed: () => {
              if(_formKey.currentState.validate()){
                setState(() => _index++)
              }
            },
          )

    
      ]),
    );
  }

  Widget confirmData(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Configuration.verticalspacing*2),
        Text( 'Confirm data', style: Configuration.text('smallmedium',Colors.black)),
        SizedBox(height: Configuration.verticalspacing*2),
        Row(
          children: [
            Text( 'Name: ', style: Configuration.text('small',Colors.black, font:'Helvetica')),
            Text( '${retreat.name}', style: Configuration.text('small',Colors.black)),
          ],
        ),
        SizedBox(height: Configuration.verticalspacing*2),
        Row(
          children: [
            Text( 'Description: ', style: Configuration.text('small',Colors.black, font:'Helvetica')),
            Text( '${retreat.description}', style: Configuration.text('small',Colors.black)),
          ],
        ),
        SizedBox(height: Configuration.verticalspacing*2),
        
        // startDate row
        Row(
          children: [
            Text( 'Start date: ', style: Configuration.text('small',Colors.black, font:'Helvetica')),
            Text( '${retreat.startDate.day}/${retreat.startDate.month}/${retreat.startDate.year} ', style: Configuration.text('small',Colors.black)),
          ],
        ),

        
        SizedBox(height: Configuration.verticalspacing*2),
        
        // endDate row
        Row(
          children: [
            Text( 'End date: ', style: Configuration.text('small',Colors.black, font:'Helvetica')),
            Text( '${retreat.endDate.day}/${retreat.endDate.month}/${retreat.endDate.year} ', style: Configuration.text('small',Colors.black)),
          ],
        ),
        SizedBox(height: Configuration.verticalspacing*2),
        
        // startTime row
        Row(
          children: [
            Text( 'Start time: ', style: Configuration.text('small',Colors.black, font:'Helvetica')),
            Text( '${retreat.startTime.format(context)}', style: Configuration.text('small',Colors.black)),
          ],
        ),
        
        SizedBox(height: Configuration.verticalspacing*2),

        // endTime row
        Row(
          children: [
            Text( 'End time: ', style: Configuration.text('small',Colors.black, font:'Helvetica')),
            Text( '${retreat.endTime.format(context)}', style: Configuration.text('small',Colors.black)),
          ],
        ),
        
        SizedBox(height: Configuration.verticalspacing*2),
        Row(
          children: [
            Text( 'Activities', style: Configuration.text('small',Colors.black)),

            Chip(
              label: Text(retreat.activities.length.toString())
            )
          ],
        ),
        SizedBox(height: Configuration.verticalspacing),
        Container(
          height: Configuration.height*0.25,
          child: ListView.builder(
            padding:EdgeInsets.all(0),
            physics: ClampingScrollPhysics(),
            itemCount: retreat.activities.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Activity e =  retreat.activities[index];

              return Container(
                margin: EdgeInsets.only(right: Configuration.verticalspacing*2),
                  width: Configuration.width*0.3,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text( '${e.name}', style: Configuration.text('small',Colors.black)),
                    SizedBox(height: Configuration.verticalspacing*2),
                    Text( 'Start time: ${e.startTime.format(context)}', style: Configuration.text('small',Colors.black)),
                    SizedBox(height: Configuration.verticalspacing*2),
                    Text( 'End time: ${e.endTime.format(context)}', style: Configuration.text('small',Colors.black)),
                    SizedBox(height: Configuration.verticalspacing*2),
                  ],
                ),
              );
            }
          ),
        ),

        SizedBox(height: Configuration.verticalspacing*2),

        BaseButton(
          text: 'Back',
          onPressed: () => {
            setState(() => _index--)
          },
          color: Colors.white,
          bordercolor: Colors.black,
          textcolor: Colors.black,
          border: true,
          noelevation: true,
        ),

        SizedBox(height: Configuration.verticalspacing),

        BaseButton(
          text: 'Create',
          onPressed: () {
            _userstate.createRetreat(r:retreat);
            //Navigator.pop(context);
          },
        ),
      ]
    );


  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Create Retreat', style: Configuration.text('medium',Colors.black)),
        leading: CloseButton(
          color: Colors.black,
        ),
      ),
      body: Container(
        color: Configuration.lightgrey,
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Configuration.smpadding
                ),
                child : 
                _index == 0 ? basicInformation() :
                _index ==  1 ? routine() : 
                confirmData() 
            ),
            /*
            Positioned(
              bottom: Configuration.verticalspacing*4,
              left: 0,
              right: 0,
              child: Center(
                child: CarouselBalls(
                  items:slides.length,
                  index: _index,
                  activecolor: Configuration.maincolor,
                
                ),
              ),
            ),*/

            SizedBox(height: Configuration.verticalspacing),
            
          ],
        ),
      ),
    );
  }
}