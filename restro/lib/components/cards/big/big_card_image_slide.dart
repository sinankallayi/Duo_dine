import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';

import '../../dot_indicators.dart';
import 'big_card_image.dart';

class AdDisplay extends GetView {
  AdDisplay({
    super.key,
    required this.images,
  });

  final List<String> images;
  final intialIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.81,
      child: Obx(
        () => Stack(
          children: [
            PageView.builder(
              itemCount: images.length,
              onPageChanged: (index){
                intialIndex.value = index;
              },
              itemBuilder: (context, index) {
                return BigCardImage(
                  image: images[index],
                );
              },
            ),
            Positioned(
              bottom: defaultPadding,
              right: defaultPadding,
              child: Row(
                children: List.generate(
                  images.length,
                  (index) => DotIndicator(
                    isActive: intialIndex.value == index,
                    activeColor: Colors.white,
                    inActiveColor: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
