import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer(
      {super.key, this.width = double.infinity, this.height = double.infinity});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color.fromARGB(255, 225, 224, 223),
        highlightColor: const Color.fromARGB(255, 238, 235, 235),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
          width: width,
          height: height,
        ));
  }
}
