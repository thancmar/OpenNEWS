import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SpinKitshmg extends StatefulWidget {
  const SpinKitshmg({
    Key? key,
    this.color,
    this.shape = BoxShape.circle,
    this.size = 100.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 3800),
  })  : assert(!(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null),

  'You should specify either a itemBuilder or a color'),
        offset = size * 0.5,
        super(key: key);

  final Color? color;
  final BoxShape shape;
  final double offset;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;

  @override
  State<SpinKitshmg> createState() => _SpinKitshmgState();
}

class _SpinKitshmgState extends State<SpinKitshmg> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale1;
  late Animation<double> _scale2;
  late Animation<double> _scale3;
  late Animation<double> _scale4;
  late Animation<double> _rotate;
  late Animation<double> _translate1;
  late Animation<double> _translate2;
  late Animation<double> _translate3;
  late Animation<double> _translate4;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..repeat();

    final animation1 = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.025, curve: Curves.easeIn));
    _translate1 = Tween(begin: 0.0, end:widget.offset).animate(animation1);
    _scale1 =  Tween(begin: 1.0, end: 1.0).animate(animation1);

    final animation2 = CurvedAnimation(parent: _controller, curve: const Interval(0.025, 0.05, curve: Curves.easeOut));
    _translate2 = Tween(begin:00.0, end: widget.offset).animate(animation2);
    _scale2 =  Tween(begin: 1.0, end: 1.0).animate(animation2);

    final animation3 = CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.525, curve: Curves.easeIn));
    _translate3 = Tween(begin:00.0, end: widget.offset).animate(animation3);
    _scale3 = Tween(begin: 1.0, end: 1.0).animate(animation3);

    // final animation3 = CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.75, curve: Curves.easeInOut));
    // _translate3 = Tween(begin: 0.0, end: -widget.offset).animate(animation3);
    // _scale3 = Tween(begin: 1.0, end: 0.5).animate(animation3);
    //
    final animation4 = CurvedAnimation(parent: _controller, curve: const Interval(0.525, 0.55, curve: Curves.easeOut));
    _translate4 = Tween(begin: 0.0, end: widget.offset).animate(animation4);
    _scale4 = Tween(begin: 1.0, end: 1.0).animate(animation4);

    _rotate = Tween(begin: 0.0, end: 360.0).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Stack(
          children: <Widget>[
            _cube(0),
            _cube(1, true),
            // Container(color: Colors.green,height: double.infinity,width: double.infinity,child:Text(widget.offset.toString()+widget.size.toString()),),
          ],
        ),
      ),
    );
  }

  Widget _cube(int index, [bool offset = false]) {
    Matrix4 tTranslate;
    // if (offset == true) {
    if (index != 0) {
      tTranslate = Matrix4.identity()
    ..translate(0.0-_translate1.value,0.0 )
    ..translate(0.0,-_translate2.value )
    ..translate(0.0+_translate3.value,0.0)
    ..translate(widget.offset,widget.offset+_translate4.value );
    //     // ..translate(-widget.size/2.0,-widget.size/2.0 );
    } else {
      tTranslate = Matrix4.identity()
        ..translate(0.0+_translate1.value, 0.0)
        ..translate(0.0, 0.0+_translate2.value)
        ..translate(0.0-_translate3.value, 0.0)
        ..translate(0.0, 0.0-_translate4.value);
    }

    return Positioned(
      // top:offset == true ? 100.0 : 0.0,
      // left: offset == true ? 0.0 : widget.offset,
      top: 0.0 ,
      left:  0,
      child: Transform(
        transform: tTranslate,
        child: Transform.rotate(
          angle: _rotate.value * 0.074533,
          child: Transform(
            transform: Matrix4.identity()
              ..scale(_scale1.value)
              ..scale(_scale2.value)
              ..scale(_scale3.value)
              ..scale(_scale4.value),

            child: SizedBox.fromSize(
              size: Size.square(widget.size * 0.55),
              child: _itemBuilder(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index) :index == 0 ?
  Image.asset('assets/left.png'): Image.asset('assets/right.png');

      // : DecoratedBox(decoration: BoxDecoration(color: widget.color, shape: widget.shape));
}