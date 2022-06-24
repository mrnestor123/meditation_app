import 'dart:math';

import 'package:flutter/material.dart';

enum InitialPosition { start, center, end }

class HorizontalPicker extends StatefulWidget {
  final double minValue, maxValue, selectedValue;
  final int divisions;
  final double height;
  final Function(double) onChanged;
  final InitialPosition initialPosition;
  final Color backgroundColor;
  final bool showCursor;
  final Color cursorColor;
  final Color activeItemTextColor;
  final Color passiveItemsTextColor;
  final String suffix;

  HorizontalPicker({
    this.minValue,
    this.maxValue,
    this.divisions,
    this.height,
    this.onChanged,
    this.selectedValue,
    this.initialPosition = InitialPosition.center,
    this.backgroundColor = Colors.white,
    this.showCursor = true,
    this.cursorColor = Colors.red,
    this.activeItemTextColor = Colors.blue,
    this.passiveItemsTextColor = Colors.grey,
    this.suffix = "",
  }) : assert(minValue < maxValue);

  @override
  _HorizontalPickerState createState() => _HorizontalPickerState();
}

class _HorizontalPickerState extends State<HorizontalPicker> {
  FixedExtentScrollController _scrollController;
  int curItem;
  List<Map> valueMap = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i <= widget.divisions; i++) {
      var value =   widget.minValue +
          ((widget.maxValue - widget.minValue) / widget.divisions) * i;

      var isSelected = value == widget.selectedValue;

      valueMap.add({
        "value":value,
        "fontSize": 14.0,
        "color": isSelected ? widget.activeItemTextColor : widget.passiveItemsTextColor,
      });
      
      if (isSelected){
         _scrollController = FixedExtentScrollController(initialItem: i);
      }
    }
    //setScrollController();
  }

  void setScrollController() {
    int initialItem;
    switch (widget.initialPosition) {
      case InitialPosition.start:
        initialItem = 0;
        break;
      case InitialPosition.center:
        initialItem = (valueMap.length ~/ 2);
        break;
      case InitialPosition.end:
        initialItem = valueMap.length - 1;
        break;
    }

    _scrollController = FixedExtentScrollController(initialItem: initialItem);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: widget.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:widget.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: <Widget>[
          RotatedBox(
            quarterTurns: 3,
            child: ListWheelScrollView(
                physics: ClampingScrollPhysics(),
                controller: _scrollController,
                itemExtent: 60,
                onSelectedItemChanged: (item) {
                  curItem = item;
                  int decimalCount = 1;
                  num fac = pow(10, decimalCount);
                  valueMap[item]["value"] =
                      (valueMap[item]["value"] * fac).round() / fac;
                  widget.onChanged(valueMap[item]["value"]);
                  for (var i = 0; i < valueMap.length; i++) {
                    if (i == item) {
                      valueMap[item]["color"] = widget.activeItemTextColor;
                      valueMap[item]["fontSize"] = 15.0;
                      valueMap[item]["hasBorders"] = true;
                    } else {
                      valueMap[i]["color"] = widget.passiveItemsTextColor;
                      valueMap[i]["fontSize"] = 14.0;
                      valueMap[i]["hasBorders"] = false;
                    }
                  }
                  setState(() {});
                },
                children: valueMap.map((Map curValue) {
                  return ItemWidget(
                    curValue,
                    widget.backgroundColor,
                    widget.suffix,
                  );
                }).toList()),
          ),
          Visibility(
            visible: widget.showCursor,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: widget.cursorColor.withOpacity(0.3),
                ),
                width: 3,
              ),
            ),
          )
        ],
      ),
    );
  }
}


class ItemWidget extends StatefulWidget {
  final Map curItem;
  final Color backgroundColor;
  final String suffix;

  const ItemWidget(
    this.curItem,
    this.backgroundColor,
    this.suffix, {
    Key key,
  }) : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
   List<String> textParts;
   String leftText, rightText;

  @override
  void initState() {
    super.initState();
    int decimalCount = 1;
    num fac = pow(10, decimalCount);

    var mtext = ((widget.curItem["value"] * fac).round() / fac).toString();
    textParts = mtext.split(".");
    leftText = textParts.first;
    rightText = textParts.last;
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 1,
        ),
        child: RotatedBox(
          quarterTurns: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "|",
                style: TextStyle(fontSize: 8, color: widget.curItem["color"]),
              ),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: leftText,
                      style: TextStyle(
                          fontSize: widget.curItem["fontSize"],
                          color: widget.curItem["color"],
                          fontWeight: rightText == "0"
                              ? FontWeight.w800
                              : FontWeight.w400),
                    ),
                    TextSpan(
                      text: rightText == "0" ? "" : ".",
                      style: TextStyle(
                        fontSize: widget.curItem["fontSize"] - 3,
                        color: widget.curItem["color"],
                      ),
                    ),
                    TextSpan(
                      text: rightText == "0" ? "" : rightText,
                      style: TextStyle(
                        fontSize: widget.curItem["fontSize"] - 3,
                        color: widget.curItem["color"],
                      ),
                    ),
                    TextSpan(
                      text: widget.suffix.isEmpty ? "" : widget.suffix,
                      style: TextStyle(
                        fontSize: widget.curItem["fontSize"],
                        color: widget.curItem["color"],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "|",
                style: TextStyle(fontSize: 8, color: widget.curItem["color"]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

