import 'package:flutter/material.dart';

class ReaderOptionRoute extends PageRouteBuilder {
  final Widget widget;
  ReaderOptionRoute({required this.widget})
      : super(
            // transitionDuration: Duration(seconds: 2),
            opaque: false,
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return new ScaleTransition(
                scale: new Tween<double>(
                  begin: 1.50,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Interval(
                      0.00,
                      1.00,
                      curve: Curves.decelerate,
                    ),
                  ),
                ),
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 1.30,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Interval(
                        0.00,
                        0.20,
                        curve: Curves.easeInOutSine,
                      ),
                    ),
                  ),
                  child: child,
                ),
              );
            });
}
