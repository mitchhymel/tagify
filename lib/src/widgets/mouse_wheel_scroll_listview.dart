part of tagify;

typedef ListViewBuilder = Widget Function(PageController);

class MouseWheelScrollListView extends StatefulWidget {

  final ListViewBuilder builder;
  MouseWheelScrollListView({@required this.builder});
  @override
  _PageViewLabState createState() => _PageViewLabState();
}

class _PageViewLabState extends State<MouseWheelScrollListView> {
  final sink = StreamController<double>();
  final pager = PageController();

  @override
  void initState() {
    super.initState();
    throttle(sink.stream).listen((offset) {
      pager.animateTo(
        offset,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    sink.close();
    pager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints.expand(),
    child: Listener(
      onPointerSignal: _handlePointerSignal,
      child: _IgnorePointerSignal(
        child: widget.builder(pager),
      )
    ),
  );

  Stream<double> throttle(Stream<double> src) async* {
    double offset = pager.position.pixels;
    DateTime dt = DateTime.now();
    await for (var delta in src) {
      if (DateTime.now().difference(dt) > Duration(milliseconds: 200)) {
        offset = pager.position.pixels;
      }
      dt = DateTime.now();
      offset += delta;
      yield offset;
    }
  }

  void _handlePointerSignal(PointerSignalEvent e) {
    if (e is PointerScrollEvent && e.scrollDelta.dy != 0) {
      sink.add(7* e.scrollDelta.dy);
    }
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