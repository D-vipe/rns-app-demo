import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/features/email/presentation/controllers/email_detail_controller.dart';
import 'package:rns_app/app/features/general/presentation/views/components/importance_widget.dart';
import 'package:rns_app/app/features/email/presentation/views/detail/components/attachments_widget.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/uikit/empty_data_widget.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/helper_utils.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class EmailDetailView extends GetView<EmailDetailController> {
  const EmailDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // без этого цвета page transition выглядит немного коряво
      color: context.colors.backgroundPrimary,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding, vertical: 24.0),
      child: Obx(
        () => controller.loadingData.value
            ? const Loader()
            : controller.loadingError.value
                ? Center(
                    child: Text(
                      controller.errorMessage,
                      style: context.textStyles.bodyBold,
                    ),
                  )
                : controller.data.value == null
                    ? EmptyDataWidget(
                        message: 'messages_emptyDataEmail'.tr,
                      )
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  HelperUtils.emailDateOrTime(controller.data.value!.dateCreate, true),
                                  style: context.textStyles.subtitleSmall,
                                ),
                                Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                                  Text(
                                    'messages_title_importance'.tr,
                                    style: context.textStyles.subtitleSmall,
                                  ),
                                  const SizedBox(width: 5.0),
                                  ImportanceWidget(
                                    importance: controller.data.value!.importance,
                                  )
                                ])
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Text(
                              controller.data.value!.from,
                              style: context.textStyles.header2,
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              controller.data.value!.to,
                              style: context.textStyles.header2,
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              controller.data.value!.title,
                              style: context.textStyles.header2,
                            ),
                            const SizedBox(height: 12.0),
                            if (controller.data.value?.fileData != null && controller.data.value!.fileData.isNotEmpty)
                              AttachmentsWidget(
                                attachments: controller.attachments,
                              ),
                            const SizedBox(height: 12.0),
                            Obx(
                              () => AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                height: controller.webViewHeight.value,
                                child: InAppWebView(
                                  initialData: InAppWebViewInitialData(data: controller.data.value?.body ?? ''),
                                  initialSettings: InAppWebViewSettings(
                                    supportZoom: false,
                                    javaScriptEnabled: true,
                                    disableHorizontalScroll: false,
                                    disableVerticalScroll: false,
                                    useShouldOverrideUrlLoading: true,
                                    useWideViewPort: false,
                                    forceDark: ForceDark.ON,
                                    forceDarkStrategy: ForceDarkStrategy.USER_AGENT_DARKENING_ONLY,
                                  ),
                                  onContentSizeChanged: GetPlatform.isIOS ? controller.webViewSizeChanged : null,
                                  onReceivedError: (_controller, url, message) =>
                                      print('onLoadError: $url, $url, $message'),
                                  onReceivedHttpError: (_controller, url, description) =>
                                      print('onLoadHttpError: $url, $description'),
                                  onProgressChanged: controller.onLoadProgress,
                                  shouldOverrideUrlLoading: controller.overrideUrlLoading,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}
