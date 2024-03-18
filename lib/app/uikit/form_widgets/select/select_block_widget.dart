import 'package:flutter/material.dart';
import 'package:rns_app/app/uikit/form_widgets/under_field_error.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/uikit/form_widgets/select/app_select_button.dart';
import 'package:rns_app/app/utils/extensions.dart';

class SelectBlockWidget extends StatelessWidget {
  final String label;
  final String placeholder;
  final List<SelectObject> items;
  final TextEditingController? searchController;
  final SelectObject? selectedVal;
  final SelectType selectType;
  final void Function(SelectObject? value, SelectType type) onChange;
  final String? error;
  final bool processing;
  final void Function()? reset;

  const SelectBlockWidget({
    super.key,
    required this.label,
    required this.placeholder,
    required this.items,
    required this.selectedVal,
    required this.selectType,
    required this.onChange,
    required this.searchController,
    required this.error,
    required this.processing,
    this.reset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: items.isEmpty ? .5 : 1,
          child: Text(
            label,
            style: context.textStyles.header2,
          ),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Opacity(
          opacity: items.isEmpty ? .5 : 1,
          child: AppSelectButton(
            key: ValueKey<String>(selectType.toString()),
            selectedVal: selectedVal,
            items: items,
            hint: placeholder,
            searchController: searchController ?? TextEditingController(),
            onChange: onChange,
            selectType: selectType,
            processing: processing,
            reset: reset,
          ),
        ),
        UnderFiledError(error: error),
      ],
    );
  }
}
