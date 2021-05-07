import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(ByteBankApp());

class ByteBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTransferencias(),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controladorNumeroConta = TextEditingController();
  final TextEditingController _controladorValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando Transferência'),
      ),
      body: Column(
        children: <Widget>[
          Editor(
              controlador: _controladorNumeroConta,
              rotulo: 'Número da conta',
              dica: '0000'
          ),
          Editor(
              controlador: _controladorValor,
              rotulo: 'Valor',
              dica: '0.00' ,
              icone: Icons.monetization_on
          ),
          ElevatedButton(
              onPressed: () => _criaTransferencia(context),
              child: Text('Confirmar'))
        ],
      ),
    );
  }

  void _criaTransferencia(BuildContext context) {
    final int numeroConta =
        int.tryParse(_controladorNumeroConta.text);
    final double valor =
        double.tryParse(_controladorValor.text);

    if (numeroConta!=null && valor!=null) {
        final transferenciaCriada = Transferencia(valor, numeroConta);
        debugPrint('$transferenciaCriada');
        Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {

  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;

  // Item obrigatorio eu coloco fora dos {}
  Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
            icon: icone != null ? Icon(icone) : null,
            labelText: rotulo,
            hintText: dica),
        keyboardType: TextInputType.number,
      ),
    );
  }
}


class ListaTransferencias extends StatefulWidget {
  final List<Transferencia> _transferencias = List();

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciasState();
  }
}

// O Stateful precisa traballhar com um state
class ListaTransferenciasState extends State<ListaTransferencias> {
  @override
  Widget build(BuildContext context) {
    //widget._transferencias.add(Transferencia(300, 4000));

    return Scaffold(
      appBar: AppBar(title: Text('Tranferências'),),
      body:
      ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice){
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future<Transferencia> future = Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));
          future.then((transferenciaRecebida) {
            debugPrint('Chegou no Then do future');
            debugPrint('$transferenciaRecebida');
            widget._transferencias.add(transferenciaRecebida);
            final tamanho = widget._transferencias.length;
            debugPrint('Tamanho: $tamanho');
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
  // Nesse caso é só pegar o build do Stateless que fizemos antes
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia {
    final double valor;
    final int numeroConta;

    Transferencia(this.valor, this.numeroConta);

    @override
    String toString() {
        return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
    }
}
