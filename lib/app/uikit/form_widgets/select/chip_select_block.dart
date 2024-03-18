import 'package:flutter/material.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/utils/extensions.dart';

class ChipSelectBlock extends StatelessWidget {
  const ChipSelectBlock({
    super.key,
    required this.label,
    required this.list,
    required this.multipleSelect,
    required this.selectedValue,
    required this.onTap,
    this.selectedValues,
    this.animationController,
    this.loading,
  });

  final String label;
  final List<SelectObject> list;
  final bool multipleSelect;
  final SelectObject? selectedValue;
  final List<SelectObject>? selectedValues;
  final void Function(SelectObject? value) onTap;
  final bool? loading;
  final AnimationController? animationController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.header2,
        ),
        const SizedBox(
          height: 6.0,
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: loading == true
              ? const Loader(
                  size: 15,
                  btn: true,
                )
              : Wrap(
                  children: List.generate(
                    list.length,
                    (index) {
                      Animation<Offset>? itemAnimation;
                      if (animationController != null) {
                        itemAnimation = Tween<Offset>(
                          begin: Offset(-1.0 * (index + 1), 1.0 * (index + 1.5)),
                          end: const Offset(0.0, 0.0),
                        ).animate(
                          CurvedAnimation(
                            parent: animationController!,
                            curve: Curves.fastEaseInToSlowEaseOut,
                          ),
                        );
                      }

                      return animationController != null
                          ? SlideTransition(
                              position: itemAnimation!,
                              child: InkWell(
                                onTap: () => onTap(list[index]),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 6.0, bottom: 0.0),
                                  child: _ChipButton(
                                    item: list[index],
                                    index: index,
                                    multipleSelect: multipleSelect,
                                    selectedValue: selectedValue,
                                    selectedValues: selectedValues,
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () => onTap(list[index]),
                              child: Container(
                                margin: const EdgeInsets.only(right: 6.0, bottom: 0.0),
                                child: _ChipButton(
                                  item: list[index],
                                  index: index,
                                  multipleSelect: multipleSelect,
                                  selectedValue: selectedValue,
                                  selectedValues: selectedValues,
                                ),
                              ),
                            );
                    },
                  ),
                ),
        )
      ],
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
    required this.item,
    required this.index,
    required this.multipleSelect,
    required this.selectedValue,
    required this.selectedValues,
  });

  final SelectObject item;
  final int index;
  final bool multipleSelect;
  final SelectObject? selectedValue;
  final List<SelectObject>? selectedValues;

  @override
  Widget build(BuildContext context) {
    bool selected = false;
    if (multipleSelect) {
      selected = selectedValues?.contains(item) ?? false;
    } else {
      selected = selectedValue == item;
    }

    return Chip(
      backgroundColor: selected ? context.colors.background : context.colors.inputBackground,
      padding: const EdgeInsets.all(6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      side: BorderSide.none,
      label: Text(
        item.title,
        style: context.textStyles.body
            .copyWith(color: selected ? context.colors.backgroundPrimary : context.colors.black.withOpacity(.6)),
      ),
    );
  }
}
