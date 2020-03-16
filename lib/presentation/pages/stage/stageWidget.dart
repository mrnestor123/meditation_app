import 'package:flutter/material.dart';
import 'package:meditation_app/blocs/stageBloc.dart';
import 'package:meditation_app/domain/model/stageModel.dart';
import 'package:meditation_app/interface/commonWidget/bottomMenu.dart';
import 'package:meditation_app/interface/commonWidget/titleWidget.dart';

class StageWidget extends StatelessWidget {
  final int selectedIndex;
  //StagesBloc bloc = new StagesBloc();

  StageWidget(this.selectedIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(children: <Widget>[
          DescriptionWidget('These are all the stages'),
          /**  StreamBuilder<List<Stage>>(
            stream: bloc.allStages,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('error');
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.all(8),
                        child: Center(
                          child: Text('Stage ' +
                              snapshot.data[index].stageNumber.toString()),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                      );
                    },
                    itemCount: snapshot.data.length);
              } else {
                return Text('something happened');
              }
            },
          )**/
        ]),
      ),
      bottomNavigationBar: BottomNavyBar(selectedIndex),
    );
  }
}
