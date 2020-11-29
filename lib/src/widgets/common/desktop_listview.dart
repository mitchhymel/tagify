
import 'dart:async';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DesktopListView extends StatelessWidget {
  final int columns;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double scrollPercent;
  final bool reverse;
  final Axis scrollDirection;
  DesktopListView({
    @required this.itemCount,
    @required this.itemBuilder,
    this.columns=1,
    this.scrollPercent=0,
    this.reverse=false,
    this.scrollDirection=Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {

    if (itemCount == 0) {
      return Container();
    }

    return _DesktopListViewWrap(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      columns: columns,
      scrollPercent: scrollPercent,
      reverse: reverse,
      scrollDirection: scrollDirection,
    );
  }
}

class _DesktopListViewWrap extends StatefulWidget {

  final int columns;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double scrollPercent;
  final bool reverse;
  final Axis scrollDirection;
  _DesktopListViewWrap({
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.columns,
    @required this.scrollPercent,
    @required this.reverse,
    @required this.scrollDirection,
  });

  @override
  State createState() => _DesktopListViewWrapState();
}

class _DesktopListViewWrapState extends State<_DesktopListViewWrap> {

  final ScrollController controller = new ScrollController();
  final sink = StreamController<double>();

  @override
  void initState() {
    super.initState();
    throttle(sink.stream).listen((offset) {
      if (mounted) {
        controller.animateTo(offset,
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  void dispose() {
    sink.close();
    controller.dispose();
    super.dispose();
  }

  Stream<double> throttle(Stream<double> src) async* {
    if (!mounted || !controller.hasClients) {
      // can sometimes hit here after widget is not mounted, and we
      // don't care to do anything
      return;
    }

    double offset = controller.position.pixels;
    DateTime dt = DateTime.now();
    await for (var delta in src) {
      if (DateTime.now().difference(dt) > Duration(milliseconds: 200)) {
        offset = controller.position.pixels;
      }
      dt = DateTime.now();
      offset += delta;
      yield offset;
    }
  }

  void _handlePointerSignal(PointerSignalEvent e) {
    if (e is PointerScrollEvent && e.scrollDelta.dy != 0) {
      sink.add(8* e.scrollDelta.dy);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (widget.scrollPercent != 0) {
      Future.delayed(Duration.zero, () {
        controller.jumpTo(widget.scrollPercent *
            controller.position.maxScrollExtent);
      });
    }

    var child = widget.columns == 1 ? ListView.builder(
      controller: controller,
      itemBuilder: widget.itemBuilder,
      itemCount: widget.itemCount,
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
    ) : GridView.builder(
      itemCount: widget.itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.columns,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 3)
      ),
      itemBuilder: widget.itemBuilder,
      controller: controller,
      scrollDirection: widget.scrollDirection,
    );

    return Listener(
      onPointerSignal: _handlePointerSignal,
      child: _IgnorePointerSignal(
        child: widget.scrollDirection == Axis.vertical ? DraggableScrollbar.semicircle(
          controller: controller,
          child: child
        ) : child
      )
    );
  }
}

// workaround https://github.com/flutter/flutter/issues/35723
class _IgnorePointerSignal extends SingleChildRenderObjectWidget {
  _IgnorePointerSignal({Key key, Widget child}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(_) => _IgnorePointerSignalRenderObject();
}

class _IgnorePointerSignalRenderObject extends RenderProxyBox {
  @override
  bool hitTest(BoxHitTestResult result, {Offset position}) {
    final res = super.hitTest(result, position: position);
    result.path.forEach((item) {
      final target = item.target;
      if (target is RenderPointerListener) {
        target.onPointerSignal = null;
      }
    });
    return res;
  }
}
