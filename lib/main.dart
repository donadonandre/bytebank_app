import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(ByteBankApp());

class ByteBankApp extends StatelessWidget {
  const ByteBankApp({Key key}) : super(key: key);

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
        double.tryParse(_controladorNumeroConta.text);

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


class ListaTransferencias extends StatelessWidget {

  final List<Transferencia> _transferencias = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Tranferências'),),
      body:
          ListView.builder(
              itemCount: _transferencias.length,
              itemBuilder: (context, indice){
                final transferencia = _transferencias[indice];
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
              _transferencias.add(transferenciaRecebida);
            });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
