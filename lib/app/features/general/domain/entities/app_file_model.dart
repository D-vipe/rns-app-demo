class AppFile {
  final int id;
  final String title;
  final String size;
  final String url;
  final String description;
  final String author;
  final String fileType;
  final String dateCreate;
  final String? icon;
  final bool saving;
  final bool downloaded;
  final String downloadProgress;

  const AppFile({
    required this.id,
    required this.title,
    required this.size,
    required this.url,
    required this.description,
    required this.author,
    required this.fileType,
    required this.dateCreate,
    this.icon,
    this.saving = false,
    this.downloaded = false,
    this.downloadProgress = '0',
  });

  AppFile copyWith({
    String? title,
    String? iconPath,
    bool? saving,
    bool? downloaded,
    String? downloadProgress,
  }) =>
      AppFile(
        id: id,
        title: title ?? this.title,
        size: size,
        url: url,
        description: description,
        author: author,
        fileType: fileType,
        dateCreate: dateCreate,
        icon: iconPath ?? icon,
        saving: saving ?? this.saving,
        downloaded: downloaded ?? this.downloaded,
        downloadProgress: downloadProgress ?? this.downloadProgress,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppFile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          size == other.size &&
          url == other.url &&
          description == other.description &&
          author == other.author &&
          fileType == other.fileType &&
          icon == other.icon &&
          saving == other.saving &&
          downloaded == other.downloaded &&
          downloadProgress == other.downloadProgress &&
          dateCreate == other.dateCreate;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      size.hashCode ^
      url.hashCode ^
      description.hashCode ^
      author.hashCode ^
      fileType.hashCode ^
      icon.hashCode ^
      saving.hashCode ^
      downloaded.hashCode ^
      downloadProgress.hashCode ^
      dateCreate.hashCode;
}
