class FormAnswers {
  Map<String, String> form;

  FormAnswers(this.form);

  FormAnswers.fromMap(Map<String, dynamic> map)
      : form = map.map((key, value) => MapEntry(key, value.toString()));

  Map<String, dynamic> toMap() {
    return form;
  }

  @override
  String toString() {
    return form.toString();
  }
}