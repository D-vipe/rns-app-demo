import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rns_app/app/features/employee/domain/model/employee_list_item.dart';
import 'package:rns_app/app/uikit/app_loader.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/configs/links_constants.dart';

class EmployeeListItemWidget extends StatelessWidget {
  const EmployeeListItemWidget({
    super.key,
    required this.item,
    required this.last,
  });

  final EmployeeListItem item;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: last ? 0.0 : 8.0),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.contain,
                  imageUrl: item.urlLeftIcon ?? MiscellaneousConstants.noUserUrl,
                  placeholder: (_, __) => Loader(
                    btn: true,
                    size: 15.0,
                    color: context.colors.inputBackground,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error_outline),
                ),
              ),
              if (item.isVisibleRightIcon)
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14.0,
                      height: 14.0,
                      decoration: BoxDecoration(
                        color: context.colors.white,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: Center(
                        child: Container(
                          width: 11.0,
                          height: 11.0,
                          decoration: BoxDecoration(
                            color: context.colors.success,
                            borderRadius: BorderRadius.circular(11.0),
                          ),
                        ),
                      ),
                    ))
            ],
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: context.textStyles.header1,
                ),
                if (item.position != null && item.position!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(item.position!, style: context.textStyles.header2),
                  ),
                if (item.timeWith != null && item.timeWith!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(item.timeWith!, style: context.textStyles.subtitle),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
