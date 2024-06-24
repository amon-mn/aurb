class Location {
  String? endereco;
  String? foto;
  double latitude;
  double longitude;

  Location({
    this.endereco,
    this.foto,
    required this.latitude,
    required this.longitude,
  });

  Location.fromMap(Map<String, dynamic> map)
      : endereco = map["endereco"],
        foto = map["foto"],
        latitude = map["latitude"].toDouble(),
        longitude = map["longitude"].toDouble();

  Map<String, dynamic> toMap() {
    return {
      "endereco": endereco,
      "foto": foto ?? "",
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
