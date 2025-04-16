import 'package:flutter/material.dart';

// Function to get screen width
double getWidthSize(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3ZHN6dWJrcGZybnlkdXN3emZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA0MzE4NjEsImV4cCI6MjA1NjAwNzg2MX0.gcDrC8YPB3G_kRqHYZd54QBFJJqI1J17O4zrisrm73Q';
String url = 'https://lwdszubkpfrnyduswzfs.supabase.co';
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
  (widthSize < 430) ? 0.55 :
  (widthSize < 500) ? 0.9 :
  (widthSize < 550) ? 0.68 :
  (widthSize < 650) ? 0.75 :
  (widthSize < 800) ? 0.9 :
  (widthSize < 960) ? 1.1 :
  (widthSize < 1060) ? 1.0 :
  (widthSize < 1200) ? 1.1 :
  (widthSize < 1300) ? 1 : 1;
}


