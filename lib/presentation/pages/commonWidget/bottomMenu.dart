import 'package:flutter/material.dart';

class BottomNavyBar extends StatefulWidget {
  final int selectedIndex;

  BottomNavyBar(this.selectedIndex);

  @override
  State<StatefulWidget> createState() {
    return BottomNavyBarState(selectedIndex);
  }
}

class BottomNavyBarState extends State<BottomNavyBar> {
  int selectedIndex;
  Color backgroundColor = Colors.white;

  BottomNavyBarState(this.selectedIndex);

  List<NavigationItem> items = [
    NavigationItem(
        Icon(Icons.home), Text('Feed'), Colors.deepPurpleAccent, "/feed"),
    NavigationItem(
        Icon(Icons.view_headline), Text('Stages'), Colors.pinkAccent, "/stage"),
    NavigationItem(Icon(Icons.book), Text('Lessons'), Colors.blue, "/learn"),
    NavigationItem(
        Icon(Icons.school), Text('Meditation'), Colors.lightBlue, "/meditate"),
    NavigationItem(
        Icon(Icons.person), Text('Profile'), Colors.blueGrey, "/profile")
  ];

  Widget _buildItem(NavigationItem item, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 270),
      height: double.maxFinite,
      width: isSelected ? 131 : 50,
      padding: isSelected ? EdgeInsets.only(left: 16, right: 16) : null,
      decoration: isSelected
          ? BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.all(Radius.circular(50)))
          : null,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconTheme(
                  data: IconThemeData(
                      size: 24,
                      color: isSelected ? backgroundColor : Colors.black),
                  child: item.icon),
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: isSelected
                      ? DefaultTextStyle.merge(
                          style: TextStyle(color: backgroundColor),
                          child: item.title)
                      : Container()),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
      height: 56,
      decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          var itemIndex = items.indexOf(item);
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = itemIndex;
                Navigator.pushNamed(context, item.path);
              });
            },
            child: _buildItem(item, selectedIndex == itemIndex),
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final Icon icon;
  final Text title;
  final Color color;
  final String path;

  NavigationItem(this.icon, this.title, this.color, this.path);
}
