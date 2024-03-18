import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/home/presentation/controllers/home_controller.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:rns_app/app/uikit/general_models/select_types.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/resources/resources.dart';

class AppSelectButton extends GetView<HomeController> {
  final SelectObject? selectedVal;
  final List<SelectObject> items;
  final String hint;
  final Function? resetError;
  final void Function(SelectObject? value, SelectType type) onChange;
  final bool? search;
  final TextEditingController searchController;
  final bool? processing;
  final SelectType selectType;
  final void Function()? reset;
  const AppSelectButton({
    Key? key,
    required this.selectedVal,
    required this.items,
    required this.hint,
    this.resetError,
    required this.onChange,
    this.search,
    required this.searchController,
    this.processing,
    required this.selectType,
    required this.reset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Используем Listner для того, чтобы убрать любой фокус с возможных полей
    // В противном случае, происходят накладки в показе drop down элемента с
    // открытой клавиатурой
    return Listener(
      onPointerDown: (_) => FocusScope.of(context).unfocus(),
      child: IgnorePointer(
        ignoring: processing ?? false,
        child: DropdownButton2<SelectObject>(
          isExpanded: true,
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              searchController.clear();
            }
          },
          iconStyleData: IconStyleData(
            icon: (reset != null && selectedVal != null)
                ? GestureDetector(
                    onTap: reset,
                    child: SvgPicture.asset(AppIcons.clear),
                  )
                : SvgPicture.asset(AppIcons.expandMore),
          ),
          buttonStyleData: ButtonStyleData(
            height: 56,
            padding: const EdgeInsets.fromLTRB(4.0, 16.0, 12.0, 16.0),
            decoration: BoxDecoration(
              color: context.colors.inputBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
            ),
          ),
          style: context.textStyles.header2,
          isDense: true,
          dropdownStyleData: DropdownStyleData(
            useRootNavigator: false,
            maxHeight: Get.height / 2,
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
            openInterval: const Interval(0.25, 0.25),
          ),
          menuItemStyleData: const MenuItemStyleData(height: 58.0),
          underline: Container(
            height: 1.0,
            color: context.colors.background,
          ),
          hint: Row(
            children: [
              Expanded(
                child: processing == true
                    ? Loader(
                        btn: true,
                        size: 15,
                        color: items.isEmpty ? context.colors.main : context.colors.backgroundPrimary,
                      )
                    : Text(
                        hint,
                        style: context.textStyles.header3.copyWith(color: context.colors.background),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
              ),
            ],
          ),
          selectedItemBuilder: (context) {
            return items.map((item) {
              return Text(
                item == selectedVal ? item.title : hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            }).toList();
          },
          items: items
              .map(
                (item) => DropdownMenuItem<SelectObject>(
                  value: item,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedOpacity(
                            opacity: item == selectedVal ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Transform.translate(
                              offset: const Offset(0.0, 2.0),
                              child: SvgPicture.asset(
                                AppIcons.point,
                                width: 6.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text(
                              item.title,
                              style: context.textStyles.body,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          value: selectedVal,
          onChanged: (value) => onChange(value, selectType),
        ),
      ),
    );
  }
}
