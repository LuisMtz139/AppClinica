extension StringCase on String {
  String toPascalCase() {
    if (isEmpty) {
      return '';
    }

    if (!contains(" ")) {
      return this[0].toUpperCase() + toLowerCase().substring(1);
    } else {
      List<String> words = split(' ');
      String result = '';
      for (int i = 0; i < words.length; i++) {
        result += (words[i][0].toUpperCase() + words[i].toLowerCase().substring(1));
        if (i + 1 < words.length) {
          result += ' ';
        }
      }
      return result;
    }
  }
}

extension TrimData on String {
  String trimEqualsData() {
    if (isEmpty) {
      return '';
    }
    return substring(indexOf("=") + 1);
  }
}