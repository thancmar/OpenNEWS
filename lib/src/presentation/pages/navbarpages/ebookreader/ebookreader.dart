import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines/src/blocs/ebook/ebook_bloc.dart';

import '../../../../blocs/reader/reader_bloc.dart';

class Ebookreader extends StatefulWidget {
  const Ebookreader({Key? key}) : super(key: key);

  @override
  State<Ebookreader> createState() => _EbookreaderState();
}

class _EbookreaderState extends State<Ebookreader> {
  @override
  void initState() {
    // widget.allImageData = List<Uint8List?>.filled(int.parse(widget.magazine.pageMax!), null, growable: false);
    // widget.allImagekey = List<GlobalKey>.filled(int.parse(widget.magazine.pageMax!), GlobalKey(), growable: false);

    // BlocProvider.of<EbookBloc>(context).add(
    // OpenReader(idMagazinePublication: widget.magazine.idMagazinePublication!, dateofPublicazion: widget.magazine.dateOfPublication!, pageNo: widget.magazine.pageMax!),
    // OpenReader(magazine: widget.magazine),
    // );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // _spinKitController = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 800),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: <Widget>[
      Positioned.fill(
        child: Hero(tag: 'bg', child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)),
      ),
      OrientationBuilder(builder: (context, orientation) {
        return GestureDetector(
          // child:,
        );
      })
    ]);
  }
}