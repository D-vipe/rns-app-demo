import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/app_theme.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.isPasswordField = false,
    this.focusNode,
    this.textEditingController,
    this.onSubmitted,
    this.fieldError = false,
    this.errorMessage,
    this.onTap,
    this.autofocus,
    this.enabled,
    this.readOnly = false,
    this.keyboardType,
    this.actionButton,
    this.actionFun,
    this.inputFormatters,
    this.maxLines,
    this.expands,
  }) : super(key: key);

  final String? labelText;
  final String? hintText;
  final bool isPasswordField;
  final FocusNode? focusNode;
  final TextEditingController? textEditingController;
  final void Function(String)? onSubmitted;
  final String? errorMessage;
  final void Function()? onTap;
  final bool? autofocus;
  final bool? enabled;
  final bool readOnly;
  final bool fieldError;
  final TextInputType? keyboardType;
  final Widget? actionButton;
  final void Function()? actionFun;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool? expands;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool hidePassword = true;
  FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    focusNode = widget.focusNode ?? FocusNode();

    // ? для чего было это сделано
    // focusNode!.addListener(() {
    //   setState(() {});
    // });
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          keyboardAppearance: Get.theme == AppTheme.darkTheme() ? Brightness.dark : Brightness.light,
          // contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
          //   return AdaptiveTextSelectionToolbar(
          //     anchors: editableTextState.contextMenuAnchors,
          //     children: editableTextState.contextMenuButtonItems
          //         .map((ContextMenuButtonItem buttonItem) {
          //           return Container(
          //             color: context.colors.inputBackground,
          //             child: ElevatedButton(
          //               onPressed: buttonItem.onPressed,
          //               child: Text(
          //                 LocalizeTooltips.getBtnLbl(buttonItem),
          //                 style: Theme.of(context).textTheme.bodyMedium,
          //                 softWrap: false,
          //               ),
          //             ),
          //           );
          //         })
          //         .toList()
          //         .cast<Widget>(),
          //   );
          // },
          maxLines: widget.maxLines ?? ((widget.expands == true) ? null : 1),
          expands: widget.expands ?? false,
          inputFormatters: [...?widget.inputFormatters],
          cursorColor: context.colors.text.main,
          cursorWidth: 2.5,
          keyboardType: widget.keyboardType,
          autofocus: widget.autofocus ?? false,
          focusNode: focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          controller: widget.textEditingController,
          onSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16.0,
                height: 1.1,
                color: widget.errorMessage == null || widget.errorMessage!.isEmpty
                    ? context.colors.text.main
                    : context.colors.error,
              ),
          obscureText: widget.isPasswordField ? hidePassword : false,
          obscuringCharacter: '*',
          cursorHeight: 16.0,
          decoration: InputDecoration(
            isDense: true,
            labelText: widget.labelText,
            hintText: widget.hintText,
            suffixIcon: (widget.isPasswordField == false && widget.actionButton == null)
                ? null
                : Padding(
                    padding: const EdgeInsets.only(
                      right: 0,
                    ),
                    child: widget.isPasswordField
                        ? IconButton(
                            icon: Icon(
                              hidePassword ? Icons.visibility_off : Icons.visibility,
                              color: context.colors.main,
                            ),
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                          )
                        : widget.actionButton != null
                            ? IconButton(
                                icon: widget.actionButton!,
                                onPressed: widget.actionFun,
                              )
                            : null,
                  ),
          ),
        ),
        AnimatedOpacity(
          opacity: widget.fieldError ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Text(
            widget.errorMessage ?? '',
            style: context.textStyles.error.copyWith(
              fontSize: 12.0,
            ),
          ),
        )
      ],
    );
  }
}
