import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class AnimatedBackground extends StatefulWidget {
  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  List<String> assetPaths = [];
  final double coverHeight = 200.0; // or whatever value you prefer
  final double coverWidth = 150.0;
  final double verticalSpacing = 10.0;
  final double horizontalSpacing = 10.0;
   int columns = 15;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController with a fixed duration
    controller = AnimationController(
      duration:  Duration(seconds: 60), // Choose an appropriate duration for your animation
      vsync: this,
    )..repeat(reverse: true); // This makes the animation auto-reverse and repeat indefinitely

    // Fetch the asset image paths
    fetchAssetImagePaths().then((paths) {
      setState(() {
        // Check if there are less than 100 paths and duplicate if necessary
        if (paths.length < 500) {
          // Calculate the number of missing elements
          int missing = 500 - paths.length;
          Random random = Random();

          // Duplicate random elements until we have 100
          for (int i = 0; i < missing; i++) {
            // Select a random index
            int randomIndex = random.nextInt(paths.length);

            // Add the randomly selected path to the list
            paths.add(paths[randomIndex]);
          }
        }
        // Shuffle the list to ensure a random order
        paths.shuffle();

        // setState(() {
          assetPaths = paths;
        // });
        // assetPaths = paths;
      });
    });
  }


  // @override
  // void initState() {
  //   super.initState();
  //
  //   fetchAssetImagePaths().then((paths) {
  //     setState(() {
  //       assetPaths = paths;
  //
  //       int maxColumns = 4;
  //       int columns = min(maxColumns, assetPaths.length);
  //
  //       // Calculate the number of covers for a complete grid
  //       int completeGridCovers = columns * (assetPaths.length ~/ columns);
  //
  //       // Adjust assetPaths to contain only the covers for a complete grid
  //       assetPaths = assetPaths.sublist(0, completeGridCovers);
  //
  //       int baseDuration = 1;
  //       int durationIncrement = 1;
  //       int actualDuration = baseDuration + durationIncrement * (columns - 1);
  //
  //       controller = AnimationController(
  //         duration: Duration(seconds: actualDuration),
  //         vsync: this,
  //       )..repeat(reverse: true);
  //     });
  //   });
  // }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<List<String>> fetchAssetImagePaths() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter to get paths for a specific folder
    final imagePaths = manifestMap.keys.where((String key) => key.contains('assets/covers/')).toList();

    // Filter out non-image files.
    List<String> imageAssets = imagePaths.where((String asset) {
      // Make sure to include any image file extensions you're using in the project.
      return asset.endsWith('.png') || asset.endsWith('.jpg') || asset.endsWith('.jpeg');
    }).toList();

    // print('covers- '+ imagePaths.);

    return imageAssets;
  }

  Widget buildCover(String assetPath, Animation<double> animationX, Animation<double> animationY, int index) {
    // Fixed number of columns


    int column = index % columns;
    int row = index ~/ columns;

    double left = column * (coverWidth + horizontalSpacing);
    double top = row * (coverHeight + verticalSpacing);



    return AnimatedBuilder(
      animation: animationY,  // This could be animationX or animationY; it's just a trigger for rebuild.
      builder: (context, child) {
        double translateX = animationX.value;
        double translateY = animationY.value;

        // Adjust translateY based on the column number
        if (column % 2 == 0) {  // Check if it is an even column
          translateY += coverHeight / 2;  // Displace by half the cover's height
        }

        // Clamp the animation to not go below the initial position
        if (translateY > 0) {
          translateY = 0;
        }
        if (translateX > 0) {
          translateX = 0;
        }

        // The 'top' positioning is now influenced by whether the column is even or odd
        return Positioned(
          top: top + translateY,
          left: left + translateX,
          child: child!,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: !assetPath.toLowerCase().endsWith('.pdf') ? DecorationImage(image: AssetImage(assetPath), fit: BoxFit.cover) : null,
        ),
        height: coverHeight,
        width: coverWidth,
        child: assetPath.toLowerCase().endsWith('.pdf') ? PdfViewer.openAsset(assetPath) : Container(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fixed number of columns and rows

    const int rows = 10;

    // Calculate the total grid size
    double totalGridHeight = (coverHeight + verticalSpacing) * rows - verticalSpacing;
    double totalGridWidth = (coverWidth + horizontalSpacing) * columns - horizontalSpacing;

// Calculate the space left in both directions
    double verticalSpaceLeft = MediaQuery.of(context).size.height - totalGridHeight;
    double horizontalSpaceLeft = MediaQuery.of(context).size.width - totalGridWidth;

// Calculate the maximum diagonal movement based on the available space
// This is the space that you can move diagonally without revealing the background
    double maxMovement = max(verticalSpaceLeft, horizontalSpaceLeft) / sqrt(2); // since we are moving diagonally, divide by sqrt(2)


    if (controller == null) {
      // Handle the case where controller is null, perhaps by returning an empty Container or a loading indicator.
      return Container(); // or some other widget
    }
// Assuming you've defined the ratio of horizontal to vertical movement as:
    double movementRatio = 1.5;  // Adjust this value for desired tilt. >1 means more horizontal movement.

    final translateXTween = Tween(begin: 0.0, end: maxMovement * movementRatio);
    final translateYTween = Tween(begin: 0.0, end: maxMovement);

    final animationX = translateXTween.animate(
      CurvedAnimation(parent: controller!, curve: SawTooth(1)),
    );

    final animationY = translateYTween.animate(
      CurvedAnimation(parent: controller!, curve: SawTooth(1)),
    );
// If controller is not null, proceed with the animation.
//     final animation = Tween(begin: 0.0, end: maxMovement).animate(
//       CurvedAnimation(parent: controller!, curve: SawTooth(1)), // It's now safe to use the '!' operator since we checked for null.
//     );
    int baseDuration = 2; // 5 seconds for 1 column
    int durationIncrement = 2; // 2 seconds for every additional column

// Calculate the actual duration
    int actualDuration = baseDuration + durationIncrement * (columns - 1);

    controller?.duration = Duration(seconds: 25);
    controller?..repeat(reverse: true);

    // Ensure assetPaths is not empty before building the Stack
    if (assetPaths.isEmpty) return CircularProgressIndicator(); // Show a loading indicator while assetPaths is being fetched

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
          rows * columns,  // 15 columns * 10 rows = 150 covers
              (index) => buildCover(assetPaths[index % assetPaths.length], animationX,animationY, index)  // Use modulo to cycle through assetPaths if there are fewer than 150 items
        ),
      ),
    );
  }
}