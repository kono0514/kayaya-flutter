class CountryCode {
  final String name;
  final String countryCode;
  final String dialCode;

  String get dialCodeFull => '+$dialCode';

  CountryCode(this.name, this.countryCode, this.dialCode);

  CountryCode.fromJson(Map<String, dynamic> json)
      : name = json['Name'] as String,
        countryCode = json['ISO'] as String,
        dialCode = json['Code'] as String;
}
