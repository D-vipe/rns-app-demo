import 'package:flutter/material.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/empty_data_widget.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/uikit/form_widgets/select/components/select_list_row.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/app/utils/extensions.dart';

class SingleSelectWidget extends StatelessWidget {
  final String searchTitle;
  final String listTitle;
  final String searchLabel;

  final void Function(bool? value, int index) onChange;

  final TextEditingController searchController;
  final FocusNode? searchFocus;
  final List<SelectObject> items;
  final SelectObject? selectedVal;
  final bool loadingData;
  final String? error;
  final void Function() refresher;
  final AnimationController animationController;
  final bool searching;
  final bool disabled;
  final bool enableSearch;
  final bool removeTopMargin;

  const SingleSelectWidget({
    super.key,
    required this.onChange,
    required this.searchController,
    this.searchFocus,
    required this.items,
    required this.selectedVal,
    required this.loadingData,
    required this.error,
    required this.refresher,
    required this.animationController,
    required this.searching,
    required this.searchTitle,
    required this.listTitle,
    required this.searchLabel,
    required this.disabled,
    this.enableSearch = true,
    this.removeTopMargin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (removeTopMargin == false)
            const SizedBox(
              height: 24.0,
            ),
          if (enableSearch)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  searchTitle,
                  style: context.textStyles.header2,
                ),
                const SizedBox(height: 6.0),
                AppTextField(
                  hintText: searchLabel,
                  labelText: searchLabel,
                  enabled: !disabled,
                  textEditingController: searchController,
                  focusNode: searchFocus,
                ),
                // const SizedBox(height: 24.0),
              ],
            ),
          AnimatedOpacity(
            opacity: error != null ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: Text(
              error ?? '',
              style: context.textStyles.error,
            ),
          ),
          Text(
            listTitle,
            style: context.textStyles.header2,
          ),
          const SizedBox(height: 12.0),
          loadingData || searching
              ? const Expanded(
                  child: Loader(),
                )
              : items.isEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: EmptyDataWidget(
                          message: '',
                          refresh: () => refresher(),
                        ),
                      ),
                    )
                  : Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: disabled
                            ? const SizedBox.shrink()
                            : Scrollbar(
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 25.0),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    Animation<Offset> itemAnimation = Tween<Offset>(
                                      begin: Offset(-1.0 * (index + 1), 0.0),
                                      end: const Offset(0.0, 0.0),
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animationController,
                                        curve: Curves.fastEaseInToSlowEaseOut,
                                      ),
                                    );
                                    return SlideTransition(
                                      position: itemAnimation,
                                      child: ListRow(
                                        selected: items[index] == selectedVal,
                                        onTap: () => onChange(null, index),
                                        title: items[index].title,
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ),
        ],
      ),
    );
  }
}
