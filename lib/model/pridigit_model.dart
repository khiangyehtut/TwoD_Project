class PreDigit {
  final String key;
  final int value;

  PreDigit({required this.key, required this.value});

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };

  factory PreDigit.fromJson(Map<String, dynamic> json) {
    return PreDigit(
      key: json['key'],
      value: json['value'],
    );
  }
}
