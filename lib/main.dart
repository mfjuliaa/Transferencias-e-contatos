import 'package:flutter/material.dart';

void main() => runApp(BankApp());

class BankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Dashboard(),
      debugShowCheckedModeBanner: false, // Ocultar o banner de debug
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[900],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD1C4E9), // Lilás pastel
                  foregroundColor: Colors.white,
                  minimumSize: Size(200, 50),
                ),
                child: const Text('Contatos'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListaContatos()),
                  );
                },
              ),
              SizedBox(height: 20), // Espaçamento entre os botões
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC8E6C9), // Verde pastel
                  foregroundColor: Colors.white,
                  minimumSize: Size(200, 50),
                ),
                child: const Text('Transferência'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListaTransferencia()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modelo de Contato
class Contato {
  final String nome, endereco, telefone, email, cpf;
  Contato(this.nome, this.endereco, this.telefone, this.email, this.cpf);
}

// Lista de Contatos
class ListaContatos extends StatefulWidget {
  final List<Contato> contatos = [];
  @override
  _ListaContatosState createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Contatos'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: widget.contatos.length,
        itemBuilder: (context, index) {
          final contato = widget.contatos[index];
          return ListTile(
            title: Text(contato.nome),
            subtitle: Text('Telefone: ${contato.telefone}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final novoContato = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormularioContato()),
          );
          if (novoContato != null) {
            setState(() {
              widget.contatos.add(novoContato);
            });
          }
        },
      ),
    );
  }
}

// Formulário de Cadastro de Contato
class FormularioContato extends StatelessWidget {
  final controllers = List.generate(5, (index) => TextEditingController());
  final labels = ['Nome', 'Endereço', 'Telefone', 'Email', 'CPF'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Contato')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ...List.generate(5, (index) => TextField(
                controller: controllers[index],
                decoration: InputDecoration(labelText: labels[index]),
              )),
              ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () {
                  final novoContato = Contato(
                    controllers[0].text,
                    controllers[1].text,
                    controllers[2].text,
                    controllers[3].text,
                    controllers[4].text,
                  );
                  Navigator.pop(context, novoContato);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Lista de Transferências
class ListaTransferencia extends StatefulWidget {
  final List<Transferencia> transferencias = [];
  @override
  _ListaTransferenciaState createState() => _ListaTransferenciaState();
}

class _ListaTransferenciaState extends State<ListaTransferencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: widget.transferencias.length,
        itemBuilder: (context, index) {
          final transferencia = widget.transferencias[index];
          return ListTile(
            title: Text('Valor: ${transferencia.valor.toString()}'),
            subtitle: Text('Conta: ${transferencia.numeroConta.toString()}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final novaTransferencia = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormularioTransferencia()),
          );
          if (novaTransferencia != null) {
            setState(() {
              widget.transferencias.add(novaTransferencia);
            });
          }
        },
      ),
    );
  }
}

// Formulário de Transferência
class FormularioTransferencia extends StatelessWidget {
  final controllers = List.generate(2, (index) => TextEditingController());
  final labels = ['Número da Conta', 'Valor'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criando Transferência')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ...List.generate(2, (index) => TextField(
                controller: controllers[index],
                decoration: InputDecoration(labelText: labels[index]),
                keyboardType: index == 0 ? TextInputType.number : TextInputType.numberWithOptions(decimal: true),
              )),
              ElevatedButton(
                child: const Text('Confirmar'),
                onPressed: () {
                  final numeroConta = int.tryParse(controllers[0].text);
                  final valor = double.tryParse(controllers[1].text);
                  if (numeroConta != null && valor != null) {
                    Navigator.pop(context, Transferencia(valor, numeroConta));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modelo de Transferência
class Transferencia {
  final double valor;
  final int numeroConta;
  Transferencia(this.valor, this.numeroConta);
}
