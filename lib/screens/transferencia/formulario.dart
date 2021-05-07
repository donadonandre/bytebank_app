import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _tituloAppBar = 'Criando Transferência';
const _rotuloCampoValor = 'Valor';
const _dicaCampoValor = '0.00';
const _rotuloCampoNumeroConta = 'Conta';
const _dicaCampoNumeroConta = '0000';
const _botaoConfirmar = 'Confirmar';

class FormularioTransferencia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controladorNumeroConta = TextEditingController();
  final TextEditingController _controladorValor = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloAppBar),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
                controlador: _controladorNumeroConta,
                rotulo: _rotuloCampoNumeroConta,
                dica: _dicaCampoNumeroConta,
            ),
            Editor(
                controlador: _controladorValor,
                rotulo: _rotuloCampoValor,
                dica: _dicaCampoValor,
                icone: Icons.monetization_on
            ),
            ElevatedButton(
                onPressed: () => _criaTransferencia(context),
                child: Text(_botaoConfirmar)),
          ],
        ),
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
      Navigator.pop(context, transferenciaCriada);
    }
  }

}