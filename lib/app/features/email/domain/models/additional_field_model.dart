import 'package:flutter/animation.dart';
import 'package:rns_app/app/features/email/domain/models/receiver_type_enum.dart';

class AdditionalField {
  final ReceiverType type;
  final AnimationController animationController;
  final bool showed;

  AdditionalField({required this.type, required this.animationController, required this.showed});

  AdditionalField copyWith({required bool showed}) => AdditionalField(
        type: type,
        animationController: animationController,
        showed: showed,
      );
}
