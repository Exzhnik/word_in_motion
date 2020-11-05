import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(name: 'Будни'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String name;

  const MyHomePage({Key key, this.name}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        height: 50,
        width: 110,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Offstage(
                  child: UnconstrainedBox(
                    child: RichText(
                        text: TextSpan(
                            text: widget.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        maxLines: 1,
                        key: _key),
                  ),
                ),
                TextWidget(
                  name: widget.name,
                  globalKey: _key,
                  constraints: constraints,
                )
              ],
            );
          },
        ),
      ),
    ));
  }
}

class TextWidget extends StatefulWidget {
  final GlobalKey globalKey;
  final BoxConstraints constraints;
  final String name;

  TextWidget({this.globalKey, this.constraints, this.name});

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  bool isOverflow = false;
  Widget wi;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox renderBox = widget.globalKey.currentContext.findRenderObject();
      if (renderBox.hasSize) {
        print(renderBox.debugCreator.runtimeType);
        setState(() {
          if (renderBox.size.width > 110) {
            isOverflow = true;
          } else
            isOverflow = false;
        });
      }
    });
    print('1 $isOverflow');
  }

  // @override
  // void didUpdateWidget(covariant TextWidget oldWidget) {
  //   if (oldWidget == widget) return;
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     RenderBox renderBox = widget.globalKey.currentContext.findRenderObject();
  //     if (renderBox.hasSize) {
  //       print(renderBox.size.width);
  //       setState(() {
  //         if (renderBox.size.width > 110) {
  //           isOverflow = true;
  //         } else
  //           isOverflow = false;
  //       });
  //     }
  //   });
  //   print('2 $isOverflow');

  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return isOverflow
        ? Marquee(
            text: widget.name,
            style: TextStyle(fontWeight: FontWeight.bold),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 100.0,
            pauseAfterRound: Duration(seconds: 1),
            startPadding: 10.0,
            accelerationDuration: Duration(seconds: 0),
            accelerationCurve: Curves.linear,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.bounceInOut,
          )
        : RichText(
            text: TextSpan(
                text: widget.name,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            maxLines: 1);
  }
}
