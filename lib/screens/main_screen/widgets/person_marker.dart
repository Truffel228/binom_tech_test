import 'dart:math';

import 'package:binom_tech_test/core/constants.dart';
import 'package:binom_tech_test/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';

class PersonMarker extends StatelessWidget {
  const PersonMarker({
    super.key,
    required this.person,
    required this.selected,
    required this.onTap,
  });
  final Person person;
  final bool selected;
  final void Function(Person) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(person),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: const Offset(0, 5.5),
              child: Transform.rotate(
                angle: pi / 4,
                child: AnimatedContainer(
                  duration: Constants.markerAnimationDuration,
                  color:
                      selected ? Theme.of(context).primaryColor : Colors.white,
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Constants.markerAnimationDuration,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? Theme.of(context).primaryColor : Colors.white,
            ),
            padding: const EdgeInsets.all(4),
            width: 50,
            height: 50,
            child: ClipOval(
              child: Image.network(
                person.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
