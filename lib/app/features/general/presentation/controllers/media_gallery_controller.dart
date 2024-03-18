import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';

class MediaGalleryController extends GetxController {
  static MediaGalleryController get to => Get.find();
  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
    containsLivePhotos: false,
    imageOption: const FilterOption(
      sizeConstraint: SizeConstraint(ignoreSize: true),
    ),
  );
  final int sizePerPage = 25;

  AssetPathEntity? _path;
  int _totalEntitiesCount = 0;

  int _page = 0;

  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreToLoad = true.obs;
  RxBool permissionGranted = true.obs;

  RxList<AssetEntity> entities = <AssetEntity>[].obs;
  RxList<AssetEntity> chosenEntities = <AssetEntity>[].obs;

  @override
  void onInit() {
    _fetchNewMedia();
    super.onInit();
  }

  _fetchNewMedia() async {
    // Request permissions.
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    // possible odd piece of code

    if (isClosed) {
      return;
    }

    // Further requests can be only proceed with authorized or limited.
    if (!ps.hasAccess) {
      isLoading.value = false;
      permissionGranted.value = false;
      SnackbarService.warning('mediaGallery_error_permission'.tr);
      return;
    }
    // Obtain images using the path entity.
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
      filterOption: _filterOptionGroup,
    );
    if (isClosed) {
      return;
    }
    // Return if not paths found.
    if (paths.isEmpty) {
      isLoading.value = false;
      SnackbarService.warning('mediaGallery_error_notFound'.tr);

      return;
    }
    _path = paths.first;
    _totalEntitiesCount = await _path!.assetCountAsync;
    final List<AssetEntity> fetchedEntities = await _path!.getAssetListPaged(
      page: 0,
      size: sizePerPage,
    );
    if (isClosed) {
      return;
    }
    entities.value = fetchedEntities;
    isLoading.value = false;
    hasMoreToLoad.value = entities.length < _totalEntitiesCount;
  }

  Future<void> loadMoreAsset() async {
    final List<AssetEntity> fetchedEntities = await _path!.getAssetListPaged(
      page: _page + 1,
      size: sizePerPage,
    );
    if (isClosed) {
      return;
    }

    entities.value = [...entities, ...fetchedEntities];
    _page++;
    hasMoreToLoad.value = entities.length < _totalEntitiesCount;
    isLoadingMore.value = false;
  }

  void onImageTap(AssetEntity selectedAsset) {
    if (chosenEntities.isNotEmpty && chosenEntities.contains(selectedAsset)) {
      chosenEntities.removeWhere((element) => element == selectedAsset);
    } else {
      chosenEntities.add(selectedAsset);
    }
    chosenEntities.refresh();
  }

  // bool isAssetSelected({required String assetId}) {
  //   AssetEntity? foundEntity;
  //   bool res = false;
  //   if (chosenEntities.isNotEmpty) {
  //     // trying to find if the asset was selected
  //     foundEntity = chosenEntities.firstWhereOrNull((element) => element.id == assetId);
  //     res = foundEntity != null;
  //   }
  //   return res;
  // }
}
