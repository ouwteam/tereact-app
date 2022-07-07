import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tereact/decoration/circle_indicator.dart';

class CirleAvatarWithIndicator extends StatelessWidget {
  final bool isOnline;
  final String size;
  const CirleAvatarWithIndicator({
    Key? key,
    this.isOnline = false,
    this.size = "L",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;
    if (!isOnline) {
      color = Colors.red;
    }

    Map<String, double> pSize = {
      "L": 50,
      "M": 40,
    };

    return Stack(
      children: [
        CachedNetworkImage(
          width: pSize[size],
          height: pSize[size],
          imageUrl:
              "https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png",
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: CustomPaint(
            painter: const CircleIndicator(color: Colors.white, asBorder: true),
            child: CustomPaint(
              painter: CircleIndicator(color: color),
            ),
          ),
        ),
      ],
    );
  }
}
