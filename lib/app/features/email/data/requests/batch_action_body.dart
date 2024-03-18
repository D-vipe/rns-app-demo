class BatchActionBody {
  final List<int> ids;

  const BatchActionBody({required this.ids});

  Map<String, dynamic> toJson() => {'ids': ids};
}
