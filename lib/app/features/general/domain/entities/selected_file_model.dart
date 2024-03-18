import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

class SelectedFile {
  final File? pickedFile;
  final AssetEntity? pickedPhoto;
  final String fileName;
  final String? fileSize;

  const SelectedFile({
    required this.fileName,
    required this.pickedFile,
    required this.pickedPhoto,
    this.fileSize,
  });

  SelectedFile updateSize(String? size) =>
      SelectedFile(fileName: fileName, pickedFile: pickedFile, pickedPhoto: pickedPhoto, fileSize: size ?? fileSize);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedFile &&
          runtimeType == other.runtimeType &&
          pickedFile == other.pickedFile &&
          fileName == other.fileName &&
          pickedPhoto == other.pickedPhoto;

  @override
  int get hashCode => pickedFile.hashCode ^ fileName.hashCode ^ pickedPhoto.hashCode;
}
