extension FarsiNumberExtension on String {
  String get farsiNumber {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    String text = this;
    for (var i = 0; i < english.length; i++) {
      text = text.replaceAll(english[i], farsi[i]);
    }
    return text;
  }
}
