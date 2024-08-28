import 'package:listadecontatos/model/contatos_model.dart';
import 'package:listadecontatos/repositories/custom_dio/contatos_dio.dart';

class ContatosRepository {
  ContatosDio contatosDio = ContatosDio();
  create(Contato contato) async {
    String whereClause = "?where={ \"numero\": \"${contato.numero}\" }";
    var response = await contatosDio.dio.get("classes/contato$whereClause");
    var semelhantes = ContatosModel.fromJson(response.data);
    if (semelhantes.contatos.isNotEmpty) {
      throw "ja existe no banco";
    }
    await contatosDio.dio.post("classes/contato", data: contato);
  }

  delete(Contato contato) async {
    await contatosDio.dio.delete("classes/contato/${contato.objectId}");
  }

  Future<ContatosModel> getAll() async {
    var response = await contatosDio.dio.get("classes/contato");
    return ContatosModel.fromJson(response.data);
  }
}
