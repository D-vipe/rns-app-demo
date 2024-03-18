import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rns_app/resources/resources.dart';

void main() {
  test('app_images assets test', () {
    expect(File(AppImages.birthdayNews).existsSync(), isTrue);
    expect(File(AppImages.map).existsSync(), isTrue);
  });
}
