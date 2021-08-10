
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:provider/provider.dart';

import 'config/configuration.dart';

class Requests extends StatefulWidget {
  const Requests() : super();

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  UserState _userState;

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userState = Provider.of<UserState>(context);
    _userState.getRequests();
  }

  Widget requests(String tipo){
    List<Request> request = _userState.requests;

    return ListView.builder(
      itemCount:request.length,
      itemBuilder: (context,index) => 
        Card(
          child: Container(
            padding: EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: Configuration.smicon),
                    Text(request[index].username, style: Configuration.text('verytiny', Colors.black)),
                ]),
                SizedBox(height: 5.0),
                Text(request[index].title, style: Configuration.text('small', Colors.black)),
                SizedBox(height: 5.0),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children:[
                        IconButton(
                          onPressed: ()=> 
                            setState(() {
                              request[index].dislike(_userState.user.coduser);
                            }),
                          icon:  Icon(Icons.arrow_downward , color:  request[index].votes[_userState.user.coduser] == -1 ? Colors.red : Colors.black)
                        ),
                        Text(request[index].points.toString()),
                        IconButton(
                          onPressed: ()=> 
                            setState(() {
                              request[index].like(_userState.user.coduser);
                              _userState.updateRequest(index, true); 
                            }), 
                          icon: Icon(Icons.arrow_upward, color: request[index].votes[_userState.user.coduser] == 1 ? Colors.green : Colors.black)
                        ),
                      ]
                    ),
                    Row(
                      children: [
                        Icon(Icons.comment),
                        Text(request[index].comments == null ? '0': request[index].comments.length.toString()),
                      ],
                    )
                ])
              ]
            ),
          ),
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String selectedtype = 'Suggestion';
          return showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder:(BuildContext context, StateSetter setState ) {
              return  Container(
                  height: Configuration.height * 0.6,
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text('Add Request', style: Configuration.text('small', Colors.black),textAlign: TextAlign.center)),
                      Divider(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Type of request', style: Configuration.text('small', Colors.black)), 
                          DropdownButton<String>(
                            value: selectedtype,
                            icon: Icon(Icons.arrow_downward_sharp, color: Colors.black,size: Configuration.smicon),
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.black,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                selectedtype = newValue;
                              });
                            },
                            items: <String>['Suggestion', 'Issue'].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Text('Content', style:Configuration.text('small', Colors.black)),
                      SizedBox(height: 6),
                      TextField(
                        maxLines: 10,
                        decoration: InputDecoration.collapsed(hintText: "Enter your text here",
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black)
                          ),),
                      ),
                      ElevatedButton(
                        onPressed: ()=> null, 
                        child: Text('send')
                      )
                    ],
                  )
                );
            });
          }
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Flexible(
              flex:1,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text('Here you can add isues and suggestions to the app', style: Configuration.text('small', Colors.black),)
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 2.5,
                          indicatorColor: Configuration.maincolor,
                          tabs: [
                            Tab(
                              child: Text('Issues', style:Configuration.text('small', Colors.black)),
                            ),
                            Tab(
                                child: Text('Suggestions',style: Configuration.text('small', Colors.black))),
                          ]),
                  ),
                ],
              ),),
              Flexible(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(Configuration.smpadding),
                  color: Configuration.lightgrey,
                  child: Observer(builder: (context)  {
                    return _userState.requests == null ? 
                    CircularProgressIndicator(
                    )
                    :
                    TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        requests('issues') ,
                        requests('suggestions')
                    ]);
                  })
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}


class BackButton extends StatelessWidget {
  const BackButton() : super();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: ()=> Navigator.pop(context), 
      icon: Icon(
        Icons.arrow_back_ios,
        size: Configuration.smicon,
        color: Colors.black,
        )
      );
  }
}