import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {

  final Function onTap;
  final Color color;
  final Widget child;
  final BoxConstraints constraints;
  CustomCard({
    @required this.child,
    this.color=Colors.black12,
    this.onTap,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.all(10),
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8))
    ),
    child: InkWell(
      onTap: onTap,
      child: Container(
        constraints: constraints,
        margin: EdgeInsets.all(10),
        child: child,
      ),
    ),
  );
}