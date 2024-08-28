import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listadecontatos/model/contatos_model.dart';
import 'package:listadecontatos/repositories/contatos_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;

  final ImagePicker picker = ImagePicker();
  var contatosRepository = ContatosRepository();
  ContatosModel contatosModel = ContatosModel();

  createNewContact() {
    XFile? tempImage;
    var nomeController = TextEditingController(text: "");
    var numeroController = TextEditingController(text: "");

    saveContact() async {
      var contatoParaAdicionar = Contato(
          nome: nomeController.text.trim(),
          numero: numeroController.text.trim(),
          imagePath: tempImage!.path);
      try {
        await contatosRepository.create(contatoParaAdicionar);
      } catch (e) {
        rethrow;
      }
      Navigator.pop(context);
      carregarContatos();
    }

    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text(
                  "Criando um novo usuario",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    TextField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                            label: Text("Nome"), border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(
                        keyboardType: TextInputType.phone,
                        autocorrect: false,
                        inputFormatters: [
                          MaskedInputFormatter('(##) #####-####')
                        ],
                        controller: numeroController,
                        decoration: const InputDecoration(
                            label: Text("Numero"),
                            border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    const Text(
                      "Imagem",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    ClipOval(
                      child: InkWell(
                        onTap: () async {
                          tempImage = await picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {});
                        },
                        child: SizedBox(
                            width: 128,
                            height: 128,
                            child: tempImage == null
                                ? const Icon(Icons.image)
                                : SizedBox(
                                    child: Image.file(
                                    File(tempImage!.path),
                                    fit: BoxFit.cover,
                                  ))),
                      ),
                    )
                  ],
                ),
                actions: [
                  TextButton(onPressed: saveContact, child: Text("Salvar"))
                ],
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    carregarContatos();
  }

  carregarContatos() async {
    setState(() {
      loading = true;
    });
    contatosModel = await contatosRepository.getAll();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contatos"),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : contatosModel.contatos.isEmpty
              ? const Center(
                  child: Text(
                    "Sem contatos",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  itemCount: contatosModel.contatos.length,
                  itemBuilder: (context, index) {
                    var contato = contatosModel.contatos[index];

                    return _contatoTile(contato);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewContact,
        child: const Icon(Icons.add),
      ),
    );
  }

  ListTile _contatoTile(Contato contato) {
    detalhes() {
      delete() async {
        await contatosRepository.delete(contato);
        Navigator.pop(context);
        carregarContatos();
      }

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Row(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Image.file(
                          File(contato.imagePath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(contato.nome!),
                  ],
                ),
                content: Text("Numero: ${contato.numero}"),
                actions: [
                  TextButton(
                      onPressed: delete,
                      child: const Text(
                        "Deletar",
                        style: TextStyle(color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar")),
                ],
              ));
    }

    return ListTile(
      onTap: detalhes,
      leading: Padding(
        padding: const EdgeInsets.all(4),
        child: ClipOval(
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.file(
              File(contato.imagePath!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(contato.nome!),
      subtitle: Text(contato.numero!),
    );
  }
}
