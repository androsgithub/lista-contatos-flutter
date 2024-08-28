class ContatosModel {
  List<Contato> contatos = [];

  ContatosModel();

  ContatosModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      contatos = <Contato>[];
      json['results'].forEach((v) {
        contatos.add(Contato.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['results'] = contatos.map((v) => v.toJson()).toList();

    return data;
  }
}

class Contato {
  String? objectId;
  String? nome;
  String? numero;
  String? imagePath;
  String? createdAt;
  String? updatedAt;

  Contato(
      {this.objectId,
      this.nome,
      this.numero,
      this.imagePath,
      this.createdAt,
      this.updatedAt});

  Contato.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    nome = json['nome'];
    numero = json['numero'];
    imagePath = json['image_path'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['nome'] = nome;
    data['numero'] = numero;
    data['image_path'] = imagePath;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
