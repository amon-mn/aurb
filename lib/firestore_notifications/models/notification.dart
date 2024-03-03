class UserNotification {
  String id;
  String tipo;
  String? descricao;
  double latitude;
  double longitude;
  String risco;
  String data;

  UserNotification({
    required this.id,
    required this.tipo,
    this.descricao,
    required this.latitude,
    required this.longitude,
    required this.risco,
    required this.data,
  });

  UserNotification.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        tipo = map["tipo"],
        descricao = map["descricao"],
        latitude = map["latitude"].toDouble(),
        longitude = map["longitude"].toDouble(),
        risco = map["risco"],
        data = map['data'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "tipo": tipo,
      "descricao": descricao ?? "",
      "latitude": latitude,
      "longitude": longitude,
      "risco": risco,
      "data": data,
    };
  }
} // Lista de atividades


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
