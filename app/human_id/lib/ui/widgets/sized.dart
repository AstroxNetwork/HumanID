import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'sized.g.dart';

@swidget
Widget _ver(double v) {
  return SizedBox(height: v);
}

@swidget
Widget _hor(double h) {
  return SizedBox(width: h);
}

@swidget
Widget _sliverVer(double v) {
  return SliverToBoxAdapter(child: SizedBox(height: v));
}

@swidget
Widget _sliverHor(double h) {
  return SliverToBoxAdapter(child: SizedBox(width: h));
}
