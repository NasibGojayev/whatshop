import 'package:flutter/material.dart';

// Function to get screen width
double getWidthSize(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// Function to get screen height
double getHeightSize(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

// Function to determine the crossAxisCount based on screen width
int getCrossAxisCount(BuildContext context) {
  double widthSize = getWidthSize(context);
  return (widthSize < 500) ? 2 :
  (widthSize < 960) ? 3 :
  (widthSize < 1280) ? 4 : 5;
}

// Function to determine child aspect ratio based on screen width
double getChildAspectRatio(BuildContext context) {
  double widthSize = getWidthSize(context);
  return (widthSize < 360) ? 0.62 :
  (widthSize < 430) ? 0.75 :
  (widthSize < 500) ? 0.9 :
  (widthSize < 550) ? 0.68 :
  (widthSize < 650) ? 0.75 :
  (widthSize < 800) ? 0.9 :
  (widthSize < 960) ? 1.1 :
  (widthSize < 1060) ? 1.0 :
  (widthSize < 1200) ? 1.1 :
  (widthSize < 1300) ? 1 : 1;
}


