
import 'package:flutter/material.dart';
import 'package:tagify/src/utils/utils.dart';

class TabItem {
  final IconData icon;
  final String text;
  final Widget child;
  TabItem({
    @required this.icon,
    @required this.text,
    @required this.child,
  });
}

class TabbedContainer extends StatefulWidget {

  final List<TabItem> tabs;
  TabbedContainer(this.tabs);

  @override
  State createState() => new _TabbedContainerState();
}

class _TabbedContainerState extends State<TabbedContainer>
    with SingleTickerProviderStateMixin{

  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) => Column(
    children: [
      TabBar(
        controller: controller,
        tabs: widget.tabs.map((e) => Tab(
            icon: Icon(e.icon),
            text: e.text
        )).toList(),
      ),
      Expanded(
        child: TabBarView(
          physics: Utils.isBigScreen(context) ? NeverScrollableScrollPhysics() : null,
          controller: controller,
          children: widget.tabs.map((e) => e.child).toList()
        )
      )
    ],
  );
}