import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rns_app/app/features/general/presentation/views/custom_media_gallery.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/resources/resources.dart';

class MediaGalleryBottomSheet extends StatelessWidget {
  final void Function()? closeHandler;
  final void Function(AssetEntity entity) onSelect;

  const MediaGalleryBottomSheet({
    super.key,
    this.closeHandler,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 45.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.colors.backgroundPrimary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36.0),
                topRight: Radius.circular(36.0),
              ),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 56,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 16.0,
                        left: 16.0,
                        child: GestureDetector(
                          onTap: () => closeHandler != null ? closeHandler!() : Get.back(),
                          child: SvgPicture.asset(AppIcons.clear),
                        ),
                      ),
                      Center(
                        child: Text(
                          'mediaGallery_title'.tr,
                          style: context.textStyles.header1,
                        ),
                      ),
                      Positioned(
                        top: 4.0,
                        right: 10.0,
                        child: TextButton(
                          onPressed: () => Get.back(result: true),
                          child: Text(
                            'button_apply'.tr,
                            style: context.textStyles.header2.copyWith(color: context.colors.buttonActive),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: CustomMediaGallery(
                    onSelect: onSelect,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
