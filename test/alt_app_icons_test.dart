import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rns_app/resources/resources.dart';

void main() {
  test('alt_app_icons assets test', () {
    expect(File(AltAppIcons.bookmarksAlt).existsSync(), isTrue);
    expect(File(AltAppIcons.dateRange).existsSync(), isTrue);
    expect(File(AltAppIcons.emailAlt).existsSync(), isTrue);
    expect(File(AltAppIcons.flashOn).existsSync(), isTrue);
    expect(File(AltAppIcons.homeAlt).existsSync(), isTrue);
    expect(File(AltAppIcons.insertDriveFile).existsSync(), isTrue);
    expect(File(AltAppIcons.layers).existsSync(), isTrue);
    expect(File(AltAppIcons.moveToInbox).existsSync(), isTrue);
    expect(File(AltAppIcons.queryBuilderAlt).existsSync(), isTrue);
    expect(File(AltAppIcons.questionAnswer).existsSync(), isTrue);
    expect(File(AltAppIcons.settings).existsSync(), isTrue);
    expect(File(AltAppIcons.supervisedUserCircle).existsSync(), isTrue);
  });
}
