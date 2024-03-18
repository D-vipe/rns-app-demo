import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:rns_app/app/features/general/presentation/controllers/media_gallery_controller.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/theme/app_decorations.dart';

class ImageItemWidget extends GetView<MediaGalleryController> {
  const ImageItemWidget({
    Key? key,
    required this.entity,
    required this.option,
    this.onTap,
    required this.rowStart,
    required this.rowEnd,
  }) : super(key: key);

  final AssetEntity entity;
  final ThumbnailOption option;
  final Function(AssetEntity entity)? onTap;
  final bool rowStart;
  final bool rowEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        controller.onImageTap(entity);
        if (onTap != null) {
          onTap!(entity);
        }
      },
      child: Obx(
        () => Container(
          margin: EdgeInsets.only(left: rowStart ? 12.0 : 6.0, right: rowEnd ? 12.0 : 6.0, top: 6.0, bottom: 6.0),
          decoration: AppDecorations.boxShadowDecoration(context),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned.fill(
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  child: AssetEntityImage(
                    entity,
                    isOriginal: false,
                    thumbnailSize: option.size,
                    thumbnailFormat: option.format,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (controller.chosenEntities.contains(entity))
                PositionedDirectional(
                  bottom: -8,
                  end: -8,
                  child: Container(
                    width: 33.0,
                    height: 33.0,
                    decoration: AppDecorations.doneIcon(context),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.check,
                      color: context.colors.buttonActive,
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
