import 'package:flutter/material.dart';
import '../components/small_dot.dart';

import '../constants.dart';

class PriceRangeAndFoodtype extends StatelessWidget {
  const PriceRangeAndFoodtype({
    super.key,
    required this.foodType,
  });

  final List<String> foodType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          foodType.length,
          (index) => Row(
            children: [
              Text(foodType[index],
                  style: Theme.of(context).textTheme.bodyMedium),
              buildSmallDot(),
            ],
          ),
        ),
      ],
    );
  }

  Padding buildSmallDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      child: SmallDot(),
    );
  }
}
