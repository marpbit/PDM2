import 'package:flutter/material.dart';

void main() => runApp(const ExemploBase());

class ExemploBase extends StatelessWidget {
  const ExemploBase({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExemploBasePage(),
    );
  }
}

// ========== 1) TELA INICIAL — ESCOLHA DE CATEGORIA ==========
class ExemploBasePage extends StatelessWidget {
  const ExemploBasePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cardápio')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Escolha uma categoria'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ComidasPage()),
                  ),
                  child: const Text(' Comidas'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BebidasPage()),
                  ),
                  child: const Text(' Bebidas'),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PedidoPage()),
                ),
                child: const Text('Fazer um pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== 2) TELA DE BEBIDAS — LISTA SIMPLES ==========
class BebidasPage extends StatelessWidget {
  const BebidasPage({super.key});
  @override
  Widget build(BuildContext context) {
    final itens = const [
      ('Suco de Laranja', Icons.local_drink),
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

// ========== 3) TELA DE COMIDAS — CARDS BÁSICOS ==========
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
            padding: const EdgeInsets.all(8), // Container (L1)
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              // Row (L1)
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  color: Colors.grey[300],
                ), // “imagem” fake
                const SizedBox(width: 8), // SizedBox (L1)
                Expanded(
                  // Expanded (L2)
                  child: Column(
                    // Column (L1)
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(descricao),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PedidoPage(),
                              ),
                            ),
                            child: const Text('Pedir'),
                          ),
                          const Spacer(), // Spacer (L2)
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

// ========== 4) TELA DE PEDIDO — FORMULÁRIO  ==========
class PedidoPage extends StatelessWidget {
  const PedidoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16), // Padding (L2)
        child: Column(
          // Column (L1)
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
