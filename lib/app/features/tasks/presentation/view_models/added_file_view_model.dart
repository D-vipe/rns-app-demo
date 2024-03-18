import 'package:flutter/material.dart';
import 'package:rns_app/app/features/general/domain/entities/selected_file_model.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';

class AddedFileViewModel {
  final int? id;
  final SelectedFile item;
  final SelectObject? fileType;
  final TextEditingController commentController;
  final FocusNode focusNode;
  final AnimationController animationController;
  final String? error;
  final bool showed;

  const AddedFileViewModel({
    this.id,
    required this.item,
    required this.fileType,
    required this.commentController,
    required this.focusNode,
    required this.animationController,
    required this.error,
    required this.showed,
  });

  AddedFileViewModel copyWith({required SelectObject? fileType, bool? showed, required String? error}) =>
      AddedFileViewModel(
        item: item,
        fileType: fileType,
        commentController: commentController,
        focusNode: focusNode,
        animationController: animationController,
        error: error,
        showed: showed ?? this.showed,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddedFileViewModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          item == other.item &&
          fileType == other.fileType &&
          focusNode == other.focusNode &&
          error == other.error &&
          animationController == other.animationController &&
          showed == other.showed;

  @override
  int get hashCode =>
      id.hashCode ^
      item.hashCode ^
      fileType.hashCode ^
      animationController.hashCode ^
      focusNode.hashCode ^
      error.hashCode ^
      showed.hashCode;
}
