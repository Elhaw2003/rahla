import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/core/extensions/num_extension.dart';
import 'package:travel_app/core/extensions/string_extension.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';

void main() {
  group('StringExtension', () {
    test('capitalize', () {
      expect('hello'.capitalize(), 'Hello');
      expect(''.capitalize(), '');
      expect('hELLO'.capitalize(), 'HELLO');
    });

    test('isEmail', () {
      expect('user@example.com'.isEmail(), isTrue);
      expect('invalid-email'.isEmail(), isFalse);
      expect('user@'.isEmail(), isFalse);
    });
  });

  group('NumExtension', () {
    test('creates sized boxes', () {
      expect(12.hSpace, isA<SizedBox>());
      expect((12.hSpace as SizedBox).width, 12);
      expect((12.hSpace as SizedBox).height, isNull);
      expect((12.vSpace as SizedBox).width, isNull);
      expect((12.vSpace as SizedBox).height, 12);
      expect((12.widthBox as SizedBox).width, 12);
      expect((12.widthBox as SizedBox).height, isNull);
      expect((12.heightBox as SizedBox).width, isNull);
      expect((12.heightBox as SizedBox).height, 12);
    });
  });

  group('WidgetExtension', () {
    test('padding wraps the widget', () {
      final result = const Text('Hello').paddingAll(12);

      expect(result, isA<Padding>());
      expect((result as Padding).padding, const EdgeInsets.all(12));
      expect((result).child, isA<Text>());
    });

    test('paddingSymmetric and paddingOnly use the requested values', () {
      final symmetric = const Text(
        'Hello',
      ).paddingSymmetric(horizontal: 10, vertical: 4);
      final only = const Text(
        'Hello',
      ).paddingOnly(left: 1, top: 2, right: 3, bottom: 4);

      expect(
        (symmetric as Padding).padding,
        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      );
      expect(
        (only as Padding).padding,
        const EdgeInsets.only(left: 1, top: 2, right: 3, bottom: 4),
      );
    });

    test('margin, center, and expanded wrap the widget', () {
      final margin = const Text('Hello').margin(const EdgeInsets.all(8));
      final center = const Text('Hello').center();
      final expanded = const Text('Hello').expanded(flex: 2);

      expect(margin, isA<Container>());
      expect((margin as Container).margin, const EdgeInsets.all(8));
      expect(center, isA<Center>());
      expect(expanded, isA<Expanded>());
      expect((expanded as Expanded).flex, 2);
    });
  });
}
