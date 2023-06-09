

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/course_entity.dart';

class ViewCourses extends StatefulWidget {
  const ViewCourses({Key key}) : super(key: key);

  @override
  State<ViewCourses> createState() => _ViewCoursesState();
}

class _ViewCoursesState extends State<ViewCourses> {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: Configuration.smpadding),
      child: Column(
        children: [
          Text('Courses', style:Configuration.text('small',Colors.black)),

          Text('ADD FILTER'),
          Divider(),
          SizedBox(height: Configuration.verticalspacing),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Configuration.crossAxisCount),
              itemCount: _userstate.data.courses.length,
              itemBuilder: (BuildContext context, int index) {  
                Course c = _userstate.data.courses[index];
          
                return Container(
                  margin: EdgeInsets.all(Configuration.smpadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Configuration.borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: Configuration.height*0.2,
                        width: Configuration.width*0.2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(c.image),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      Text(c.title, style: Configuration.text('small', Colors.black)),
                      Text(c.description, style: Configuration.text('small', Colors.black)),
                     // Text(c.stagenumber.toString(), style: Configuration.text('small', Colors.black)),
                    ],
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}