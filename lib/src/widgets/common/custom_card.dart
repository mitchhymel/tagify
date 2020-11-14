import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {

  final Function onTap;
  final Color color;
  final Widget child;
  CustomCard({
    @required this.child,
    this.color=Colors.black12,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.all(10),
    color: color,
    child: InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        child: child,
      ),
    ),
  );
}