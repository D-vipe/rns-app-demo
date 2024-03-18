import 'package:flutter/material.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';

class Coexecutor {
  final SelectObject? data;
  final AnimationController animationController;
  final bool showed;

  Coexecutor({
    required this.data,
    required this.animationController,
    required this.showed,
  });

  Coexecutor copyWith({required bool showed, required SelectObject? data}) => Coexecutor(
        data: data,
        animationController: animationController,
        showed: showed,
      );
}
