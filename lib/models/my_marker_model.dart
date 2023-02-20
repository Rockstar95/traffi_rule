import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MyMarkerModel {
  final String title, description;
  final Widget widget;
  final LatLng latLng;

  const MyMarkerModel({
    required this.title,
    required this.description,
    required this.widget,
    required this.latLng,
  });
}