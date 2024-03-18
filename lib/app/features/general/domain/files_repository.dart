import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rns_app/app/dependency/api_module.dart';
import 'package:rns_app/app/features/general/data/converter/select_object_converter.dart';
import 'package:rns_app/app/features/general/data/request/download_file_body.dart';
import 'package:rns_app/app/features/general/domain/entities/app_file_model.dart';
import 'package:rns_app/app/uikit/general_models/select_object_model.dart';
import 'package:rns_app/configs/data/exceptions.dart';

class FilesRepository {
  final _service = ApiModule.filesService();

  Future<Directory> initSaveDir() async {
    late Directory directory;
    bool dirDownloadExists = true;
    if (GetPlatform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download/');

      dirDownloadExists = await directory.exists();
      if (dirDownloadExists) {
        directory = Directory('/storage/emulated/0/Download/');
      } else {
        directory = Directory('/storage/emulated/0/Downloads/');
      }
    }

    return directory;
  }

  Future<bool> checkIfFileSaved({required String fileName, required Directory directory}) async {
    File file = GetPlatform.isIOS ? File('${directory.path}/$fileName') : File('${directory.path}$fileName');
    return await file.exists();
  }

  Future<bool> downloadFile(
      {required AppFile item,
      required Directory directory,
      required RxString progressValue,
      String? url,
      bool? outgoing,
      int? emailId}) async {
    List<int>? fileBytes;
    bool result = false;
    // Модифицировано для вызова как из заданий, так и из писем
    final DownloadFileBody body = DownloadFileBody(
      id: emailId ?? item.id,
      url: url,
    );
    try {
      fileBytes = await _service.downloadFile(body: body, progressValue: progressValue, email: emailId != null);

      if (fileBytes != null) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }

        try {
          // Create the file in the desired location
          // File file = File('${directory.path}/${item.id}_${item.title}');
          File file = File('${directory.path}/${item.title}');

          await file.writeAsBytes(fileBytes).then((value) => result = true);
        } catch (_) {
          rethrow;
        }
      }
    } catch (_) {
      rethrow;
    }

    return result;
  }

  Future<List<SelectObject>> getFileTypes() async {
    List<SelectObject> fileType = [];
    try {
      final rawData = await _service.getFileTypes();

      try {
        fileType = rawData.map((data) => SelectObjectConverter.mapDTO(data)).toList().cast<SelectObject>();
      } catch (_) {
        throw ParseException('error_convertData'.tr);
      }
    } catch (_) {
      rethrow;
    }

    return fileType;
  }

  Future<String?> openFile({required Directory directory, required String fileName}) async {
    OpenResult? res;
    String? infoMessage;
    if (GetPlatform.isIOS) {
      res = await OpenFile.open('${directory.path}/$fileName').then((value) {
        return value;
      });
    } else {
      PermissionStatus storagePermission = await Permission.manageExternalStorage.request();

      if (storagePermission.isRestricted) {
        storagePermission = await Permission.storage.request();
        if (!storagePermission.isGranted) {
          infoMessage = 'Не предоставлены необходимые права, чтобы открыть файл';
        }
      }
      if (storagePermission.isGranted) {
        bool oldFormat = false;

        // Request media / audio permissions here as for Anroid13
        if (GetPlatform.isAndroid) {
          var androidInfo = await DeviceInfoPlugin().androidInfo;
          oldFormat = androidInfo.version.sdkInt < 33;
        }

        if (oldFormat) {
          res = await OpenFile.open('${directory.path}$fileName').then((value) {
            return value;
          });
        } else {
          final photoPermission = await Permission.photos.request();
          final videoPermission = await Permission.videos.request();
          final audioPermission = await Permission.audio.request();

          if ((photoPermission.isGranted || photoPermission.isLimited) &&
              (videoPermission.isGranted || videoPermission.isLimited) &&
              (audioPermission.isGranted || audioPermission.isLimited)) {
            res = await OpenFile.open('${directory.path}$fileName').then((value) {
              return value;
            });
          }
        }
      } else {
        openAppSettings();
      }
    }

    switch (res?.type) {
      case ResultType.done:
        infoMessage = null;
        break;
      case ResultType.error:
        infoMessage = 'fileOpen_error'.tr;
        break;
      case ResultType.fileNotFound:
        infoMessage = 'fileOpen_notFound'.tr;
        break;
      case ResultType.noAppToOpen:
        infoMessage = 'fileOpen_noAppToOpen'.tr;
        break;
      case ResultType.permissionDenied:
        infoMessage = 'fileOpen_permissionDenied'.tr;
        break;
      default:
        infoMessage = 'fileOpen_permissionDenied'.tr;
        break;
    }

    return infoMessage;
  }
}
