import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onStart;
  const HomeScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFA3B18A),
      appBar: AppBar(
        backgroundColor: const Color(0xFFdad7cd),
        title: const Text('Quiz Anos 90', style: TextStyle(fontSize: 30)),
      ),
      body: Semantics(
        label: 'Tela inicial do quiz',
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                '\n\nVolta aos Anos 90',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '\n\nTeste sua memória em músicas, TV e brinquedos clássicos!\n\nSão 12 perguntas com feedback em cada uma, e um resultado no final com a sua pontuação.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              // Ilustração temática simples com ícones
              Expanded(
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _Pill(icon: Icons.music_note, label: 'Músicas'),
                      _Pill(icon: Icons.tv, label: 'TV'),
                      _Pill(icon: Icons.toys, label: 'Brinquedos'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Dica de acessibilidade
              Text(
                'Dica: use o leitor de tela para ouvir a descrição dos botões.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: scheme.outline),
              ),
              const SizedBox(height: 12),
              Semantics(
                button: true,
                label: 'Começar o quiz dos anos 90',
                child: ElevatedButton.icon(
                  onPressed: onStart,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Começar'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
