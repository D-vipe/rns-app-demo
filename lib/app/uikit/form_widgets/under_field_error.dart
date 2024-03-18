import 'package:flutter/material.dart';
import 'package:rns_app/app/utils/extensions.dart';

class UnderFiledError extends StatelessWidget {
  final String? error;
  const UnderFiledError({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: error != null ? 1 : 0,
      duration: const Duration(microseconds: 400),
      child: Text(
        error ?? '',
        style: context.textStyles.error.copyWith(fontSize: 12.0),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
