import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import './questionario.dart';
import './resultado.dart';
import './home.dart';
import './theme.dart';

void main() {
  runApp(const PerguntaApp());
}

class PerguntaApp extends StatefulWidget {
  const PerguntaApp({super.key});

  @override
  State<PerguntaApp> createState() => _PerguntaAppState();
}

class _PerguntaAppState extends State<PerguntaApp> {
  int _perguntaSelecionada = 0;
  int _pontuacaoTotal = 0;
  bool _started = false;

  List<Map<String, Object>> _perguntas = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarPerguntasDoJson();
  }

  Future<void> _carregarPerguntasDoJson() async {
    try {
      final raw = await rootBundle.loadString('assets/quiz.json');
      final data = json.decode(raw);

      if (data is! Map || data['questions'] == null) {
        throw Exception('Estrutura JSON inválida: campo "questions" ausente.');
      }

      final List questions = data['questions'];
      for (final q in questions) {
        if (q['options'] == null ||
            q['options'] is! List ||
            (q['options'] as List).length != 5) {
          throw Exception(
            'Pergunta ${q['id'] ?? '(sem id)'} deve ter 5 opções.',
          );
        }
        final ai = q['answerIndex'];
        if (ai is! int || ai < 0 || ai > 4) {
          throw Exception(
            'Pergunta ${q['id'] ?? '(sem id)'} answerIndex inválido.',
          );
        }
      }

      final List<Map<String, Object>> perguntasConvertidas = questions
          .map<Map<String, Object>>((q) {
            final List opts = q['options'];
            return {
              'texto': (q['text'] ?? '') as String,
              'categoria': (q['category'] ?? '') as String,
              'explicacao': (q['explanation'] ?? '') as String,
              'respostas': List<Map<String, Object>>.generate(5, (i) {
                final txt = (opts[i] ?? '').toString();
                final isCorrect = (q['answerIndex'] as int) == i;
                return {'texto': txt, 'pontuacao': isCorrect ? 1 : 0};
              }),
            };
          })
          .toList();

      setState(() {
        _perguntas = perguntasConvertidas;
        _carregando = false;
        _erro = null;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
        _erro = e.toString();
      });
    }
  }

  void _responder(int pontuacao) {
    setState(() {
      _pontuacaoTotal += pontuacao;
      _perguntaSelecionada++;
    });
  }

  void _reiniciarQuestionario() {
    setState(() {
      _perguntaSelecionada = 0;
      _pontuacaoTotal = 0;
      _started = false; // volta para a Home
    });
  }

  bool get _temPerguntaSelecionada =>
      !_carregando && _erro == null && _perguntaSelecionada < _perguntas.length;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: _started
          ? Scaffold(
              appBar: AppBar(title: const Text('Quiz Anos 90')),
              body: _carregando
                  ? const _Carregando()
                  : (_erro != null)
                  ? _Erro(
                      mensagem: _erro!,
                      onTentarNovamente: _carregarPerguntasDoJson,
                    )
                  : _temPerguntaSelecionada
                  ? Questionario(
                      perguntas: _perguntas,
                      perguntaSelecionada: _perguntaSelecionada,
                      quandoResponder: _responder,
                    )
                  : Resultado(
                      pontuacao: _pontuacaoTotal,
                      total: _perguntas.length,
                      onReiniciar: _reiniciarQuestionario,
                    ),
            )
          : HomeScreen(
              onStart: () {
                setState(() {
                  _started = true;
                });
              },
            ),
    );
  }
}

class _Carregando extends StatelessWidget {
  const _Carregando();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando perguntas...'),
          ],
        ),
      ),
    );
  }
}

class _Erro extends StatelessWidget {
  final String mensagem;
  final Future<void> Function() onTentarNovamente;

  const _Erro({required this.mensagem, required this.onTentarNovamente});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Não foi possível carregar o quiz.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              mensagem,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onTentarNovamente,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
