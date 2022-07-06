import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'validator/validator.dart';

void main() {
  group('create task', () {
    test('validatedTaskName - Empty Task Name Test - return Enter task name!',
        () {
      //arrange
      //act
      var result = FieldValidator.validateTaskName('');
      //assert
      expect(result, 'Enter task name!');
    });

    test('validatedTaskName - Valid Task Name Test - return null', () {
      //arrange
      //act
      var result = FieldValidator.validateTaskName('Unit testing in Flutter');
      //assert
      expect(result, null);
    });

    test(
        'validatedTaskDescription - Empty Task Name Test - return Enter task description!',
        () {
      //arrange
      //act
      var result = FieldValidator.validateTaskDescription('');
      //assert
      expect(result, 'Enter task description!');
    });

    test('validatedTaskDescription - Valid Task Name Test - return null', () {
      //arrange
      //act
      var result = FieldValidator.validateTaskDescription(
          'Start learning unit testing in Flutter');
      //assert
      expect(result, null);
    });
  });
}
