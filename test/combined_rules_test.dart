import 'package:rules/rules.dart';
import 'package:rules/src/group_rule.dart';
import 'package:test/test.dart';

void main() {
  group('CombinedRule', () {
    test('should throw an error', () {
      final rule1 = Rule('', name: 'name', isRequired: true);
      final rule2 = Rule('', name: 'email', isRequired: true);
      final combinedRule = CombinedRule(rules: [rule1, rule2]);

      expect(combinedRule.hasError, equals(true));
      expect(combinedRule.errorList.length, 2);
    });

    test('should throw an error', () {
      final rule1 = Rule(
        '',
        name: 'name',
        isRequired: true,
      );
      final groupRule = GroupRule(
        [rule1],
        name: 'name',
        requiredAll: true,
      );
      final combinedRule = CombinedRule(
        groupRules: [groupRule],
      );

      expect(combinedRule.hasError, equals(true));
      expect(combinedRule.errorList.length, 1);
    });

    test('should throw an error', () {
      final rule1 = Rule('abc', name: 'name', isRequired: false);
      final groupRule = GroupRule([rule1],
          name: 'name', maxAllowed: 0, customErrorText: 'Group error');
      final combinedRule = CombinedRule(groupRules: [groupRule]);

      expect(combinedRule.errorList[0], contains('Group error'));
      expect(combinedRule.hasError, equals(true));
      expect(combinedRule.errorList.length, 1);
    });

    test('should throw an error', () {
      final rule1 = Rule('', name: 'name', isRequired: true);
      final groupRule = GroupRule([rule1],
          name: 'name', maxAllowed: 0, customErrorText: 'Group error');
      final combinedRule = CombinedRule(groupRules: [groupRule]);

      expect(combinedRule.errorList[0], contains('is required'));
      expect(combinedRule.hasError, equals(true));
      expect(combinedRule.errorList.length, 1);
    });

    test('should throw an error', () {
      final rule1 = Rule('', name: 'name', isRequired: true);
      final groupRule = GroupRule([rule1],
          name: 'name', maxAllowed: 0, customErrorText: 'Group error');
      final combinedRule =
          CombinedRule(rules: [rule1], groupRules: [groupRule]);

      expect(combinedRule.errorList[0], contains('is required'));
      expect(combinedRule.errorList[1], contains('is required'));
      expect(combinedRule.hasError, equals(true));
      expect(combinedRule.errorList.length, 2);
    });

    test('should throw an error', () {
      final rule1 = Rule('abc', name: 'name', isRequired: true);
      final groupRule = GroupRule([rule1],
          name: 'name', maxAllowed: 0, customErrorText: 'Group error');
      final combinedRule =
          CombinedRule(rules: [rule1], groupRules: [groupRule]);

      expect(combinedRule.errorList[0], contains('Group error'));
      expect(combinedRule.hasError, equals(true));
      expect(combinedRule.errorList.length, 1);
    });

    test('should throw an error', () {
      final rule1 = Rule('abc', name: 'name', isRequired: true);
      final groupRule1 = GroupRule([rule1],
          name: 'name', maxAllowed: 0, customErrorText: 'Group 1 error');

      final rule2 =
          Rule('abc', name: 'name', isRequired: true, isNumericDecimal: true);
      final rule3 = Rule('', name: 'value');
      final groupRule2 = GroupRule([rule2, rule3],
          name: 'name', requiredAtleast: 2, customErrorText: 'Group 2 error');

      final rule4 =
          Rule('abc', name: 'name', isRequired: true, isNumeric: true);
      final rule5 = Rule('abc', name: 'name', isRequired: true, isEmail: true);

      final combinedRule = CombinedRule(rules: [
        rule4,
        rule5,
      ], groupRules: [
        groupRule1,
        groupRule2,
      ]);

      expect(combinedRule.errorList[0], contains('is not a valid number'));
      expect(
          combinedRule.errorList[1], contains('is not a valid email address'));
      expect(combinedRule.errorList[2], contains('Group 1 error'));
      expect(
          combinedRule.errorList[3], contains('is not a valid decimal number'));
      expect(combinedRule.hasError, equals(true));
      expect(combinedRule.errorList.length, 4);
    });

    test('should NOT throw an error', () {
      final rule1 = Rule('', name: 'name');
      final rule2 = Rule('', name: 'email');
      final combinedRule = CombinedRule(rules: [rule1, rule2]);

      expect(combinedRule.hasError, equals(false));
      expect(combinedRule.errorList.length, 0);
    });

    test('should NOT throw an error', () {
      final groupRule = GroupRule([], name: 'name', requiredAll: true);
      final combinedRule = CombinedRule(groupRules: [groupRule]);

      expect(combinedRule.hasError, equals(false));
      expect(combinedRule.errorList.length, 0);
    });

    test('should NOT throw an error', () {
      final rule1 = Rule('abc', name: 'name', isRequired: true);
      final groupRule1 = GroupRule([rule1],
          name: 'name', maxAllowed: 1, customErrorText: 'Group 1 error');

      final rule2 =
          Rule('1.1', name: 'name', isRequired: true, isNumericDecimal: true);
      final rule3 = Rule('abcd', name: 'value');
      final groupRule2 = GroupRule([rule2, rule3],
          name: 'name', requiredAtleast: 2, customErrorText: 'Group 2 error');

      final rule4 = Rule('10', name: 'name', isRequired: true, isNumeric: true);
      final rule5 =
          Rule('abc@xyz.com', name: 'name', isRequired: true, isEmail: true);

      final combinedRule = CombinedRule(
          rules: [rule4, rule5], groupRules: [groupRule1, groupRule2]);

      expect(combinedRule.hasError, equals(false));
      expect(combinedRule.errorList.length, 0);
    });

    test('should NOT throw an error', () {
      final combinedRule = CombinedRule();

      expect(combinedRule.hasError, equals(false));
      expect(combinedRule.errorList.length, 0);
    });
  });
}
