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
    return InkWell(
      //show bottom shhet with rating
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 200,
              child: Center(
                child: RatingStars(
                  size: 30,
                  onRated: (rating) {
                    print("User rated: $rating");
                  },
                ),
              ),
            );
          },
        );
      },
      child: Row(
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
      ),
    );
  }
}

class RatingStars extends StatefulWidget {
  final double size;
  final Color filledColor;
  final Color unfilledColor;
  final Function(int) onRated;

  const RatingStars({
    Key? key,
    this.size = 40,
    this.filledColor = Colors.amber,
    this.unfilledColor = Colors.grey,
    required this.onRated,
  }) : super(key: key);

  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  int _selectedRating = 0;

  void _rate(int rating) {
    setState(() {
      _selectedRating = rating;
    });
    widget.onRated(rating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => _rate(index + 1),
          child: Icon(
            Icons.star,
            size: widget.size,
            color: index < _selectedRating ? widget.filledColor : widget.unfilledColor,
          ),
        );
      }),
    );
  }
}
