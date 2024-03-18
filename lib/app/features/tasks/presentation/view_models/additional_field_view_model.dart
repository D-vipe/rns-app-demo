import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:rns_app/app/features/tasks/domain/models/task_additional_field.dart';

class AdditionalFieldViewModel {
  final TaskAdditionalField item;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Rxn<String> error;

  const AdditionalFieldViewModel({
    required this.item,
    required this.controller,
    required this.focusNode,
    required this.error,
  });
}
