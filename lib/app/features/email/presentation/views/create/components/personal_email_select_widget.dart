import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_create_controller.dart';
import 'package:rns_app/app/uikit/form_widgets/select/components/select_list_row.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class PersonalEmailselectWidget extends GetView<EmailCreateController> {
  const PersonalEmailselectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding, vertical: 16.0),
      decoration: BoxDecoration(
        color: context.colors.backgroundPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'messages_title_personalMailBox'.tr.toUpperCase(),
            style: context.textStyles.header2,
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.only(bottom: 25.0),
                itemCount: controller.personalMailBoxes.length,
                itemBuilder: (context, index) {
                  Animation<Offset> itemAnimation = Tween<Offset>(
                    begin: Offset(-1.0 * (index + 1), 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(
                    CurvedAnimation(
                      parent: controller.bottomSheetListAnimation,
                      curve: Curves.fastEaseInToSlowEaseOut,
                    ),
                  );
                  return SlideTransition(
                    position: itemAnimation,
                    child: ListRow(
                      selected: controller.personalMailBoxes[index] == controller.selectedMailBox.value,
                      onTap: () => controller.changePersonalMailBox(controller.personalMailBoxes[index]),
                      title: controller.personalMailBoxes[index].title,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
