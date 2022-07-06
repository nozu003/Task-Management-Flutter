class FieldValidator {
  static String? validateTaskName(String value) {
    if (value.isEmpty) return 'Enter task name!';
    return null;
  }

  static String? validateTaskDescription(String value) {
    if (value.isEmpty) return 'Enter task description!';
    return null;
  }
}
