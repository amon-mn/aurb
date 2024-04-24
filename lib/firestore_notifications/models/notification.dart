import 'package:aurb/firestore_notifications/models/location.dart';

class UserNotification {
  String id;
  String tipo;
  String? descricao;
  String risco;
  String data;
  Location? loc;
  String? status = "Não Iniciado";

  UserNotification({
    required this.id,
    required this.tipo,
    this.descricao,
    this.loc,
    required this.risco,
    required this.data,
    this.status,
  });

  UserNotification.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        tipo = map["tipo"],
        descricao = map["descricao"],
        loc = map['loc'] != null ? Location.fromMap(map['loc']) : null,
        risco = map["risco"],
        data = map['data'],
        status = map['status'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "tipo": tipo,
      "descricao": descricao ?? "",
      "loc": loc?.toMap(),
      "risco": risco,
      "data": data,
      "status": status,
    };
  }
}
