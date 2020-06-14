import 'package:flutter/material.dart';

class DrawersProvider with ChangeNotifier {
  AnimationController _animationController;
  bool _canBeDragged;

  AnimationController get animationController => _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void setController(AnimationController controller) {
    _animationController = controller;
  }

  void open() => _animationController.forward();

  void close() {
    _animationController.reverse();
    notifyListeners();
  }

  void toggle() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        _animationController.isDismissed && details.globalPosition.dx < 200;
    bool isDragCloseFromRight =
        _animationController.isCompleted && details.globalPosition.dx > 300;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void onDragUpdate(DragUpdateDetails details, double maxSlide) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      _animationController.value += delta;
    }
  }

  void onDragEnd(DragEndDetails details, BuildContext context) {
    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      close();
    } else {
      open();
    }
  }
}
