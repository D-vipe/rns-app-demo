import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rns_app/app/features/general/presentation/controllers/media_gallery_controller.dart';
import 'package:rns_app/app/features/general/presentation/views/components/image_item_widget.dart';
import 'package:rns_app/app/uikit/shimmer_loading/shimmer_general.dart';
import 'package:rns_app/app/uikit/shimmer_loading/shimmer_loader.dart';
import 'package:rns_app/app/utils/helper_utils.dart';
import 'package:rns_app/configs/theme/app_decorations.dart';

class CustomMediaGallery extends GetView<MediaGalleryController> {
  const CustomMediaGallery({
    super.key,
    required this.onSelect,
  });

  final void Function(AssetEntity entity) onSelect;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      linearGradient: HelperUtils.getShimmerGradient(),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        child: SizedBox(
          height: Get.height - 102,
          child: Obx(
            () => ShimmerLoading(
              isLoading: controller.isLoading.value,
              child: !controller.permissionGranted.value
                  ? Center(
                      child: Transform.translate(
                        offset: const Offset(0.0, -80.0),
                        child: TextButton(
                            child: Text('button_phoneSettings'.tr), onPressed: () => PhotoManager.openSetting()),
                      ),
                    )
                  : controller.isLoading.value
                      ? GridView(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          children: List.generate(
                            25,
                            (index) => Container(
                              margin: const EdgeInsets.all(12.0),
                              decoration: AppDecorations.boxShadowDecoration(context),
                            ),
                          ),
                        )
                      : controller.entities.isEmpty
                          ? Center(
                              child: Transform.translate(
                                offset: const Offset(0.0, -80.0),
                                child: Text('mediaGallery_error_notFound'.tr),
                              ),
                            )
                          : GridView.custom(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              childrenDelegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  if (index == controller.entities.length - 8 &&
                                      !controller.isLoadingMore.value &&
                                      controller.hasMoreToLoad.value) {
                                    controller.loadMoreAsset();
                                  }
                                  final AssetEntity entity = controller.entities[index];
                                  return ImageItemWidget(
                                    key: ValueKey<int>(index),
                                    entity: entity,
                                    option: const ThumbnailOption(size: ThumbnailSize.square(200)),
                                    onTap: onSelect,
                                    rowStart: HelperUtils.isRowStart(index: index),
                                    rowEnd: HelperUtils.isRowEnd(index: index),
                                  );
                                },
                                childCount:
                                    !controller.isLoading.value ? controller.entities.length : controller.sizePerPage,
                                findChildIndexCallback: (Key key) {
                                  // Re-use elements.
                                  if (key is ValueKey<int>) {
                                    return key.value;
                                  }
                                  return null;
                                },
                              ),
                            ),
            ),
          ),
        ),
      ),
    );
  }
}
