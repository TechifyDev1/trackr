extension CapitalizeWord on String {
  String capitalize() {
    String capitilizedFirstLetter = this[0].toUpperCase();
    String restOftheWords = substring(1);
    return capitilizedFirstLetter + restOftheWords;
  }
}
