import 'package:flutter/material.dart';

class InkWellCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final double circular;
  InkWellCard(
      {@required this.onTap, @required this.child, @required this.circular});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(circular),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(circular),
        onTap: onTap,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(circular),
                color: Colors.transparent,
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
