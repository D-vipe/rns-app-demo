import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/tasks/presentation/view_models/additional_field_view_model.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/utils/extensions.dart';

class DescriptionAdditionalField extends StatelessWidget {
  final AdditionalFieldViewModel viewModel;
  const DescriptionAdditionalField({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          viewModel.item.name,
          style: context.textStyles.header2,
        ),
        const SizedBox(
          height: 6.0,
        ),
        Obx(
          () => AppTextField(
            hintText: 'tasks_placeholder_additionalField'.trParams({'value': viewModel.item.name.toLowerCase()}),
            labelText: viewModel.item.name,
            textEditingController: viewModel.controller,
            focusNode: viewModel.focusNode,
            errorMessage: viewModel.error.value,
            fieldError: viewModel.error.value != null,
            maxLines: 1,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
      ],
    );
  }
}
