class Places {
  final String name;
  final String formatted_address;
  final String photos_reference;

  Places(
      {required this.name,
      required this.formatted_address,
      required this.photos_reference});

  factory Places.fromJson(Map<String, dynamic> json) {
    return Places(
        name: json['name'] as String,
        formatted_address: json['formatted_address'] as String,
        photos_reference: json['photos_reference'] as String);
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        'formatted_address': formatted_address,
        'photos_reference': photos_reference,
      };

  @override
  String toString() {
    return 'Places{name : $name, formatted_address: $formatted_address,photos_reference: $photos_reference}';
  }
}
