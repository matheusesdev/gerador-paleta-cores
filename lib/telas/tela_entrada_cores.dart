import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Importar Animate

class TelaEntradaCores extends StatefulWidget {
  const TelaEntradaCores({Key? key}) : super(key: key);

  @override
  _TelaEntradaCoresState createState() => _TelaEntradaCoresState();
}

class _TelaEntradaCoresState extends State<TelaEntradaCores> {
  final _controller = TextEditingController();
  static const int maximoCoresPermitidas = 17; // Manter o limite

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navegarParaPaleta() {
    final String textoEntrada = _controller.text;
    final int? numero = int.tryParse(textoEntrada);

    if (numero != null && numero >= 1 && numero <= maximoCoresPermitidas) {
      HapticFeedback.lightImpact(); // Feedback tátil
      Navigator.pushNamed(
        context,
        '/paleta',
        arguments: numero,
      );
    } else {
      _mostrarMensagemErro(
          "Entrada inválida. Insira um número entre 1 e $maximoCoresPermitidas.");
    }
  }

  void _mostrarMensagemErro(String mensagem) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: TextStyle(color: Theme.of(context).colorScheme.onError)),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating, // Estilo flutuante
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: const EdgeInsets.all(10.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // Sem AppBar explícita, usa a cor de fundo do tema
      body: SafeArea( // Garante que não fique sob status bar/notches
        child: Center( // Centraliza o conteúdo verticalmente
          child: SingleChildScrollView( // Permite rolagem se o conteúdo for maior
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: ConstrainedBox( // Limita a largura em telas grandes
               constraints: const BoxConstraints(maxWidth: 400),
               child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Título no corpo da tela
                    Text(
                      'Gerador de Paletas',
                      style: textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2), // Animação

                    const SizedBox(height: 15.0),

                    // Texto de instrução
                    Text(
                      'Quantas cores você quer? (1 a $maximoCoresPermitidas)',
                      style: textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms, duration: 600.ms), // Animação

                    const SizedBox(height: 30.0),

                    // Campo de texto estilizado pelo tema
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration( // Usa tema, mas pode adicionar ícone
                         // labelText: 'Número de cores', // Label pode ser redundante
                         hintText: 'Digite o número aqui',
                         prefixIcon: Icon(Icons.palette_outlined),
                      ),
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), // Estilo do texto digitado
                    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideX(begin: 0.5), // Animação

                    const SizedBox(height: 40.0),

                    // Botão com ícone, estilizado pelo tema e animado
                    ElevatedButton.icon(
                      icon: const Icon(Icons.auto_awesome_mosaic_outlined), // Ícone
                      label: const Text('Gerar Paleta'),
                      onPressed: _navegarParaPaleta,
                    ).animate(delay: 600.ms)
                     .fadeIn(duration: 500.ms)
                     .slideY(begin: 0.3)
                     .then(delay: 200.ms) // Efeito de "pop" após aparecer
                     .scaleXY(end: 1.05, duration: 150.ms, curve: Curves.easeOut)
                     .then()
                     .scaleXY(end: 1/1.05, duration: 200.ms, curve: Curves.easeIn),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }
}