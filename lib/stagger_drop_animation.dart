import 'package:flutter/material.dart';

class StaggeredDropAnimation {
  StaggeredDropAnimation(this.controller):

        dropSize = Tween<double>(begin: 0, end: maximumDropSize).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
          ),
        ),

        dropPosition = Tween<double>(begin: 0, end: maximumRelativeDropY).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
          ),
        ),

        holeSize = Tween<double>(begin: 0, end: maximumHoleSize).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
          ),
        ),

        dropVisible = Tween<bool>(begin: true, end: false).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.6, 0.6),
          ),
        ),

        contentVisible = Tween<bool>(begin: true, end: false).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.6, 0.6),
          ),
        ),

        holeVisible = Tween<bool>(begin: true, end: false).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.7, 0.7),
          ),
        ),

        nicOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
          ),
        ),

        textOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
          ),
        );

  final AnimationController controller;

  final Animation<double> dropSize;
  final Animation<double> dropPosition;
  final Animation<bool> dropVisible;
  final Animation<bool> contentVisible;
  final Animation<bool> holeVisible;
  final Animation<double> holeSize;
  final Animation<double> nicOpacity;
  final Animation<double> textOpacity;

  static const double maximumDropSize =  200;
  static const double maximumRelativeDropY = 0.2;
  static const double maximumHoleSize = 10;
}