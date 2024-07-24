import 'package:aurb/firestore_notifications/models/location.dart';

class UserNotification {
  String id;
  String tipo;
  String? natureza;
  String? descricao;
  String risco;
  String data;
  String? empresa;
  String? linha;
  Location? loc;
  String? status = "Não Iniciado";
  String? authorName;
  String? authorCpf;
  String? authorId;
  bool? isAnonymous;

  UserNotification({
    required this.id,
    required this.tipo,
    this.natureza,
    this.descricao,
    this.loc,
    required this.risco,
    required this.data,
    this.empresa,
    this.linha,
    this.status,
    this.authorName,
    this.authorCpf,
    this.authorId,
    this.isAnonymous,
  });

  UserNotification.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        natureza = map["natureza"],
        tipo = map["tipo"],
        descricao = map["descricao"],
        loc = map['loc'] != null ? Location.fromMap(map['loc']) : null,
        risco = map["risco"],
        data = map['data'],
        empresa = map['empresa'],
        linha = map['linha'],
        status = map['status'],
        authorName = map['authorName'],
        authorCpf = map['authorCpf'],
        authorId = map['authorId'],
        isAnonymous = map['isAnonymous'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "natureza": natureza,
      "tipo": tipo,
      "descricao": descricao ?? "",
      "loc": loc?.toMap(),
      "risco": risco,
      "data": data,
      "empresa": empresa ?? "",
      "linha": linha ?? "",
      "status": status,
      "authorName": authorName ?? "",
      "authorCpf": authorCpf ?? "",
      "authorId": authorId ?? "",
      "isAnonymous": isAnonymous ?? false,
    };
  }
}
