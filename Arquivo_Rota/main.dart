import 'package:flutter/material.dart';

void main() => runApp(const ExemploBase());

// ======================== APP PRINCIPAL ========================
class ExemploBase extends StatelessWidget {
  const ExemploBase({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App da Cozinha',
      // Define todas as rotas do app
      routes: {
        '/': (context) => const TelaInicial(),
        '/comidas': (context) => const ComidasPage(),
        '/bebidas': (context) => const BebidasPage(),
        '/pedido': (context) => const PedidoPage(),
      },
    );
  }
}

// ======================== 1) TELA INICIAL ========================
class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(''), // vazio
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // centraliza verticalmente
            children: [
              const Text(
                'Cardápio',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 24),

              // Botão Comidas
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/comidas'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(' Comidas'),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Botão Bebidas
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/bebidas'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(' Bebidas'),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Link para pedido
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/pedido'),
                child: const Text('Fazer um pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================== 2) TELA DE BEBIDAS ========================
class BebidasPage extends StatelessWidget {
  const BebidasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final itens = const [
      ('Suco de laranja', Icons.local_drink),
      ('Refrigerante', Icons.local_cafe),
      ('Água Mineral', Icons.water_drop),
      ('Chá Gelado', Icons.emoji_food_beverage),
      ('Milkshake', Icons.icecream),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Bebidas')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: itens.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final (nome, icone) = itens[i];
          return Row(
            children: [Icon(icone), const SizedBox(width: 8), Text(nome)],
          );
        },
      ),
    );
  }
}

// ======================== 3) TELA DE COMIDAS ========================
class ComidasPage extends StatelessWidget {
  const ComidasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final itens = const [
      ('Hambúrguer', 'Blend 160g, queijo e salada.'),
      ('Salada Caesar', 'Alface, frango, croutons.'),
      ('Massa ao Sugo', 'Tomate e manjericão.'),
      ('Risoto', 'Cremoso com cogumelos.'),
      ('Tábua de Queijos', 'Seleção com geleias.'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Comidas')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: itens.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final (titulo, descricao) = itens[i];
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(width: 64, height: 64, color: Colors.grey[300]),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(descricao),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/pedido'),
                            child: const Text('Pedir'),
                          ),
                          const Spacer(),
                          const Text('15-20 min'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ======================== 4) TELA DE PEDIDO ========================
class PedidoPage extends StatelessWidget {
  const PedidoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Mesa (número)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Observações',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pedido enviado!')),
                );
              },
              child: const Text('Enviar pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
