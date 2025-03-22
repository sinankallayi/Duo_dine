import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class RatingWithCounter extends StatelessWidget {
  const RatingWithCounter({
    super.key,
    required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/rating.svg",
          height: 20,
          width: 20,
          colorFilter: const ColorFilter.mode(
            primaryColor,
            BlendMode.srcIn,
          ),
        ),
        Text(
          rating.toString(),
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: titleColor.withOpacity(0.74)),
        ),
      ],
    );
  }
}
