import 'package:flutter/material.dart';

class Questionario extends StatefulWidget {
  final List<Map<String, Object>> perguntas;
  final int perguntaSelecionada;
  final Function(int) quandoResponder;

  const Questionario({
    super.key,
    required this.perguntas,
    required this.perguntaSelecionada,
    required this.quandoResponder,
  });

  @override
  State<Questionario> createState() => _QuestionarioState();
}

class _QuestionarioState extends State<Questionario> {
  int? _selectedIndex;
  bool _answered = false;
  bool _isCorrect = false;

  void _onOptionTap(int index, int pontuacao) {
    if (_answered) return;
    setState(() {
      _selectedIndex = index;
      _answered = true;
      _isCorrect = pontuacao > 0;
    });

    // Aguarda um curto período para mostrar feedback + explicação
    Future.delayed(const Duration(milliseconds: 1100), () {
      widget.quandoResponder(pontuacao);
      if (!mounted) return;
      setState(() {
        _selectedIndex = null;
        _answered = false; // esconde o feedback
        // NÃO altere _isCorrect aqui
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.perguntas.length;
    final idx = widget.perguntaSelecionada;
    final perguntaAtual = widget.perguntas[idx];
    final texto = (perguntaAtual['texto'] ?? '') as String;
    final categoria = (perguntaAtual['categoria'] ?? '') as String;
    final explicacao = (perguntaAtual['explicacao'] ?? '') as String;
    final respostas = (perguntaAtual['respostas'] as List<Map<String, Object>>);

    final progress = (idx + 1) / total;

    return Semantics(
      label: 'Tela do quiz: questão ${idx + 1} de $total',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabeçalho com progresso
            Text(
              'Questão ${idx + 1}/$total',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                semanticsLabel: 'Barra de progresso do quiz',
              ),
            ),
            const SizedBox(height: 12),
            if (categoria.isNotEmpty)
              Text(
                'Categoria: ${categoria.toUpperCase()}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: .5,
                ),
              ),
            const SizedBox(height: 16),
            // Enunciado
            Text(texto, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            // Opções
            ...List.generate(respostas.length, (i) {
              final r = respostas[i];
              final rTexto = (r['texto'] ?? '') as String;
              final rScore = (r['pontuacao'] ?? 0) as int;

              Color? bg;
              Color? fg;
              OutlinedBorder? shape = RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              );

              if (_answered) {
                if (i == _selectedIndex) {
                  if (_isCorrect) {
                    bg = Colors.green.withOpacity(0.18);
                    fg = Colors.green.shade900;
                  } else {
                    bg = Colors.red.withOpacity(0.18);
                    fg = Colors.red.shade900;
                  }
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Semantics(
                  button: true,
                  label: 'Opção ${i + 1}: $rTexto',
                  enabled: !_answered,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48), // alvo ≥ 44dp
                      backgroundColor: bg,
                      foregroundColor: fg,
                      shape: shape,
                    ),
                    onPressed: _answered ? null : () => _onOptionTap(i, rScore),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(rTexto, textAlign: TextAlign.left),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),

            // Feedback + Explicação curta
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: _answered
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Container(
                decoration: BoxDecoration(
                  color: (_isCorrect
                      ? Colors.green.withOpacity(0.08)
                      : Colors.red.withOpacity(0.08)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isCorrect ? Colors.green : Colors.red,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _isCorrect ? Icons.check_circle : Icons.cancel,
                      color: _isCorrect ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isCorrect ? 'Acertou!' : 'Ops, não foi dessa vez!',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          if (explicacao.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              explicacao,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),

            const Spacer(),
            // Dica de acessibilidade
            Text(
              'Dica: você pode tocar em qualquer opção para responder.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
