import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:rns_app/app/uikit/app_button.dart';
import 'package:rns_app/app/uikit/form_widgets/app_textfield.dart';
import 'package:rns_app/app/utils/extensions.dart';

class AuthFormWidget extends GetView<AuthController> {
  const AuthFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IgnorePointer(
        ignoring: controller.processingForm.value,
        child: Column(
          children: [
            AppTextField(
              isPasswordField: false,
              hintText: 'auth_enterLogin'.tr,
              labelText: 'auth_login'.tr,
              textEditingController: controller.login,
              focusNode: controller.loginFN,
              errorMessage: controller.loginError.value,
              enabled: true,
              fieldError: controller.loginError.value.isNotEmpty,
              actionFun: null,
            ),
            const SizedBox(
              height: 10.0,
            ),
            AppTextField(
              isPasswordField: true,
              hintText: 'auth_enterPassword'.tr,
              labelText: 'auth_password'.tr,
              textEditingController: controller.password,
              focusNode: controller.passwordFN,
              errorMessage: controller.passwordError.value,
              enabled: true,
              fieldError: controller.passwordError.value.isNotEmpty,
              actionFun: null,
            ),
            const SizedBox(
              height: 10.0,
            ),
            AppButton(
              label: 'button_login'.tr,
              onTap: controller.processAuth,
              processing: controller.processingForm.value,
            ),
            AnimatedOpacity(
              opacity: controller.generalError.value != '' ? 1 : 0,
              duration: const Duration(milliseconds: 400),
              child: Text(
                controller.generalError.value,
                style: context.textStyles.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
