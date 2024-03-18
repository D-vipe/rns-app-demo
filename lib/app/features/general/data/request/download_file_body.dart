class DownloadFileBody {
  final int id;
  // если есть url, то качаем файл из письма
  final String? url;
  final bool? outgoing;

  const DownloadFileBody({required this.id, this.url, this.outgoing});

  Map<String, dynamic> toJson() => {
        'Id': id,
        'TableName': url != null ? (outgoing == true ? 'EMAIL_OUTGOING' : 'EMAIL_INCOMING') : 'FILES',
        'Num': 0,
      };
}
