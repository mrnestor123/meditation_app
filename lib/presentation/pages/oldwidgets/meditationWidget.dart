import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/oldwidgets/bottomMenu.dart';

class MeditationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromRGBO(163, 113, 190, 70),
      body: ListView(
        children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Center(
            child: Text('Train your mind',
                style: Theme.of(context).textTheme.display2)),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Container(
            padding: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextContainer(text:'Guided Meditations'),
                TextContainer(text:'Meditate by yourself')
              ],
            ))
      ]),
      bottomNavigationBar: BottomNavyBar(2),
    );
  }
}

class TextContainer extends StatelessWidget {
  
  final String text;
  
  const TextContainer({
    Key key, this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.2,
        child: Center(child: Text(text),),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all()));
  }
}
