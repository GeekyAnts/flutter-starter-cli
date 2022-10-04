// ignore_for_file: prefer_const_constructors

import 'package:{{name}}/{{name}}.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UpdateTheme', () {
    test('test value comparisons during light theme', () {
      expect(
        UpdateTheme(appTheme: AppTheme.light),
        UpdateTheme(appTheme: AppTheme.light),
      );
    });

    test('test value comparisons during dark theme', () {
      expect(
        UpdateTheme(appTheme: AppTheme.dark),
        UpdateTheme(appTheme: AppTheme.dark),
      );
    });
  });
}
