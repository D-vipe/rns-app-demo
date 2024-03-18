import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/resources/resources.dart';

class ListRow extends StatelessWidget {
  const ListRow({
    super.key,
    required this.selected,
    required this.title,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: SvgPicture.asset(
                key: ValueKey<bool>(selected),
                selected ? AppIcons.radioButtonChecked : AppIcons.radioButtonUnchecked,
                width: 24.0,
                height: 24.0,
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Text(
                title,
                style: context.textStyles.header3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
