import 'package:flutter/material.dart';

class BatchSlidingWidget extends StatelessWidget {
  final Widget child;
  final bool batchMode;
  final bool selected;
  final Function onChange;
  const BatchSlidingWidget({
    super.key,
    required this.child,
    required this.batchMode,
    required this.selected,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          child: Container(
            margin: EdgeInsets.only(right: batchMode ? 10.0 : 0.0),
            width: batchMode ? 50 : 0,
            child: AnimatedOpacity(
              opacity: batchMode ? 1 : 0,
              duration: const Duration(milliseconds: 400),
              child: Checkbox(
                  value: selected,
                  onChanged: (bool? value) {
                    onChange();
                  }),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          child: SizedBox(
            width: batchMode ? MediaQuery.of(context).size.width - 60 : MediaQuery.of(context).size.width,
            child: child,
          ),
        ),
      ],
    );
  }
}
