import 'package:flutter/material.dart';


class Screen{
  static double height,width,shorter,longer;
  static setScreenSize(context){
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    shorter=height<width?height:width;
    longer=height>width?height:width;
  }
}
