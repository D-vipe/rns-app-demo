import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/miscellaneous.dart';

class UploadingTaskFilesSnack extends StatelessWidget {
  final Rx<String> fileName;
  final RxInt progress;
  final RxString uploadCount;
  const UploadingTaskFilesSnack({
    super.key,
    required this.fileName,
    required this.progress,
    required this.uploadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: AppConstraints.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text('Загрузка файлов: ${uploadCount.value}'),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fileName.value),
                  LinearProgressIndicator(
                    minHeight: 5.0,
                    value: progress.value / 100,
                    backgroundColor: Get.context!.colors.background,
                    color: Get.context!.colors.buttonActive,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
