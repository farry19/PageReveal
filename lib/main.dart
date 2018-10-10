import 'package:flutter/material.dart';
import 'dart:async';

import './widgets/page_reveal.dart';
import './widgets/pager_indicator.dart';
import './widgets/page_dragger.dart';

import './views/page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;

  int activeIndex = 1;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  _MyHomePageState() {
    slideUpdateStream = StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.udpateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }

        } else if(event.udpateType == UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
          // nextPageIndex = index.clamp(0, pages.length - 1);
        } else if (event.udpateType == UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              transitionGoal: TransitionGoal.open,
              vsync: this,
            );
          } else {
            animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              transitionGoal: TransitionGoal.close,
              vsync: this,
            );

            nextPageIndex = activeIndex;
          }

          animatedPageDragger.run();
        } else if (event.udpateType == UpdateType.doneAnimating) {
          activeIndex = nextPageIndex;

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;

          animatedPageDragger.dispose();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Page(
            viewModel: pages[activeIndex],
            percentVisible: 1.0,
          ),
          PageReveal(
            revealPercent: slidePercent,
            child: Page(
              viewModel: pages[nextPageIndex],
              percentVisible: slidePercent,
            ),
          ),
          PagerIndicator(
            pageIndicatorViewModel: PagerIndicatorViewModel(
              pages: pages,
              activeIndex: activeIndex,
              slideDirection: slideDirection,
              slidePercent: slidePercent,
            ),
          ),
          PageDragger(
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < pages.length - 1,
            slideUpdateStream: slideUpdateStream,
          ),
        ],
      ),
    );
  }
}
