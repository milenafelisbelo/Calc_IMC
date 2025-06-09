import 'package:flutter/material.dart';

class ImcScreen extends StatefulWidget {
  const ImcScreen({super.key});

  @override
  State<ImcScreen> createState() => _ImcScreenState();
}

class _ImcScreenState extends State<ImcScreen> {
  String nome = '';
  double altura = 0;
  double peso = 0;
  double resultado = 0;
  String classificacao = '';
  final _formKey = GlobalKey<FormState>();

  void calcularImc() {
    if (altura <= 0 || peso <= 0) return;
    
    double imc = peso / (altura * altura);
    setState(() {
      resultado = imc;
      // Lógica de classificação mantida igual
      if (imc < 16) {
        classificacao = 'Magreza grave';
      } else if (imc < 17) {
        classificacao = 'Magreza moderada';
      } else if (imc < 18.5) {
        classificacao = 'Magreza leve';
      } else if (imc < 25) {
        classificacao = 'Saudável';
      } else if (imc < 30) {
        classificacao = 'Sobrepeso';
      } else if (imc < 35) {
        classificacao = 'Obesidade Grau I';
      } else if (imc < 40) {
        classificacao = 'Obesidade Grau II (severa)';
      } else {
        classificacao = 'Obesidade Grau III (mórbida)';
      }
    });
  }

  void validar(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    calcularImc();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultado para $nome'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Seu IMC é: ${resultado.toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              Text('Classificação: $classificacao'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora IMC"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Digite seu nome' : null,
                onChanged: (value) => nome = value,
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Altura (m)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final val = double.tryParse(value ?? '');
                  return val == null || val <= 0 ? 'Altura inválida' : null;
                },
                onChanged: (value) => altura = double.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final val = double.tryParse(value ?? '');
                  return val == null || val <= 0 ? 'Peso inválido' : null;
                },
                onChanged: (value) => peso = double.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => validar(context),
                child: const Text('CALCULAR IMC'),
              ),
              const SizedBox(height: 30),
              // CORREÇÃO DO IF - FORMA 1 (RECOMENDADA)
              Visibility(
                visible: resultado > 0,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text('IMC: ${resultado.toStringAsFixed(2)}'),
                        Text(classificacao),
                      ],
                    ),
                  ),
                ),
              ),
              // OU FORMA 2 (ALTERNATIVA)
              // if (resultado > 0)
              //   Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(20),
              //       child: Column(
              //         children: [
              //           Text('IMC: ${resultado.toStringAsFixed(2)}'),
              //           Text(classificacao),
              //         ],
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}