

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/content_card.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/database_entity.dart';
import '../../mobx/actions/user_state.dart';
import '../config/configuration.dart';
import 'beautiful_container.dart';


typedef void OnWidgetSizeChange(Size size);

class WeekView extends StatefulWidget {
  const WeekView({Key key}) : super(key: key);

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  int _index = 0;
  double height = 0;

  var _userstate;

  Widget week(Week w){
    return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    
      Text('Week ' + w.position.toString() + ' - ' + w.title,
        style: Configuration.text('h3', Colors.black)
      ),
      SizedBox(height: Configuration.verticalspacing),

    
      Text(w.description,
        style: Configuration.text('small', Colors.black, font: 'Helvetica')
      ),
    
      SizedBox(height: Configuration.verticalspacing),
    
      Column(
        children: w.content.map((e) {
          return ContentCard(
            content: e,
          );
        }).toList(),
      )
    ]);
      
    
    

  }

  @override
  Widget build(BuildContext context) {
     _userstate = Provider.of<UserState>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Configuration.borderRadius/2
        ),
        border: Border.all(
          color: Configuration.grey
        )
      ),
      padding: EdgeInsets.all(
        Configuration.smpadding
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_view_week, size: Configuration.smicon),
              SizedBox(width: Configuration.verticalspacing),
              Text('Weekly practice', 
                style: Configuration.text('subtitle', Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      
          SizedBox(height: Configuration.verticalspacing),
          week(_userstate.data.weeks[_index])
        ],
      )
    );
  }
}



class MeasureSizeRenderObject extends RenderProxyBox {
  Size oldSize;
  final OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key key,
    @required this.onChange,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }
}