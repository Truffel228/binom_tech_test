import 'package:binom_tech_test/core/constants.dart';
import 'package:binom_tech_test/screens/main_screen/widgets/bottom_menu/bottom_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

export 'bottom_menu_controller.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key, required this.controller});
  final BottomMenuController controller;

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sizeController;

  @override
  void initState() {
    super.initState();
    _sizeController = AnimationController(
      vsync: this,
      duration: Constants.markerAnimationDuration,
    );
    widget.controller.addListener(listener);
  }

  void listener() {
    if (widget.controller.isShowed) {
      _sizeController.forward();
    } else {
      _sizeController.reverse();
    }
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final person = widget.controller.person;

    return AnimatedOpacity(
      duration: Constants.markerAnimationDuration,
      opacity: widget.controller.isShowed ? 1 : 0,
      child: SizeTransition(
        sizeFactor: _sizeController,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.17,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        person.imageUrl,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(person.name),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconText(
                              icon: Icons.wifi,
                              text: 'GPS',
                            ),
                            Spacer(),
                            IconText(
                              icon: Icons.calendar_today,
                              text: DateFormat('dd.MM.yyy')
                                  .format(person.birthDateTime),
                            ),
                            Spacer(),
                            IconText(
                              icon: Icons.schedule,
                              text: DateFormat('HH:mm')
                                  .format(person.birthDateTime),
                            ),
                            Spacer(flex: 2),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'Посмотреть историю',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IconText extends StatelessWidget {
  const IconText({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
