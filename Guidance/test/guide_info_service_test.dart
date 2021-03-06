// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:guidance/src/utils/test_mocks/mock_guide_info_service.dart';

void main() async {
  var guideservice = MGuideInfoService();

  test('guide_info_service | createGuideInfo & getGuideInfo tests if Guide Service be able to create info for guide and be able to retrieve Guide info by id',
      () async {
    await guideservice
        .createGuideInfo("ahmet", "demir", "1", "Student", ["Develop", "Test"]);
    var user = await guideservice.getGuideInfo("1");
    expect(user.userId, "1");
    await guideservice
        .createGuideInfo("enver", "usta", "2", "Student", ["Develop", "Test"]);
  });

  test('guide_info_service | getGuideInfos tests if Guide Service be able to query all guide infos', () async {
    var users = await guideservice.getGuideInfos();
    expect(users.length, 2);
  });

  test('guide_info_service | deleteGuideInfo tests if guide service be able to delete guide by id', () async {
    await guideservice.deleteGuideInfo("1");
    var users = await guideservice.getGuideInfos();
    expect(users.length, 1);
  });
}
