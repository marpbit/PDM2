import 'package:flutter/material.dart';

class Resultado extends StatelessWidget {
  final int pontuacao;
  final int total;
  final VoidCallback onReiniciar;

  const Resultado({
    super.key,
    required this.pontuacao,
    required this.total,
    required this.onReiniciar,
  });

  String _mensagem(double pct) {
    if (pct >= 0.9) return 'Nostalgia em nível MÁXIMO! 🏆';
    if (pct >= 0.75) return 'Você mandou muito bem! ✨';
    if (pct >= 0.5) return 'Bom! Que tal tentar de novo? 🙂';
    return 'Tá valendo! Bora relembrar mais dos anos 90? 😉';
  }

  String _emoji(double pct) {
    if (pct >= 0.9) return '🎉';
    if (pct >= 0.75) return '🌟';
    if (pct >= 0.5) return '👍';
    return '🕹️';
  }

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? pontuacao / total : 0.0;
    final pctStr = (pct * 100).toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              _emoji(pct),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 56),
            ),
            const SizedBox(height: 12),
            Text(
              'Parabéns!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _mensagem(pct),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Sua pontuação',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$pontuacao / $total',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$pctStr% de acertos',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: onReiniciar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onReiniciar,
              icon: const Icon(Icons.home),
              label: const Text('Voltar ao início'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
