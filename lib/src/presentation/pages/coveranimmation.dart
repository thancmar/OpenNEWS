import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  List<String> assetPaths = List.generate(40, (index) => 'https://picsum.photos/200/300?random=$index');

  @override
  void initState() {
    super.initState();

    int maxColumns = 6;
    int columns = min(maxColumns, assetPaths.length);

    // Calculate the number of covers for a complete grid
    int completeGridCovers = columns * (assetPaths.length ~/ columns);

    // Adjust assetPaths to contain only the covers for a complete grid
    assetPaths = assetPaths.sublist(0, completeGridCovers);

    int baseDuration = 5;
    int durationIncrement = 5;
    int actualDuration = baseDuration + durationIncrement * (columns - 1);

    controller = AnimationController(
      duration: Duration(seconds: actualDuration),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildCover(String assetPath, Animation<double> animation, int index, int columns) {
    double coverHeight = 250;
    double coverWidth = 200;
    double verticalSpacing = 20;
    double horizontalSpacing = 20;

    int column = index % columns;
    int row = index ~/ columns;

    double left = column * (coverWidth + horizontalSpacing);
    double top = row * (coverHeight + verticalSpacing);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        double translateY = animation.value;
        if (translateY > 0) {
          translateY = 0; // Clamp the animation to not go below the initial position
        }
        return Positioned(
          top: column % 2 == 0 ? top + translateY : top + translateY - coverHeight / 2,
          left: left + translateY,
          child: child!,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(image: NetworkImage(assetPath), fit: BoxFit.cover),
        ),
        height: coverHeight,
        width: coverWidth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double coverHeight = 250;
    double coverWidth = 200;
    double verticalSpacing = 20;
    double horizontalSpacing = 20;

    int maxColumns = 6;
    int columns = min(maxColumns, assetPaths.length);
    int rows = (assetPaths.length + columns - 1) ~/ columns;

    double total_grid_height = (coverHeight + verticalSpacing) * rows - verticalSpacing;
    double total_grid_width = (coverWidth + horizontalSpacing) * columns - horizontalSpacing;

    double verticalSpaceLeft = MediaQuery.of(context).size.height - total_grid_height;
    double horizontalSpaceLeft = MediaQuery.of(context).size.width - total_grid_width;

    double maxMovement = min(verticalSpaceLeft, horizontalSpaceLeft);

    final animation = Tween(begin: 0.0, end: maxMovement).animate(
      CurvedAnimation(parent: controller, curve: SawTooth(1)),
    );
    int baseDuration = 2; // 5 seconds for 1 column
    int durationIncrement = 2; // 2 seconds for every additional column

// Calculate the actual duration
    int actualDuration = baseDuration + durationIncrement * (columns - 1);

    controller.duration = Duration(seconds: actualDuration);
    controller..repeat(reverse: true);

    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.center,
          stops: [0.0, 0.4, 1.0],
          colors: [Colors.transparent, Colors.white, Colors.white],
        ).createShader(bounds);
      },
      child: Stack(
        children: List.generate(
          assetPaths.length,
          (index) => buildCover(assetPaths[index], animation, index, columns),
        ),
      ),
    );
  }
}