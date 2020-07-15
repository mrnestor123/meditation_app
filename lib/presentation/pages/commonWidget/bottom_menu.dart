import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

List<BottomNavigationBarItem> menuitems = [
  BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.diceOne), title: Text("Stage 1")),
  BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.diceTwo), title: Text("Stage 2")),
  BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.diceThree), title: Text("Stage 3")),
  BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.diceFour), title: Text("Stage 4")),
  BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.diceFive), title: Text("Stage 5")),
  BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.diceSix), title: Text("Stage 6")),
];

class BottomMenu extends StatefulWidget {
  int selectedindex;

  BottomMenu({Key key, this.selectedindex}) : super(key: key);

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int _selectedIndex;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedindex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: Colors.black,
      items: menuitems,
      currentIndex: _selectedIndex,
      selectedItemColor: Configuration.maincolor,
      onTap: _onItemTapped,
    );
  }
}
