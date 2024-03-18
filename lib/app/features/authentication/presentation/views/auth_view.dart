import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:rns_app/app/features/authentication/presentation/views/components/form_widget.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';
import 'package:rns_app/resources/resources.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: SvgPicture.asset(AppIcons.logo),
            ),
            const SizedBox(
              height: 55.0,
            ),
            // ! SizedBox необходим для нивелирования "скачака" после замены
            // ! Loader на виджет формы
            Obx(
              () => SizedBox(
                height: 250.0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: controller.isLoading.value
                      ? const Loader(
                          size: 30,
                        )
                      : const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstraints.screenPadding,
                          ),
                          child: AuthFormWidget(),
                        ),
                ),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
