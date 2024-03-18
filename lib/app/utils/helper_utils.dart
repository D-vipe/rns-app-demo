import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:rns_app/app/features/general/domain/entities/enum_importance.dart';
import 'package:rns_app/app/utils/extensions.dart';
import 'package:rns_app/app/utils/snackbar_service.dart';
import 'package:rns_app/resources/resources.dart';
import 'package:url_launcher/url_launcher.dart';

class HelperUtils {
  static LinearGradient getShimmerGradient() {
    return const LinearGradient(
      colors: [
        Color(0xFFEBEBF4),
        Color(0xFFF4F4F4),
        Color(0xFFEBEBF4),
      ],
      stops: [
        0.1,
        0.3,
        0.4,
      ],
      begin: Alignment(-1.0, -0.3),
      end: Alignment(1.0, 0.3),
      tileMode: TileMode.clamp,
    );
  }

  static bool isRowStart({required int index}) {
    bool res = false;

    if (index != 0) {
      res = ((index) % 3 == 0);
    } else {
      res = true;
    }

    return res;
  }

  static bool isRowEnd({required int index}) {
    bool res = false;

    if (index != 2) {
      res = ((index + 1) % 3 == 0);
    } else {
      res = true;
    }

    return res;
  }

  static String emailDateOrTime(DateTime date, bool? inline) {
    final DateTime now = DateTime.now();
    final DateTime modifiedNow = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final int differenceInDays = date.difference(modifiedNow).inDays;
    if (differenceInDays == 0) {
      return inline == true
          ? '${'title_today'.tr} ${DateFormat('HH:mm').format(date)}'
          : '${'title_today'.tr}\n${DateFormat('HH:mm').format(date)}';
    } else {
      return inline == true
          ? '${DateFormat('dd.MM.yyyy').format(date)} ${DateFormat('HH:mm').format(date)}'
          : '${DateFormat('dd.MM.yyyy').format(date)}\n${DateFormat('HH:mm').format(date)}';
    }
  }

  static String? getFileIconFromNameExtension(String fileName) {
    final List<String> splitTitle = fileName.isNotEmpty ? fileName.split('.') : [];
    String? res;

    if (splitTitle.isNotEmpty) {
      switch (splitTitle.last.trim().toLowerCase()) {
        case 'png':
          res = AppIcons.png;
          break;
        case 'svg':
          res = AppIcons.svgFile;
          break;
        case 'jpg':
        case 'jpeg':
          res = AppIcons.jpgFile;
          break;
        case 'txt':
        case 'rtf':
          res = AppIcons.txt;
          break;
        case 'ppt':
        case 'pptx':
          res = AppIcons.ppt;
          break;
        case 'doc':
        case 'docx':
        case 'odt':
          res = AppIcons.doc;
          break;
        case 'pdf':
          res = AppIcons.pdf;
          break;
        default:
          res = AppIcons.word;
          break;
      }
    }

    return res;
  }

  static Future<String> getFileSize(File file, int decimals) async {
    int bytes = await file.length();
    if (bytes <= 0) return '0 ${'byteSize_b'.tr}';
    final suffixes = ['byteSize_b'.tr, 'byteSize_kb'.tr, 'byteSize_mb'.tr, 'byteSize_gb'.tr, 'byteSize_tb'.tr];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static String shortenFileName(String name) {
    if (name.length > 18) {
      final String firstSubstring = name.substring(0, 8);
      final String secondSubstring = name.substring(name.length - 9, name.length);

      return '$firstSubstring...$secondSubstring';
    } else {
      return name;
    }
  }

  static Color getImportanceColor(BuildContext context, Importance item) {
    switch (item) {
      case Importance.no:
        return context.colors.backgroundPrimary;
      case Importance.low:
        return context.colors.importance.low;
      case Importance.normal:
        return context.colors.importance.normal;
      case Importance.high:
        return context.colors.importance.high;
    }
  }

  static Future<void> openUrlLink(String? url) async {
    if (url != null && url.isNotEmpty) {
      bool urlOpened = false;
      try {
        final Uri _url = Uri.parse(url);
        urlOpened = await launchUrl(_url);
        if (!urlOpened) {
          SnackbarService.error('error_urlLaunch'.tr);
        }
      } catch (e) {
        SnackbarService.error('error_urlException'.tr);
      }
    }
  }

  static void hideBottomSheetActionButton(FocusNode focusNode, RxBool show) {
    if (focusNode.hasFocus) {
      show.value = true;
    } else {
      show.value = false;
    }
  }

  // @data String like '125:00' where hours are before : and minutes - after
  static int? convertStringDurationToMinutes(String data) {
    try {
      if (data.isEmpty) return null;
      final List<String> dataArr = data.split(':');

      final int parseHoursToMinutes = int.parse(dataArr.first) * 60;
      final int parseStringMinutes = int.parse(dataArr.last);

      return (parseHoursToMinutes + parseStringMinutes);
    } catch (_) {
      return null;
    }
  }
}
