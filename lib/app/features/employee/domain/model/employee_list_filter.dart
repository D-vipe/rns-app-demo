class EmployeeListFilter {
  final String? fio;
  final int numPage;
  final int pageSize;

  const EmployeeListFilter({required this.numPage, required this.pageSize, required this.fio});

  Map<String, dynamic> toJson() => {
        if (fio != null) 'fio': fio,
        'numPage': numPage,
        'pageSize': pageSize,
      };
}
