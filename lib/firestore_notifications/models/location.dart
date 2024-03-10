class Location {
  String endereco;
  String? foto;
  double latitude;
  double longitude;

  Location({
    required this.endereco,
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
/*
  

  ProductBatch.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        nomeLote = map['nomeLote'],
        largura = map["largura"],
        comprimento = map["comprimento"],
        area = map["area"],
        latitude = map["latitude"],
        longitude = map["longitude"],
        finalidade = map["finalidade"],
        outraFinalidade = map["outraFinalidade"],
        ambiente = map["ambiente"],
        outroAmbiente = map["outroAmbiente"],
        tipoCultivo = map["tipoCultivo"],
        outroTipoCultivo = map["outroTipoCultivo"],
        nomeProduto = map["nomeProduto"],
        atividades = (map['atividades'] as List<dynamic>?)
                ?.map((activity) => BatchActivity.fromMap(activity))
                .toList() ??
            [];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nomeLote": nomeLote,
      "largura": largura,
      "comprimento": comprimento,
      "area": area,
      "latitude": latitude,
      "longitude": longitude,
      "finalidade": finalidade,
      "outraFinalidade": outraFinalidade,
      "ambiente": ambiente,
      "outroAmbiente": outroAmbiente,
      "tipoCultivo": tipoCultivo,
      "outroTipoCultivo": outroTipoCultivo,
      "nomeProduto": nomeProduto,
      'atividades': atividades.map((activity) => activity.toMap()).toList(),
    };
  }
*/
